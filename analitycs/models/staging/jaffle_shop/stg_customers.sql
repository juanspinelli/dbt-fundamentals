select
    id as customer_id,
    first_name as givenname,
    last_name as surname,
    first_name || ' ' || last_name as full_name
from {{ source('jaffle_shop', 'customers') }}
