-- models/union_all_titles.sql
WITH netflix_titles AS (
    SELECT 
        'Netflix' as platform, 
        CONCAT('Netflix_',show_id) as show_id, 
        type, 
        title, 
        director, 
        country, 
        date_added, 
        release_year, 
        rating, 
        duration, 
        listed_in, 
        description
    FROM 
        {{ ref('stg_netflix_titles') }}
    WHERE
        type ILIKE 'TV Show'

),

disney_plus_titles AS (
    SELECT 
        'Disney+' as platform, 
        CONCAT('Disney_',show_id) as show_id,  
        type, 
        title, 
        director, 
        country, 
        date_added, 
        release_year, 
        rating, 
        duration, 
        listed_in, 
        description
    FROM 
        {{ ref('stg_disney_plus_titles') }}
    WHERE
        type ILIKE 'TV Show'

)
,

hulu_titles 
AS (
    SELECT
        'Hulu' as platform, 
        CONCAT('Hulu_',show_id) as show_id,  
        type, 
        title, 
        director, 
        country, 
        date_added, 
        release_year, 
        rating, 
        duration, 
        listed_in, 
        description
    FROM 
        {{ ref('stg_hulu_titles') }}
    WHERE
        type ILIKE 'TV Show'

)
,

amazon_prime_titles AS (
    SELECT 
        'Amazon Prime' as platform, 
        CONCAT('Amazon_',show_id) as show_id,
        type, 
        title, 
        director, 
        country, 
        date_added, 
        release_year, 
        rating, 
        duration, 
        listed_in, 
        description
    FROM 
        {{ ref('stg_amazon_prime_titles') }}
    WHERE
        type ILIKE 'TV Show'

)


SELECT * FROM netflix_titles
UNION ALL
SELECT * FROM disney_plus_titles
UNION ALL
SELECT * FROM hulu_titles
UNION ALL
SELECT * FROM amazon_prime_titles
