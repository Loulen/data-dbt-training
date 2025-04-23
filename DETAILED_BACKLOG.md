# Detailed Project Backlog

## Not Started

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