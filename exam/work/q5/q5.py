# COMP3311 22T1 Final Exam Q5
# Breweries in a specified place
# Input is name of town/city/region/country
# Output is list of breweries at that location

import sys
import psycopg2
import re

# define any local helper functions here

### set up some globals

usage = f"Usage: {sys.argv[0]} Place"
db = None

### process command-line args

argc = len(sys.argv)
if argc < 2:
  print(usage)
  exit(1)

place = sys.argv[1]

### queries

# ... add your queries here ...

### manipulate database

try:
  db = psycopg2.connect("dbname=beer")

  # ... add your code here ...
  cur = db.cursor()    
  qry = "select * from locations where country ~* %s or region ~* %s or metro ~* %s or town ~* %s"
  pattern = '.*' + str(sys.argv[1]) + '.*'
  cur.execute(qry, [pattern,pattern,pattern,pattern])
  result = cur.fetchall()
  locationid = 0
  for tup in result:
    location, country, region, metro, town = tup
    locationid = location
    
  qry = "select id, name, founded from breweries where located_in = %s order by name"
  cur.execute(qry, [locationid])
  result = cur.fetchall()
  number = 0
  for tup in result:
    bid, name, year = tup
    qry = "select beers.id, count(*) from breweries, beers, brewed_by where breweries.id = %s and beers.id = brewed_by.beer and brewed_by.brewery = breweries.id group by beers.id"
    cur.execute(qry, [bid])
    result2 = cur.fetchall()
    for tup2 in result2:
      x, count = tup2
      number = count
    print(name +', who brewed '+str(number) +' beers in ' + str(year))
except Exception as err:
  print("DB error: ", err)
finally:
  if db:
    db.close()

