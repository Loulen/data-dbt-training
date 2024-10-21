{% macro get_column_values(column_name, target_table) %}

    {% set relation_query %}
        select distinct
            {{ column_name }}
        from 
            {{ target_table }}
        order by 1
    {% endset %}

    {% set results = run_query(relation_query) %}

    {% if execute %}
        {# Return the first column #}
        {% set results_list = results.columns[0].values() %}
    {% else %}
        {% set results_list = [] %}
    {% endif %}
    {{ log("result list " ~ results_list, info = true)}}
    {{ return(results_list) }}

{% endmacro %}


{% macro get_payment_methods() %}

{{ return(get_column_values('payment_method', source('source','orders'))) }}

{% endmacro %}
