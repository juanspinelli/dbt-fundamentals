select
{{ dbt_utils.surrogate_key(['customer_id', 'order_date']) }} as id_md5,
customer_id,
order_date,
count(*) as total
from {{ ref('stg_orders') }}
group by 1,2,3