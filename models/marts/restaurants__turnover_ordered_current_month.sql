{{
    config(
        post_hook=[
            "{{ export_to_s3(
                external_stage = target.database ~ '.source.stage_dbt_jnadal_' ~ target.name
                , prefix = 'jnadal/' ~ get_last_month(this)
                , filename = 'turnover_ordered'
                , columns_to_export = ['restaurant_identifier', 'name', 'address', '_month'
                    , 'turnover']
                , dry_run = var('dry_run')
                )
            }}"
        ]
    )
}}

select 
    r.identifier                            as restaurant_identifier
    , r.name
    , r.address
    , max(date_trunc(month, o.created_at))  as _month
    , coalesce(sum(o.amount),0)             as turnover
from 
    {{ref('base_restaurants')}} as r
left join
    {{ ref('stg_orders_current_month') }} as o
    on o.restaurant_identifier = r.identifier
group by 
    r.identifier
    , r.name
    , r.address
order by 
    turnover desc