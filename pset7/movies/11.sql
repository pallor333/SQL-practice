/*In 11.sql, write a SQL query to list the titles of the five highest rated movies (in order) that Chadwick Boseman
starred in, starting with the highest rated.
Your query should output a table with a single column for the title of each movie.
You may assume that there is only one person in the database with the name Chadwick Boseman.*/

/*SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

SELECT title FROM movies -- title of movies
SELECT rating FROM ratings WHERE movie_id -- rating of movies
SELECT movie_id FROM stars WHERE person_id -- get movie_id
SELECT id FROM people WHERE name = 'Chadwick Boseman' -- get person_id

--Find all movies Chadwick Boseman starred in
SELECT title FROM movies WHERE id IN(SELECT movie_id FROM stars WHERE person_id
IN(SELECT id FROM people WHERE name = 'Chadwick Boseman')); */

SELECT movies.title
FROM movies
JOIN ratings ON movies.id = ratings.movie_id
JOIN stars ON ratings.movie_id = stars.movie_id
JOIN people ON people.id = stars.person_id
WHERE people.name = 'Chadwick Boseman'
ORDER BY rating DESC LIMIT 5;
