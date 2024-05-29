## Running the data preparation pipeline

The pipeline is defined in `meltano.yml` and executed via `Dockerfile`. It comprises the following steps:

1. Load the data from a MySQL database (which is presumed to already have been imported - see below),
2. Store a subset of the data in a DuckDB database,
3. Run a series of transformations on the data in DuckDB via dbt,
4. Output just the achievements in a final DuckDB database (still via the dbt transformation step in 3).

To feed the initial data into the MySQL database.

1. Supply a SQL dump file in `/data/` - the filename of the SQL file can be anything, but make sure that:
   1. It is the only `.sql` file in the directory,
   2. It loads data into the `debatovanicz` MySQL database, because that's where the pipeline expects the data to be.
2. Remove any existing Docker volumes that might be left over from previous runs. Specifically, `greybox_wrapped_mysql_storage` is where the MySQL container stores its data between container runs. You can do this with `docker volume rm greybox_wrapped_mysql_storage`. (You might need to stop the MySQL container first with `docker-compose -f docker-compose.data_prep.yml down`.)
3. Now run `docker -f docker-compose.data_prep.yml up` to start the pipeline. This will:
   1. Start a MySQL container and load the data from the SQL dump file into it,
   2. Start a Meltano container and run the pipeline steps as described above.
