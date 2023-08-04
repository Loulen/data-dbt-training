{%- set payment_methods = get_payment_methods() -%}

with restaurants as (
    select * from {{ ref('base_restaurants') }}
)

, orders as (
    select * from {{ ref('base_orders') }}
)

select
    r.name
    , {%- for payment_method in payment_methods %}
        coalesce(sum(case when payment_method = '{{payment_method}}' then amount end), 0)    as {{payment_method}}_amount
        {%- if not loop.last %},{% endif -%}
    {% endfor %}
from 
    restaurants as r
left join
    orders as o
        on o.restaurant_identifier = r.identifier
group by 1