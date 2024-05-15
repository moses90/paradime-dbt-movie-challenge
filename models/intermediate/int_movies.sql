with 

src_omdb as (
    select * from {{ ref('stg_omdb_movies') }}
),

src_tmdb as (
    select * from {{ ref('stg_tmdb_movies') }}
),

omdb AS (
    SELECT 
        IMDB_ID,
        TMDB_ID,
        TITLE,
        DIRECTOR,
        WRITER,
        ACTORS,
        GENRE,
        LANGUAGE,
        COUNTRY,
        TYPE,
        PLOT,
        RATED,
        RATINGS,
        METASCORE,
        IMDB_RATING,
        IMDB_VOTES,
        RELEASED_DATE,
        RELEASE_YEAR,
        RUNTIME,
        DVD,
        BOX_OFFICE,
        POSTER,
        PRODUCTION,
        WEBSITE,
        AWARDS
    FROM src_omdb
),

tmdb AS (
    SELECT
        TMDB_ID,
        IMDB_ID,
        TITLE,
        ORIGINAL_TITLE,
        OVERVIEW,
        TAGLINE,
        KEYWORDS,
        ORIGINAL_LANGUAGE,
        STATUS,
        VIDEO,
        RELEASE_DATE,
        RUNTIME,
        BUDGET,
        REVENUE,
        VOTE_AVERAGE,
        VOTE_COUNT,
        HOMEPAGE,
        POSTER_PATH,
        BACKDROP_PATH,
        BELONGS_TO_COLLECTION,
        GENRE_NAMES,
        SPOKEN_LANGUAGES,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY_NAMES
    FROM src_tmdb
    WHERE TRUE
        AND (IMDB_ID IS NOT NULL AND TMDB_ID IS NOT NULL)  
)

SELECT
    COALESCE(o.IMDB_ID, t.IMDB_ID) AS IMDB_ID,
    COALESCE(o.TMDB_ID, t.TMDB_ID) AS TMDB_ID,
    COALESCE(o.TITLE, t.TITLE) AS TITLE,
    t.ORIGINAL_TITLE,
    COALESCE(o.PLOT, t.OVERVIEW) AS OVERVIEW,
    t.TAGLINE,
    t.KEYWORDS,
    COALESCE(o.LANGUAGE, t.ORIGINAL_LANGUAGE) AS LANGUAGE,
    COALESCE(o.COUNTRY, t.PRODUCTION_COUNTRY_NAMES) AS COUNTRY,
    o.TYPE,
    COALESCE(o.RATED, t.STATUS) AS RATED,
    o.RATINGS,
    o.METASCORE,
    COALESCE(o.IMDB_RATING, t.VOTE_AVERAGE) AS IMDB_RATING,
    COALESCE(o.IMDB_VOTES, t.VOTE_COUNT) AS IMDB_VOTES,
    COALESCE(o.RELEASED_DATE, t.RELEASE_DATE) AS RELEASED_DATE,
    o.RELEASE_YEAR,
    COALESCE(o.RUNTIME, t.RUNTIME) AS RUNTIME,
    o.DVD,
    COALESCE(o.BOX_OFFICE, t.REVENUE) AS BOX_OFFICE,
    COALESCE(o.POSTER, t.POSTER_PATH) AS POSTER,
    COALESCE(o.PRODUCTION, t.PRODUCTION_COMPANY_NAMES) AS PRODUCTION,
    COALESCE(o.WEBSITE, t.HOMEPAGE) AS WEBSITE,
    o.AWARDS,
    t.VIDEO,
    t.BUDGET,
    t.BACKDROP_PATH,
    t.BELONGS_TO_COLLECTION,
    t.GENRE_NAMES,
    t.SPOKEN_LANGUAGES
FROM omdb o
FULL OUTER JOIN tmdb t ON t.IMDB_ID = o.IMDB_ID
WHERE COALESCE(o.IMDB_ID, t.IMDB_ID) IS NOT NULL
