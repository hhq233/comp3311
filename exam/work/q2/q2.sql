-- COMP3311 22T1 Final Exam Q2
-- Beers using all three types of ingredients with at least two varieties for each of them.

create or replace view ivbeer as
(select c.beer
from contains c, ingredients i 
where i.itype = 'hop' and c.ingredient = i.id 
group by c.beer having count(c.ingredient) >=2)
intersect
(select c.beer 
from contains c, ingredients i 
where i.itype = 'grain' and c.ingredient = i.id 
group by c.beer having count(c.ingredient) >=2)
intersect
(select c.beer
from contains c, ingredients i 
where i.itype = 'adjunct' and c.ingredient = i.id 
group by c.beer having count(c.ingredient) >=2)
;
create or replace view q2(beer, brewery)
as select beers.name, breweries.name from beers, breweries, ivbeer, brewed_by
where beers.id = ivbeer.beer and brewed_by.beer = beers.id and brewed_by.brewery = breweries.id;
