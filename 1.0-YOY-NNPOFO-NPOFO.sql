with ytd_data_with_FY as
( 
  select * ,
  case
      WHEN date BETWEEN '2017-09-01' AND '2018-08-31' THEN 'FY18'
      WHEN date BETWEEN '2018-09-01' AND '2019-08-31' THEN 'FY19'
      WHEN date BETWEEN '2019-09-01' AND '2020-08-31' THEN 'FY20'
      WHEN date BETWEEN '2020-09-01' AND '2021-08-31' THEN 'FY21'
      WHEN date BETWEEN '2021-09-01' AND '2022-08-31' THEN 'FY22'
      WHEN date BETWEEN '2022-09-01' AND '2023-08-31' THEN 'FY23'
      WHEN date BETWEEN '2023-09-01' AND '2024-08-31' THEN 'FY24'
      WHEN date BETWEEN '2024-09-01' AND '2025-08-31' THEN 'FY25'
  end as financial_year

  from `data_marts.ltv_cac_3_years_by_country`
  where country = "UK"
  and extract(month from date) in (9,10,11,12,1,2,3) -- First Half of Each Financial Year 
)
select 
financial_year,

(SUM(new_customer_total_net_revenue)-SUM(new_customer_product_materials_cost)-SUM(spend))/SUM(acquired_customers) as NPOFO,
(SUM(new_customer_total_net_revenue)-SUM(new_customer_product_materials_cost)-sum(new_customer_product_labour_cost)-sum(new_customer_fulfilment_labour_cost)-SUM(new_customer_payment_processing_costs)-SUM(new_customer_product_packaging_cost)-SUM(new_customer_delivery_internal_cost_gbp)-SUM(spend))/SUM(acquired_customers) as NNPOFO
from ytd_data_with_FY
where financial_year is not null
group by financial_year
order by financial_year asc
