{% macro create_stream_if_not_exists(stream_source_name, stream_name, table_source_name, table_name) %}
    {%- set stream_ref = source(stream_source_name, stream_name) -%}
    {%- set stream_schema = stream_ref.schema -%}
    {%- set stream_database = stream_ref.database -%}

    {% set sql %}
        create schema if not exists {{ stream_database }}.{{ stream_schema }};
        create stream if not exists {{ source(stream_source_name, stream_name) }} on table {{ source(table_source_name, table_name) }}
            append_only=true;
    {% endset %}
    {% do run_query(sql) %}
{% endmacro %}