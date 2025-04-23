{% macro get_table_sample_data(relation_name, row_limit=10) %}
    {% set relation = none %}
    {% set node = none %}
    {% set error_message = none %}

    {#- Find the node (model, seed, or source) in the graph context using unique_id -#}
    {% if execute %}
        {% set is_source = '.' in relation_name %}
        {% set unique_id = none %}
        {% set node = none %}

        {% if is_source %}
            {% set source_parts = relation_name.split('.') %}
            {% if source_parts | length == 2 %}
                {% set source_name, table_name = source_parts[0], source_parts[1] %}
                {% set unique_id = 'source.' ~ project_name ~ '.' ~ source_name ~ '.' ~ table_name %}
                {% if unique_id in graph.sources %}
                    {% set node = graph.sources[unique_id] %}
                {% endif %}
            {% else %}
                {% set error_message = "Invalid source name format: " ~ relation_name ~ ". Expected 'source_name.table_name'." %}
            {% endif %}
        {% else %}
            {# Check for model first #}
            {% set unique_id = 'model.' ~ project_name ~ '.' ~ relation_name %}
            {% if unique_id in graph.nodes %}
                {% set node = graph.nodes[unique_id] %}
            {% else %}
                {# Check for seed if not found as model #}
                {% set unique_id = 'seed.' ~ project_name ~ '.' ~ relation_name %}
                {% if unique_id in graph.nodes %}
                    {% set node = graph.nodes[unique_id] %}
                {% endif %}
            {% endif %}
        {% endif %}

        {#- Check if node was found -#}
        {% if node is none and not error_message %}
            {% set error_message = "Error: Relation '" ~ relation_name ~ "' not found in the project graph (unique_id: " ~ unique_id ~ ")." %}
        {% endif %}

        {#- Handle errors or ephemeral models before trying to resolve the relation -#}
        {% if error_message %}
            {{ print(error_message) }}
            {{ return('') }}
        {% elif node.config.materialized == 'ephemeral' %}
            {{ print("Info: Cannot query ephemeral model '" ~ relation_name ~ "' directly. Skipping sample data retrieval.") }}
            {{ return('') }}
        {% else %}
            {#- Node found and is queryable, now resolve the relation object -#}
            {% if node.resource_type == 'source' %}
                {% set relation = source(node.source_name, node.name) %}
            {% elif node.resource_type in ['model', 'seed'] %}
                {% set relation = ref(node.name) %}
            {% else %}
                 {% set error_message = "Error: Unsupported resource type '" ~ node.resource_type ~ "' for relation '" ~ relation_name ~ "'." %}
                 {{ print(error_message) }}
                 {{ return('') }}
            {% endif %}
        {% endif %}
    {% else %}
        {#- If not executing, we can't inspect the graph, return empty -#}
        {{ return('') }}
    {% endif %}

    {#- If relation is still none after checks, something went wrong -#}
    {% if relation is none %}
         {{ print("Error: Could not resolve relation object for '" ~ relation_name ~ "'.") }}
         {{ return('') }}
    {% endif %}

    {#- Construct and run the query -#}
    {% set query %}
        SELECT *
        FROM {{ relation }}
        LIMIT {{ row_limit }}
    {% endset %}

    {{ print("Fetching " ~ row_limit ~ " sample rows from " ~ relation ~ "...") }}

    {% set results = run_query(query) %}

    {#- Print the results -#}
    {% if results %}
        {% do results.print_table(max_columns=None, max_column_width=30) %}
    {% else %}
        {{ print("No results returned or error executing query.") }}
    {% endif %}

{% endmacro %}