/*
In 12.sql, write a SQL query to list the titles of all movies in which both Johnny Depp and
Helena Bonham Carter starred. Your query should output a table with a single column for the title of each movie.
You may assume that there is only one person in the database with the name Johnny Depp.
You may assume that there is only one person in the database with the name Helena Bonham Carter. */

/*SELECT title FROM movies WHERE id
IN(SELECT movie_id FROM stars WHERE person_id
IN(SELECT id FROM people WHERE name ='Johnny Depp' AND name = 'Helena Bonham Carter'));

SELECT title FROM movies WHERE id
IN(SELECT movie_id FROM stars WHERE person_id
IN(SELECT id FROM people WHERE name = 'Johnny Depp')); */

SELECT movies.title
FROM movies
JOIN stars ON movies.id = stars.movie_id
JOIN people ON stars.person_id = people.id
WHERE people.name = 'Johnny Depp'
AND movies.title IN(
    SELECT movies.title
    FROM movies
    JOIN stars ON movies.id = stars.movie_id
    JOIN people ON stars.person_id = people.id
    WHERE people.name = 'Helena Bonham Carter');