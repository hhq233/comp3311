-- COMP3311 Prac Exercise
--
-- Written by: YOU


-- Q1: how many page accesses on March 2

create view Q1 as
select count(*) as nacc from Accesses
where accTime >= '2005-03-02 00:00:00' and accTime < '2005-03-03 00:00:00';


-- Q2: how many times was the MessageBoard search facility used?

create view Q2 as
select count(*) as nsearches from Accesses
where page like 'messageboard%' and params like '%state=search%';


-- Q3: on which Tuba lab machines were there incomplete sessions?

create view Q3 as
select distinct h.hostname as hostname
from   Hosts h, Sessions s
where  h.hostname like 'tuba%cse.unsw.edu.au' and s.host=h.id and not s.complete
;


-- Q4: min,avg,max bytes transferred in page accesses

create view Q4 as
select min(nbytes) as min, avg(nbytes) as avg, max(nbytes) as max
from   Accesses;


-- Q5: number of sessions from CSE hosts

create view Q5 as
select count(*) as nhosts 
from Sessions s, Hosts h
where h.hostname like '%cse.unsw.edu.au' and s.host=h.id;


-- Q6: number of sessions from non-CSE hosts

create view Q6 as
select count(*) as nhosts 
from Sessions s, Hosts h
where h.hostname not like '%cse.unsw.edu.au' and s.host=h.id;


-- Q7: session id and number of accesses for the longest session?

create view sessLength as
select session,count(*) as length
from   Accesses
group by session;

create view Q7 as
select session, length
from   sessLength
where  length = (select max(length) from sessLength);



-- Q8: frequency of page accesses

create view Q8 as
select page, count(*) as freq
from Accesses
group by page;

-- Q9: frequency of module accesses

... replace this line by auxiliary views (or delete it) ...

create or replace view Q9(module,freq) as
... replace this line by your SQL query ...
;


-- Q10: "sessions" which have no page accesses

create view Q10 as
select id as session
from Sessions s
where  not exists (select * from Accesses where session=s.id);


-- Q11: hosts which are not the source of any sessions

create view Q11 as
select h.hostname as unused
from   Hosts h left outer join Sessions s on (h.id=s.host)
group  by h.hostname
having count(s.id) = 0;
