with date_dimension as (
    select * from {{ ref('dates') }}
)
SELECT
    {{dbt_utils.generate_surrogate_key(['date_day'])}} as dim_date_key,
    date_day,
    day_of_week,
    day_of_month,
    day_of_year,
    week_of_year,
    month_of_year,
    month_name,
    quarter_of_year,
    year_number
FROM
    date_dimension d