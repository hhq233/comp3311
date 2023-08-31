-- COMP3311 22T1 Final Exam Q4
-- Return basic info for a beer, given its ID
-- basic info = "[Rating level] BeerName (BreweryName)"
-- If the beer ID is not in the database, return 'No such beer'

create or replace function q4(_beerID integer) returns text
as
$$
declare
	result integer;
	rate integer;
	beername text;
	breweryname text;
	ans text;
begin
	select count(*) into result from beers where id = _beerID;
	if (result = 0) then 
        return 'No such beer'; 
    end if;
    select rating into rate from beers where id = _beerID;
    select name into beername from beers where id = _beerID;
    if (rate = 10) then
        ans := '[S] '||beername||' ';
    end if;
    if (rate <= 9 and rate >= 7) then
        ans := '[A] '||beername||' ';
    end if;
    if (rate <= 6 and rate >= 4) then
        ans := '[B] '||beername||' ';
    end if;
    if (rate <= 3) then
        ans := '[C] '||beername||' ';
    end if;
    select bre.name into breweryname from breweries bre, brewed_by bb, beers b
    where b.id = _beerID and b.id = bb.beer and bb.brewery = bre.id;
    
    
    return ans || '('||breweryname||')';
end;
$$ language plpgsql;
