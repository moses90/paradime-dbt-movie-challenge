WITH CTE_MOVIES AS (

  SELECT
    IMDB_ID,
    REVENUE_ADJUSTED
  FROM {{ ref('movies') }}
  WHERE
    1 = 1
    AND REVENUE_ADJUSTED > 0
    AND RELEASE_YEAR >= 2000
),

CTE_RANK AS (
  SELECT
    IMDB_ID,
    REVENUE_ADJUSTED,
    ROW_NUMBER() OVER (ORDER BY REVENUE_ADJUSTED DESC) AS RANK
  FROM CTE_MOVIES
)

SELECT 1 - 2 * SUM((REVENUE_ADJUSTED * (RANK - 1) + REVENUE_ADJUSTED / 2)) / COUNT(*) / SUM(REVENUE_ADJUSTED) AS GINI
FROM CTE_RANK
