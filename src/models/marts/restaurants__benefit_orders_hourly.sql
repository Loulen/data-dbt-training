{{
    config(
        materialized='incremental',
        unique_key=['identifier','hour'],
        incremental_strategy='merge',
    )
}}

with orders as (
    select
        dishes_ids,
        DATE_TRUNC('hour',TO_TIMESTAMP(created_at)) as hour,
    from
        {{ ref('base_orders') }}
    {% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses >= to include records whose timestamp occurred since the last run of this model)
  -- (If event_time is NULL or the table is truncated, the condition will always be true and load all records)
    where hour >= (select coalesce(max(hour),'1900-01-01') from {{ this }} )

    {% endif %}
),
dishes as (
    select
        identifier,
        name,
        selling_price,
        production_cost,
        (selling_price - production_cost) as benefit
    from
        {{ ref('base_dishes') }}
)
select
    dishes.identifier,
    dishes.name,
    orders.hour,
    sum(dishes.selling_price) as hourly_turnover,
    sum(dishes.benefit) as hourly_benefit,
    sum(dishes.production_cost) as hourly_production_cost
from
    dishes
join
    orders on array_contains(dishes.identifier, parse_json(orders.dishes_ids))
group by
    dishes.identifier,
    dishes.name,
    orders.hour