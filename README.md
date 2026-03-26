# dbt-bigquery-ai-classify-demo

Minimal dbt example showing how to use BigQuery `AI.CLASSIFY` to
categorize customer success tickets.

The runnable dbt project lives in
[`bigquery_ai_classify_demo/`](./bigquery_ai_classify_demo).

Inside the project you will find:

- two seeds for ticket categories and sample tickets
- two staging models with explicit casting
- one final mart model that calls `AI.CLASSIFY`

Quick start:

```bash
uv sync
source .venv/bin/activate
cd bigquery_ai_classify_demo
cp .env.example .env
set -a
source .env
set +a
export DBT_PROFILES_DIR=$PWD
dbt debug
dbt seed
dbt build -s +mart_ticket_classifications
dbt show -s mart_ticket_classifications --limit 10
```

Setup and run instructions are documented in
[`bigquery_ai_classify_demo/README.md`](./bigquery_ai_classify_demo/README.md).
