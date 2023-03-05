# ADK Wrapped

## Architecture

- A training component that restructures the data into a series of achievements / presentable statistics. This *could* be handled using `dbt`/`SQL` with a sprinkle of Python on top of a DuckDB database, since our dataset is relatively small. I'll have to think about this some more.
- A transfer component that communicates the data to the presentation layer via API. This should be handled by a Flask/FastAPI app.
- A presentation component that displays the data in a meaningful/beautiful way. This could be handled either by Flask or by React.

In practice, it might be worthwhile to merge the transfer and presentation components into a single component.

----

## If we do it like that:

### Setup

- Create a `requirements.txt` file with `dbt-duckdb`, `flask`/`FastAPI` and `pandas` as dependencies.
- Create a `data/` folder that's ignored by git, with the file from Vašek in it. (Forward it to collaborators.)
- ~~Run `dbt init` to create a `dbt_project.yml` file, as well as the file structure.~~ This is now part of the repository.
    - Create, or add to, `~/.dbt/profiles.yml` with the following contents, replacing {username} with your account username (or, if not using Windows, the path you wish to store the DuckDB database in):
        ```yaml
        adk_wrapped:
            outputs:
                dev:
                path: "C:\\Users\\{username}\\.dbt\\adk_wrapped.db"
                schema: adk_wrapped
                type: duckdb
                threads: 4
                extensions:
                    - httpfs
                    - parquet
            target: dev
        ```
    - Add `clovek_debata.csv` to the `seeds/` folder. Make sure it's not committed to git (it should be in `.gitignore`, but make sure anyway).
    - Run `dbt seed` to load the data into the database.
- Create a `adk_wrapped/` folder with a `__init__.py` file in it, and a `app.py` file in it. That's where Flask/FastAPI will run.

### Endpoints

- `/` and `/gdpr` to handle initial consent and GDPR compliance (?).
- `/set-person/{person_id_base64}` to set the person ID in the session.
- `/achievements` to pass the achievements to the presentation layer.
- `/achievement/{achievement_name}` to pass a single achievement (with extra details?) to the presentation layer.

