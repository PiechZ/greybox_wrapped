# ADK Wrapped

ADK Wrapped is a project that allows us to display statistics and achievements from academic debates.
As the Czech Debating Association, we track all academic debates that take place at our events. From this database, data can be extracted to analyse performance and award individuals with achievements.
This project will allow us to analyse the data and award individuals' achievements on the backend. On the frontend, individuals will be able to request personalised presentation of their achievements each year, just as other applications do a "rewind" of the year.

## Architecture

We're using a standard client-server architecture with a stationary pre-filled backend database.

- `sql_prep/`: A training component that restructures the data into a series of achievements / presentable statistics. **This is handled using dbt/SQL with a sprinkle of Python on top of a DuckDB database**, since our dataset is small (&lt;50MB).
- `backend/`: A transfer component that communicates the data to the presentation layer via API. **FastAPI handles this.**
- `frontend/`: A presentation component that displays the data in a meaningful/beautiful way. **React/Spectacle handles this.**

```mermaid
graph TD
  A(Spectacle) -->|Sends request to| B(FastAPI)
  B(FastAPI)   -->|Processes request and retrieves data from| C(DuckDB)
  B(FastAPI)   -->|Sends data to| A(Spectacle)
```

## Environment

1. Get a DuckDB export of the dataset and place it in `data/adk_wrapped.db`.
2. Create a `profiles.yml` file in `~/.dbt` with the following contents:
    ```yaml
    adk_wrapped:
        outputs:
            dev:
                path: "path/to/data/adk_wrapped.db"
                schema: adk_wrapped
                type: duckdb
                threads: 4
                extensions:
                    - httpfs
                    - parquet
        target: dev
    ```
2. For local development, run `make setup` to install the dependencies, including and especially `dbt-duckdb`. (This doesn't set up the frontend, though.)
    1. Run `make run` to let `dbt` populate the database with transformations.
    2. Run `make backend` to start the FastAPI server.
    3. In a separate terminal, run `make frontend` to start the React server. (To be able to do that, you'll need to set up [Node Version Manager for Windows - `nvm`](https://github.com/coreybutler/nvm-windows) first and, using it, Node v18.15.0.)
3. For deployment/testing, `docker-compose up` should do everything.

## Endpoints _(To settle)_

### React/Spectacle

- `/` displays a prompt to go back to Greybox 2.0 and follow the requisite link.
- `/slides/{person_id}` to display the achievements of a given person.
- NOT DONE: `/link/{hash}` to display the achievements of a given person, with a lookup provided via a rainbow table entry.

### FastAPI

- `/api` to display the API documentation.
- `/api/achievements/{greybox_id}` to pass the achievements to the presentation layer.

