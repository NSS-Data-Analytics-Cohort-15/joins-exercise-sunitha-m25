select * from specs;

select * from revenue;

select * from rating;

select * from distributors;

--Q1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT film_title,release_year, min(worldwide_gross)
FROM specs 
JOIN revenue  USING(movie_id)
GROUP BY film_title,release_year
ORDER BY min(worldwide_gross);
--Answer= Semi_Tough, 1977 (37187139) 

--Q2. What year has the highest average imdb rating?
SELECT film_title,release_year,avg(imdb_rating)
FROM specs
JOIN rating using(movie_id)
GROUP BY film_title,release_year
ORDER BY avg(imdb_rating) DESC;
--Answer=The Dark Knight, 2008 (9.0)

--Q3. What is the highest grossing G-rated movie? Which company distributed it?
SELECT film_title,company_name, max(worldwide_gross),mpaa_rating
FROM specs
JOIN revenue USING (movie_id)
JOIN distributors on specs.domestic_distributor_id = distributors.distributor_id
WHERE specs.mpaa_rating = 'G'
GROUP BY film_title,company_name ,mpaa_rating
ORDER BY max(worldwide_gross) DESC;
--Answer=Toy Story 4 (1073394593)

--Q4.Write a query that returns, for each distributor in the distributors table, the distributor name and the number of --movies associated with that distributor in the movies table. Your result set should include all of the distributors, ---whether or not they have any movies in the movies table.
SELECT d.company_name, count(s.film_title)
FROM distributors d
LEFT JOIN specs s on d.distributor_id = s.domestic_distributor_id
GROUP BY d.company_name;
--Answer: 23 rows returned 

--Q5. Write a query that returns the five distributors with the highest average movie budget.
SELECT DISTINCT(d.company_name),ROUND(avg(r.film_budget),2)
FROM specs s
JOIN distributors d on s.domestic_distributor_id = d.distributor_id
JOIN revenue r on s.movie_id = r.movie_id
group by d.company_name
ORDER BY 2 desc
LIMIT 5;

--Q6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of 
--these movies has the highest imdb rating?
SELECT s.film_title, d.company_name,d.headquarters, r.imdb_rating
FROM specs s
JOIN distributors d on d.distributor_id = s.domestic_distributor_id
JOIN rating r on r.movie_id = s.movie_id
WHERE d.headquarters NOT LIKE '%CA'
--ANswer = 2, Dirty DAncing(7.0)

--Q7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
select * from (
SELECT   'Over 2 Hours' as AvgMovieLength, round(avg(r.imdb_rating),2) as AverageRating
FROM specs s
JOIN rating r USING(movie_id)
WHERE s.length_in_min > 120 
UNION 
SELECT  'Below 2 Hours' as AvgMovieLength, round(avg(r.imdb_rating),2)  as AverageRating
FROM specs s
JOIN rating r USING(movie_id)
WHERE s.length_in_min < 120 
)
order by 2 desc
LIMIT 1
--Answer is Over 2 Hours (7.26 Rating)

































































