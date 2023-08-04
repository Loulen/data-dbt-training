{%- set payment_methods = dbt_utils.get_column_values(    
table=source('sources','orders')    
    , column='payment_method') -%}

select
    r.name
    , {%- for payment_method in payment_methods %}
        coalesce(sum(case when payment_method = '{{payment_method}}' then amount end), 0)    as {{payment_method}}_amount
        {%- if not loop.last %},{% endif -%}
    {% endfor %}
from 
    {{ ref('base_restaurants') }}   as r
left join
    {{ ref('base_orders') }}        as o
        on o.restaurant_identifier = r.identifier
group by 1