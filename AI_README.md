# AI Technical Overview: data-dbt-training

## Project Type

Data Transformation Pipeline (dbt project)

## Primary Objective

This project serves as a training environment for learning and practicing dbt (data build tool), specifically configured for use with Snowflake. It involves transforming sample restaurant-related data. The training is structured using Git branches (`scenario_*`) corresponding to different exercises, with solutions provided in the branches.

## Key Technologies

*   **Orchestration/Transformation:** dbt (v1.0.0, configured via `dbt_project.yml`)
*   **Language:** SQL, Python (for dbt Python models and scripts like `generate_sample_data.py`)
*   **Data Warehouse:** Snowflake (Profile: `data_dbt_training`)
*   **Key dbt Packages:**
    *   `dbt-labs/dbt_utils` (v1.3.0)
    *   `dbt-ippon-utils` (Custom GitLab package, revision: `6b5e1e9f...`)
    *   `elementary-data/elementary` (v0.15.2, for data observability)
*   **Key Python Libraries (`requirements.txt`):**
    *   `dbt-snowflake` (v1.8.3)
    *   `fuzzywuzzy` (for fuzzy string matching)
    *   `elementary-data` (including `elementary-data[snowflake]`)

## Code Structure & Conventions

*   **Configuration:**
    *   `dbt_project.yml`: Main dbt project configuration (models, paths, schemas, variables, pre-hooks, dispatch).
    *   `packages.yml`: dbt package dependencies.
    *   `requirements.txt`: Python package dependencies.
    *   `trainings_mapping.json`: Maps training scenario names to branches.
*   **Directory Structure:** Standard dbt layout within the `src/` directory:
    *   `src/models/`: Contains dbt models (SQL and Python).
        *   `staging/`: Ephemeral models, for initial cleaning/preparation (Schema: `silver`). Includes `base/` sub-directory.
        *   `marts/`: Table models, representing final transformed data (Schema: `silver`).
    *   `src/seeds/`: CSV files for seeding initial data (Schema: `seeds`). Includes `sample/` sub-directory.
    *   `src/macros/`: Custom dbt macros. Key macros for AI/LLM consumption include:
        *   `get_table_schema.sql`: Fetches the schema definition (columns, types) for a given table.
        *   `get_table_sample_data.sql`: Retrieves a sample dataset from a given table.
    *   `src/tests/`: dbt tests (schema, data, singular, generic). Includes `generic/` sub-directory.
    *   `src/analyses/`: dbt analyses (SQL queries that don't create tables/views).
    *   `src/snapshots/`: dbt snapshots for tracking changes over time.
*   **Naming Conventions:**
    *   **Staging Models:** Prefixed with `stg_` (e.g., `stg_restaurants__turnover.sql`, `stg_restaurants__replace_fuzzy.py`).
    *   **Base Models:** Located in `src/models/staging/base/`, prefixed with `base_` (e.g., `base_orders.sql`).
    *   **Mart Models:** Use the pattern `entity__metric_aggregation` with double underscores as separators (e.g., `restaurants__turnover_ordered.sql`, `menu__item_affinity.sql`).
    *   **Seed Files:** Sample data files are prefixed with `sample_` (e.g., `sample_orders.csv`). Project-specific seeds may follow entity names (e.g., `restaurants.csv`).
    *   **Tests:** Generic tests are prefixed with `test_` (e.g., `test_positive.sql`). Unit tests are tagged with `unit_testing`.
    *   **Python Models:** Follow the same naming conventions based on their layer (e.g., staging).
*   **Entry Points/Key Files:**
    *   `dbt_project.yml`: Defines project settings, model paths, schemas, variables (`nb_restaurants_to_show`, `is_backload`), pre-hooks (`dbt_ippon_utils.add_query_tags`).
    *   `src/models/sources.yml`: Defines source data tables.
    *   `generate_sample_data.py`: Python script for generating sample data.
*   **CI/Scripts:**
    *   `bash_ci_script.sh`: Bash script potentially used for Continuous Integration tasks.

## Workflows (Optional)

(No complex workflows readily identifiable from static analysis for Mermaid diagram generation.)