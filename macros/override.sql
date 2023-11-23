{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ log('coucou je suis là', info=True) }}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}
        {% if target.name.lower() == 'prod' %}
          {{ custom_schema_name | trim }}
        {% endif %}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}
