{{
    config(
        materialized='table'
    )
}}
select 
{{ dbt_utils.generate_surrogate_key(['o.orderid','c.customerid','p.productid'])}} as surrogate_key,
-- from raw order
o.orderid,
o.orderdate,
o.shipdate,
o.shipmode,
o.ordersellingprice - o.ordercostprice as orderprofit,
o.ordercostprice,
o.ordersellingprice,
-- from raw customer
c.customerid,
c.customername,
c.segment,
c.country,
--from raw_product
p.productid,
p.category,
p.productname,
p.subcategory,
{{markup()}} as markup, --macro
d.delivery_team
from {{ ref('raw_orders') }} as o
left join {{ ref('raw_customer') }} as c
on o.customerid =c.customerid
left join {{ ref('raw_product') }} as p
on o.productid = p.productid
left join {{ ref('delivery_team') }} as d
on d.shipmode = o.shipmode