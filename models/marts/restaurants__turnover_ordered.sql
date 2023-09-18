select
    restaurant_identifier::number   as restaurant_identifier
    , name::string                  as name
    , address::string               as address
    , turnover::number              as turnover
from
    {{ref('stg_restaurants__turnover_ordered')}}