# dbt-bigquery-ai-classify-demo

Minimal dbt example showing how to use BigQuery `AI.CLASSIFY` to
categorize customer success tickets.

The runnable dbt project lives in
[`bigquery_ai_classify_demo/`](./bigquery_ai_classify_demo).

Inside the project you will find:

- two seeds for ticket categories and sample tickets
- two staging models with explicit casting
- one final mart model that calls `AI.CLASSIFY`

An example environment file is available at
[`bigquery_ai_classify_demo/.env.example`](./bigquery_ai_classify_demo/.env.example).
At minimum, set `DBT_BIGQUERY_PROJECT`. The other documented dbt profile
variables are optional because the project defines defaults for them.

More project details are documented in
[`bigquery_ai_classify_demo/README.md`](./bigquery_ai_classify_demo/README.md).
