## Doing analytics on the dataset

The `greybox_conversion/` directory produces `data/adk_wrapped_full.db`, which is a DuckDB database containing the full dataset, including both the raw data, the data transformed for ease of analysis, and the data used for the final aggregation.

The `data/adk_wrapped_full.db` database contains the following views, which combine the raw data and which all aggregations build on:

- `"main"."base__debater_debata"`, which contains the individual speech details per person/debate combined with debate/tournament/competition details.
- `"main"."base__rozhodci_debata"`, which also contains the individual judgment details per person/debate.
- Less important views are `base__debata` (which is mostly expanded into `base__debater_debata`) and `base__debater_ib` (which contains IB point data).

These are located in `greybox_conversion/transform/models/base/*.sql` and described in `greybox_conversion/transform/models/models.yml`.

Note that these are "views" - meaning they're merely SQL logic being executed on top of the `debatovanicz` schema, which contains the _raw_ raw data. The views are built using `dbt` and are stored in the `data/adk_wrapped_full.db` database.

## Understanding the dataset

**Each table/view and each column therein are described in the DuckDB file.** (These descriptions come from the `*.yml` files in the `greybox_conversion/transform/models/` directory, and are written into the database by `dbt`.) To answer questions about the dataset, please take a look at these descriptions first!

To do so, you can use a database browser like [DBeaver](https://dbeaver.com/). This also lets you run SQL queries on the database and access the results.

## Exploring the dataset

You can use R or Python bindings that DuckDB provides to explore the dataset and visualize it. [The DuckDB documentation provides a good starting point for Python](https://duckdb.org/docs/api/python/overview.html) - you can read the table or arbitrary table-joining SQL into Pandas/Polars/Array `DataFrame` and work with it further. [A similar guide is available for R](https://duckdb.org/docs/api/r) and half a dozen other languages.

You can also use pure SQL to explore the dataset. For example, to get the number of debates per calendar year, you can run the following query:

```sql
select
    date_part('year', debate_date) as debate_year,
    count(*) as debates
from
    main.base__debata
group by 1
```

_(Are you unfamiliar with `group by 1`? [See this classic post in its defence.](https://www.getdbt.com/blog/write-better-sql-a-defense-of-group-by-1) tl;dr: It's the same as `group by debate_year`.)_

For additional examples, see `greybox_conversion/transform/models/achievements/` directory, which contains a bunch of logic aggregated per person/year.
