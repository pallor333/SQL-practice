--In 8.sql, write a SQL query to list the names of all people who starred in Toy Story.
--Your query should output a table with a single column for the name of each person.
--You may assume that there is only one movie in the database with the title Toy Story.

/*
SELECT people.name FROM people -- Get column of people names
SELECT stars.person_id FROM stars -- Get column of people_id stars
SELECT movies.id FROM movies -- Get column of movie ids

WHERE movies.title = 'Toy Story';
*/

SELECT name
FROM people
WHERE id IN(
    SELECT person_id
    FROM stars
    WHERE movie_id IN(
        SELECT id
        FROM movies
        WHERE title = 'Toy Story'));


