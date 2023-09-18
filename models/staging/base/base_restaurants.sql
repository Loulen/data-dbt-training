select
    identifier
    , name
    , address
from 
    {{ source('sources', 'restaurants') }}