-- COMP3311 22T1 Final Exam Q3
-- Breweries that do not make neigher IPA nor Ale
create or replace view helper3
as
(select beer from brewed_by) 
except
(select distinct beers.id from styles, beers
where styles.name not like '%Ale%' and not styles.name like '%IPA%' and beers.style = styles.id)
;

create or replace view q3(brewery)
as
select distinct bre.name 
from breweries bre, beers b, brewed_by bb, styles s, locations l
where s.name not like '%Ale%' and s.name not like '%IPA%' and b.style = s.id
and l.country = 'Australia' and bre.located_in = l.id and bb.beer = b.id and bb.brewery = bre.id
order by bre.name
;
