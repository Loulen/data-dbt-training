with benefits_orders_daily as (
    select
        identifier as dish_identifier,
        name,
        date_trunc("day",hour) as day,
        sum(hourly_turnover) as daily_turnover,
        sum(hourly_benefit) as daily_benefit,
        sum(hourly_production_cost) as daily_production_cost
    from
        {{ ref('restaurants__benefit_orders_hourly') }}
    group by
        identifier,
        name,
        date_trunc("day",hour),
        hourly_turnover,
        hourly_benefit,
        hourly_production_cost
)
select
    dish_identifier,
    name,
    avg(daily_turnover) as avg_daily_turnover,
    avg(daily_benefit) as avg_daily_benefit,
    avg(daily_production_cost) as avg_daily_production_cost
from
    benefits_orders_daily
group by
    dish_identifier,
    name
order by
    avg_daily_turnover desc