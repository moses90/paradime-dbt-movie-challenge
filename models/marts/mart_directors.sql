select u.director
     , m.imdb_id
     , m.title
     , m.released_date
     , m.budget 
     , m.revenue
     , m.profit 
     , m.runtime
     , m.metascore 
     , m.imdb_rating
     , avg(m.profit)      over (partition by u.director order by m.release_date rows between 2 preceding and current row)   as threeday_avg_profit
     , avg(m.imdb_rating) over (partition by u.director order by m.release_date rows between 2 preceding and current row)   as threeday_avg_imdb_rating
     , avg(m.metascore)   over (partition by u.director order by m.release_date rows between 2 preceding and current row)   as threeday_avg_meta_score
     , row_number()       over (partition by u.director order by m.release_date) as movie_cnt_director
from {{ ref('unnest_directors')}} u
join {{ ref('stg_omdb_tmdb_movies_join')}} m 
  on u.imdb_id = m.imdb_id
where true 
  and m.profit is not null
  and m.imdb_rating is not null