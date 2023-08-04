select
    identifier
    , name
    , address
from 
    {{ mockable_source('sources', 'restaurants','sample_restaurants') }}