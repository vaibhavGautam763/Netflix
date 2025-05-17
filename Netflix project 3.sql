-- Netflix SQL_Project


-- Create Database
Create DataBase Netflix;

-- Create table Netflix

Drop table If exists Netflix;
Create Table Netflix(
	show_id Varchar(10) Primary Key,
	type Varchar(25),
	title Varchar(150),
	director Varchar(230),
	casts Varchar(800),
	country Varchar(150),
	date_added Varchar(30),
	release_year Int,
	rating Varchar(15),
	duration Varchar(20),
	listed_in Varchar(100),
	description Varchar(300)
);

select * from netflix;

/* Business Problem & Solution Task */

/* Task 1. Count the number of Movies vs TV Shows. */

Select 
	type,
	count(Show_id)
from Netflix
group by 1;

/* Task 2. Find the most common rating for movies and TV shows */
	
select 
	Rating,
	Type
from
	(select 
		rating,
		type,
		count(*),
		Rank() Over(Partition by type order by count(*) desc) as Ranking
	from Netflix
	group by 1,2) As T1 
where ranking = 1;

/* Task 3. List all movies released in a specific year (e.g., 2020) */

select 
	type,
	Title,
	Release_year
from Netflix
Where Type = 'Movie' and Release_year = 2000;


/* Task 4. Find the top 5 countries with the most content on Netflix */

Select * from Netflix;

Select 
	unnest(string_to_array(Country,' ,'))
from Netflix
Where Country is Not Null
Order by 1 Desc
limit 5;



/* Task 5. Identify the longest movie */

Select * from Netflix;

with time1 as (
Select
	*, split_part(duration, ' ', 1)::numeric as time
from Netflix)
select 
	type,
	time
from time1
where type = 'Movie'
and time is not null
order by 2 desc
limit 1;

			-- OR ---
			
select 
	*
from (select type, split_part(duration, ' ', 1)::numeric as time from netflix) as t1
where type = 'Movie' and time is not null
order by time desc
limit 1;

/* Task 6. Find content added in the last 5 years */

Select * from Netflix;

WITH recent_data AS (
  SELECT *,
         TO_DATE(date_added, 'Month DD, YYYY') AS five_year_data
  FROM Netflix
  )
SELECT
	type,
	title,
	Date_added
FROM recent_data
WHERE five_year_data >= CURRENT_DATE - INTERVAL '5 years';

/* Task 7. Find all the movies/TV shows by director 'Rajiv Chilaka'! */

Select * from Netflix;

Select 
	Type,
	director
from Netflix
Where Director = 'Rajiv Chilaka';

/* Task 8. List all TV shows with more than 5 seasons */

Select * from Netflix;

Select
	Type,
	duration
from Netflix
where type = 'TV Show' and duration > '5 season';


/* Task 9. Count the number of content items in each genre */

select * from netflix;

select 
	unnest(String_to_array(listed_in, ',')) as genre,
	count(*) as total_content
from netflix
group by 1
order by 2;

/* Task 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release! */

Select * from Netflix;

Select 
	country,
	release_year,
	count(show_id) as Total_release
from Netflix
where country = 'India'
group by 1,2
order by total_release Desc
limit 5;

/* Task 11. List all movies that are documentaries */
Select * from Netflix;

select
	show_id,
	type,
	listed_in
from Netflix
where type like '%Movie%' and Listed_in like '%Documentaries%';


/* Task 12. Find all content without a director */
Select * from Netflix;

Select
	show_id,
	type,
	director,
	country,
	listed_in
from Netflix
where director is null;

/* Task 13. Find how many movies actor 'Salman Khan' appeared in last 10 years! */
Select * from Netflix;

Select 
	*
from Netflix
Where casts like '%Salman Khan%' 
and Release_year > Extract(year from current_date) - 10;

/* Task 14. Find the top 10 actors 
who have appeared in the highest number of movies produced in India. */
select * from Netflix;

Select 
	unnest(String_to_array(casts, ',')) as actor,
	count(*)
from Netflix
Where type = 'Movie' and Country = 'India'
group by 1
order by 2 desc
limit 10;


/* Task 15. Categorize the content based on the presence of the keywords 'kill' 
and 'violence' in the description field. 
Label content containing these keywords as 'Bad' and all other content as 'Good'. 
Count how many items fall into each category. */
Select * from netflix;

Select
	category,
	count(*) as Total_no_of_content
from
(Select 
case
	when description like '%kill%' or
	 description like '%violence%' then 'bad'
	else 'good'
end as Category
from netflix) as category_content
group by 1;
