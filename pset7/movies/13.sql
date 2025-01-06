/*
In 13.sql, write a SQL query to list the names of all people who starred in a movie in
which Kevin Bacon also starred.
Your query should output a table with a single column for the name of each person.
There may be multiple people named Kevin Bacon in the database.
Be sure to only select the Kevin Bacon born in 1958.
Kevin Bacon himself should not be included in the resulting list. */

/*
SELECT name FROM people WHERE id            -- Find names from person_ids
SELECT person_id FROM stars WHERE movie_id  -- Find person_id's of movies KB was in
SELECT id FROM movies WHERE id              -- KB movie_id -> movies KB was in
SELECT movie_id FROM stars WHERE person_id  -- Get KB's movie_id
SELECT id FROM people WHERE name = 'Kevin Bacon' AND birth = 1958; -- Get Kevin Bacon's people_id
*/

SELECT name FROM people
WHERE id IN(
    SELECT person_id
    FROM stars
    WHERE movie_id IN(
        SELECT id
        FROM movies
        WHERE id IN(
            SELECT movie_id
            FROM stars
            WHERE person_id IN(
                SELECT id
                FROM people
                WHERE name = 'Kevin Bacon' AND birth = 1958))))
and name != 'Kevin Bacon';
