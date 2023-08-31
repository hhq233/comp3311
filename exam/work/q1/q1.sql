-- COMP3311 22T1 Final Exam Q1
-- Least pupolar beer(s)

create or replace view q1(beer,brewery,rating)
as
select b.name as beer, bre.name as brewery, b.rating as rating
from beers b, breweries bre, brewed_by bb
where b.id = bb.beer and bre.id = bb.brewery and b.sold_in = 'can'
order by rating, beer
limit 3
;
