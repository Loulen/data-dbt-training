# Detailed Project Backlog

## Not Started

---
### Task 3: Create `fct_restaurant_daily_summary` Gold Table

*   **Objective:** Create a fact table `fct_restaurant_daily_summary` in the `gold` schema aggregating key performance metrics per restaurant per day.
*   **Context:**
    *   Purpose: Enable analysis of restaurant performance trends over time.
    *   Sources: Primarily `stg_restaurants__turnover`. May require joining with a stable restaurant dimension if needed (e.g., `base_restaurants` or `stg_restaurants__replace_fuzzy`).
    *   Schema: `gold` (Ensure model is configured to materialize in this schema). **Note:** User accepted materialization in `silver` schema (`dbt_llenoir_silver`).
    *   Granularity: `restaurant_id`, `date`.
    *   Metrics: Calculate `total_orders`, `total_revenue`, `average_order_value`.
    *   Model Type: Table
    *   Location: `src/models/marts/fct_restaurant_daily_summary.sql` (Actual location)
*   **Acceptance Criteria (Custom):**
    *   Execute `dbt run --select fct_restaurant_daily_summary`. (Completed)
    *   Query the resulting `dbt_llenoir_silver.fct_restaurant_daily_summary` table. (Completed)
    *   Verify:
        *   Table exists in the `dbt_llenoir_silver` schema. 
        *   Contains expected columns (`RESTAURANT_ID`, `DATE`, `TOTAL_ORDERS`, `TOTAL_REVENUE`, `AVERAGE_ORDER_VALUE`). 
        *   Metrics appear reasonable upon spot-checking against source data for a known restaurant/day. (Requires manual check if needed)
        *   The grain (`restaurant_id`, `date`) is unique. (Requires manual check if needed)

---

### Task 4: Create `fct_dish_popularity_daily` Table

*   **Objective:** Create a fact table `fct_dish_popularity_daily` tracking sales metrics per dish per day.
*   **Context:**
    *   Purpose: Enable analysis of dish popularity and revenue contribution over time.
    *   Sources: Combined data from `stg_restaurants__dishes_flatten` and `stg_restaurants__turnover`.
    *   Schema: `dbt_llenoir_silver` (Actual schema used).
    *   Granularity: `dish_id`, `date`.
    *   Metrics: Calculated `total_quantity_ordered`, `total_revenue`.
    *   Model Type: Table
    *   Location: `src/models/marts/fct_dish_popularity_daily.sql` (Actual location).
*   **Acceptance Criteria (Custom):**
    *   Execute `dbt run --select fct_dish_popularity_daily`. (Completed)
    *   Query the resulting `dbt_llenoir_silver.fct_dish_popularity_daily` table. (Completed)
    *   Verify:
        *   Table exists in the `dbt_llenoir_silver` schema. 
        *   Contains expected columns (`DISH_ID`, `DATE`, `TOTAL_QUANTITY_ORDERED`, `TOTAL_REVENUE`). 
        *   Metrics appear reasonable upon spot-checking. 
        *   The grain (`dish_id`, `date`) is unique. 

---

## In Progress

*(No tasks currently in progress)*

---

## Done

### Task 1: Implement `get_table_schema` Macro

*   **Objective:** Create a dbt macro that retrieves and displays the schema (column names and data types) of a specified table or model in the terminal.
*   **Context:**
    *   This macro is intended for AI consumption to understand data structure.
    *   It should accept a dbt relation object (representing a table or model) as input.
    *   It needs to query the appropriate information schema (e.g., Snowflake's `INFORMATION_SCHEMA.COLUMNS`).
    *   The output should be formatted clearly for terminal display.
    *   Leverage dbt's `run_query` and `print` Jinja functions.
    *   The macro file should be created in `src/macros/`.
*   **Acceptance Criteria (Custom):**
    *   Execute the macro using a command like `dbt run-operation get_table_schema --args '{relation_name: "stg_restaurants__turnover"}'` (adjusting the model name as needed).
    *   Verify that the terminal output correctly lists the column names and their corresponding data types for the specified model.

---

### Task 2: Implement `get_table_sample_data` Macro

*   **Objective:** Create a dbt macro that retrieves and displays a small sample (default 10 rows) of data from a specified table or model in the terminal.
*   **Context:**
    *   This macro allows AI agents to inspect the actual content of data tables.
    *   It should accept a dbt relation object as the primary input.
    *   It should accept an optional `row_limit` argument, defaulting to 10 if not provided.
    *   The macro should construct and execute a `SELECT * ... LIMIT ...` query.
    *   Use dbt's `run_query` and `print` functions.
    *   Format the output (e.g., as a simple table or list of dictionaries) for readability in the terminal.
    *   The macro file should be created in `src/macros/`.
*   **Acceptance Criteria (Custom):**
    *   Execute the macro using commands like:
        *   `dbt run-operation get_table_sample_data --args '{relation_name: "stg_restaurants__turnover"}'`
        *   `dbt run-operation get_table_sample_data --args '{relation_name: "stg_restaurants__turnover", row_limit: 5}'`
    *   Verify that the terminal output displays the correct number of rows (default 10, or the specified limit) and columns from the target model in a readable format.

---

