#!/bin/bash
source .venv/bin/activate
source .env
dbt deps
dbt seed --target ci
dbt run --target ci
dbt test --target ci