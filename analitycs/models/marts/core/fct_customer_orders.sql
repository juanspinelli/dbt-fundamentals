with

customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('int_orders') }}

),

final as (

    select

        orders.order_id,
        orders.user_order_seq,
        orders.status,
        orders.customer_id,
        orders.order_value_dollars,
        customers.surname,
        customers.givenname,
        customers.full_name,

        -- Customer-level aggregations
        min(order_date) as first_order_date,

        min(case 
            when orders.status not in ('returned','return_pending') 
            then orders.order_date 
        end) as first_non_returned_order_date,

        max(case 
            when orders.status not in ('returned','return_pending') 
            then orders.order_date 
        end) as most_recent_non_returned_order_date,

        coalesce(max(orders.user_order_seq),0) as order_count,

        coalesce(count(case 
            when orders.status != 'returned' 
            then 1 end),
            0
        ) as non_returned_order_count,

        sum(case 
            when orders.status not in ('returned','return_pending') 
            then orders.order_value_dollars 
            else 0 
        end) as total_lifetime_value,

        sum(case 
            when orders.status not in ('returned','return_pending') 
            then orders.order_value_dollars 
            else 0 
        end)
        / nullif(count(case 
            when orders.status not in ('returned','return_pending') 
            then 1 end),
            0
        ) as avg_non_returned_order_value,

        array_agg(distinct orders.order_id) as order_ids

    from orders
    inner join customers
        on orders.customer_id = customers.customer_id
    group by 1,2,3,4,5,6,7,8

)

select * from final