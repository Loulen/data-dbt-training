{% macro get_table_schema(relation_name) %}
    {% set model_node = none %}
    {% set source_node = none %}
    {% set error_message = none %}
    {% set is_source = '.' in relation_name %}
    {% set is_ephemeral = false %}
    {% set relation = none %}

    {# --- Step 1: Find the node in the graph and check if ephemeral (without calling ref/source yet) --- #}
    {% if is_source %}
        {% set parts = relation_name.split('.') %}
        {% if parts | length == 2 %}
            {% set source_name, table_name = parts[0], parts[1] %}
            {% set source_node = graph.sources.get('source.' ~ project_name ~ '.' ~ source_name ~ '.' ~ table_name) %}
            {% if not source_node %}
                 {% set error_message = "Source '" ~ relation_name ~ "' not found in project." %}
            {% endif %}
        {% else %}
            {% set error_message = "Invalid source name format: " ~ relation_name ~ ". Expected 'source_name.table_name'." %}
        {% endif %}
    {% else %}
        {# Check if model exists in the graph #}
        {% set model_node = graph.nodes.get('model.' ~ project_name ~ '.' ~ relation_name) %}
        {% if model_node %}
            {# Check if the model is ephemeral BEFORE trying to ref() it #}
            {% if model_node.config.materialized == 'ephemeral' %}
                {% set is_ephemeral = true %}
            {% endif %}
        {% else %}
            {% set error_message = "Model '" ~ relation_name ~ "' not found in project." %}
        {% endif %}
    {% endif %}

    {# --- Step 2: Handle errors or ephemeral models --- #}
    {% if error_message %}
        {{ print("Error: " ~ error_message) }}
        {{ return('') }}
    {% endif %}

    {% if is_ephemeral %}
        {# Handle ephemeral models - print info and exit #}
        {{ print("Info: Model '" ~ relation_name ~ "' is ephemeral and does not have a physical schema in the database.") }}
        {{ print("Columns (from model definition):") }}
         {% for col_name, col_details in model_node.columns.items() %}
             {{ print("- Column: " ~ col_name ~ " (Name: " ~ col_details.name ~ ")") }}
         {% else %}
             {{ print("  No columns explicitly defined in model properties.") }}
         {% endfor %}
        {{ return('') }} {# Exit early for ephemeral #}
    {% endif %}

    {# --- Step 3: Handle non-ephemeral models and sources --- #}
    {# Now it's safe to call ref() or source() because we know it's not ephemeral #}
    {% if is_source %}
         {% set relation = source(source_name, table_name) %}
    {% else %}
         {% set relation = ref(relation_name) %}
    {% endif %}

    {# Double-check if relation object was created #}
    {% if relation is none %}
         {{ print("Internal Error: Could not create relation object for '" ~ relation_name ~ "'.") }}
         {{ return('') }}
    {% endif %}

    {{ print("Fetching schema from database for: " ~ relation) }}

    {# Check if the relation actually exists in the database #}
    {% set relation_exists = adapter.get_relation(database=relation.database, schema=relation.schema, identifier=relation.identifier) %}

    {% if not relation_exists %}
        {{ print("Error: Relation '" ~ relation ~ "' does not exist in the database. Has it been run?") }}
        {{ return('') }}
    {% endif %}

    {% set query %}
        SELECT
            column_name,
            data_type
        FROM {{ relation.database }}.information_schema.columns
        WHERE table_schema = '{{ relation.schema | upper }}'
          AND table_name = '{{ relation.identifier | upper }}'
        ORDER BY ordinal_position;
    {% endset %}

    {% set results = run_query(query) %}

    {% if execute %}
        {% if results | length > 0 %}
            {{ print("Schema for " ~ relation ~ ":") }}
            {% for row in results.rows %}
                {{ print("- Column: " ~ row['COLUMN_NAME'] ~ ", Type: " ~ row['DATA_TYPE']) }}
            {% endfor %}
        {% else %}
            {{ print("Could not retrieve schema information or table is empty for " ~ relation) }}
        {% endif %}
        {{ return('') }} {# Return empty string after printing #}
    {% endif %}

{% endmacro %}