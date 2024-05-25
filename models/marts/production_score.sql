select production_company,
MOVIES_MADE,
total_revenue,
film_ct_score,
film_raw_rev_score,
film_ct_score*film_raw_rev_score as combo_score
FROM {{ source('PRODUCTION_COMPANIES_OVERALL', 'production_companies') }}
order by film_ct_score asc
limit 50
