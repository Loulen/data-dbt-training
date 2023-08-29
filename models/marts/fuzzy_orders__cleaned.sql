{{
    config(
        materialized='table'
    )
}}

with cleaned_flat as (
    select * from {{ ref('stg_flatten_cleaned_names') }}
)

, dishes as (
    select * from {{ ref('base_dishes') }}
)

, dish_ids as (
    select
        c.fake_id
        , d.identifier as dish_id
        , c.payment_method
        , c.amount
        , c.created_at
        {# , c.dishes_ids #}
    from
        cleaned_flat as c
    inner join
        dishes as d
        on c."dish_name" = d.name
)

, final as (
    select
        fake_id as identifier
        , array_agg(dish_id) as dishes_ids
        , any_value(payment_method) as payment_method
        , any_value(amount) as amount
        , any_value(created_at) as created_at
        {# , any_value(dishes_ids) as true_dishes_ids #}
    from
        dish_ids
    group by
        fake_id
)

select * from final
