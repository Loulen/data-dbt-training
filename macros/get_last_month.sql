{% macro get_last_month(target_table) %}

    {% set relation_query %}
        select
            max(_month)
        from 
            {{ target_table }}
    {% endset %}

    {% set results = run_query(relation_query) %}

    {% if execute %}
        {# Return the first column #}
        {% set date = results.columns[0].values()[0] %}
        {% set month = ""~date.year~"-"~date.month %}
    {% else %}
        {% set month = '2022-10' %}
    {% endif %}
    {{ log("Last month in orders " ~ month, info = true)}}
    {{ return(month) }}

{% endmacro %}