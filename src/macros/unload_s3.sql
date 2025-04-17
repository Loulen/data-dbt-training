{% macro unload_s3(table) %}
{# This macro is used to unload a table to S3 using an external table in snowflake #}

{%- set target_name = target.name.lower() -%}
{%- if target_name in ['prod'] -%} 
    {%- set STAGE_DBT = 'STAGE_DBT_LLENOIR_PROD' -%}
{%- else -%} 
    {%- set STAGE_DBT = 'STAGE_DBT_LLENOIR_DEV' -%}
{%- endif -%}

    {% set sql %}
        COPY INTO @{{ source('source', STAGE_DBT)}}/llenoir/{{ table }}
        FROM {{ table }}
        FILE_FORMAT = (TYPE = 'CSV' COMPRESSION = 'NONE')
        OVERWRITE = TRUE
    {% endset %}
    
    {{ log("UNLOAD_S3: Running sql command : "~sql, info = true) }}

    {% do run_query(sql) %}
{% endmacro %}