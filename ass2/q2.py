# COMP3311 22T1 Ass2 ... print info about different releases for Movie

import sys
import psycopg2

# define any local helper functions here

# set up some globals

usage = "Usage: q2.py 'PartialMovieTitle'"
db = None

# process command-line args

argc = len(sys.argv)

# manipulate database
'''
select rating, title, start_year from movies where title ~* '.*mothra.*';
'''
if argc == 1:
    print(usage)
    sys.exit()
try:
    db = psycopg2.connect("dbname=imdb")
	# ... add your code here ...
    cur = db.cursor()
    qry = "select id, rating, title, start_year from movies where title ~* %s order by rating desc, start_year asc, title;"
    pattern = '.*' + str(sys.argv[1]) + '.*'
    cur.execute(qry, [pattern])
    result = cur.fetchall()
    # more than 1 movie are matched
    if len(result) > 1 :
        print('Movies matching ' + '\'' + sys.argv[1] + '\'')
        print('===============')
        for tup in result:
            mvid, rating, title, start_year = tup
            print(str(rating) + ' ' + title + ' ' + '(' + str(start_year) + ')')
    # match no movie
    elif len(result) == 0 :
        print('No movie matching ' + '\'' + sys.argv[1] + '\'')
    # match exactly 1 movie
    elif len(result) == 1:
        mv_id = 0
        for tup in result:
            mvid, rating, title, start_year = tup
            mv_id = mvid
            print(title + ' ' + '(' + str(start_year) + ') ', end='')
        # query to Aliases table
        qry = "select local_title, region, language, extra_info from aliases where movie_id = %s order by ordering"
        cur.execute(qry, [mv_id])
        result = cur.fetchall()
        # more versions are found
        if len(result) > 0 :
            print( 'was also released as')
            for tup in result:
                local_title, region, language, extra_info = tup
                print('\'' + local_title + '\' ', end='')
                # if all the region, language and extra_info are None
                if (region == None and language == None and extra_info == None) :
                    print()
                # other situations
                else :
                    print('(', end='')
                    # both region and language are not None
                    if region != None and language != None :
                        print('region: ' + region.replace(' ', '') + ', ' + 'language: ' + language.replace(' ', '') + ')')
                    # other situations
                    else :
                        if region != None :
                            print('region: ' + region.replace(' ', '') + ')')
                        if language != None :
                            print('language: ' + language.replace(' ', '') + ')')
                        if region == None and language == None:
                            print(extra_info + ')')
        # no version are found
        else :
            print('has no alternative releases')
except psycopg2.Error as err:
	print("DB error: ", err)
finally:
	if db:
		db.close()
