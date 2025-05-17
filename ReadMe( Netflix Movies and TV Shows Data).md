# Netflix Movies and TV Shows Data Analysis using SQL

## Introduction
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analysis the distribution of content types (`Movies` vs `Shows`).
- Identify the most common ratings for movies and TV Shows.
- List and Analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Project Structure

### Database Setup

- **Database Creation**: Created a database named `Netflix_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status,
	and return status. Each table includes relevant columns and relationships.

```sql
CREATE DataBase Netflix;
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
```

### Business Problem And Solution

### Task 1. Count the number of Number of Movies Bs TV Shows

```sql
Select 
	type,
	count(Show_id)
from Netflix
group by 1;
```

### Task 2. Find the most common rating for movies and TV shows
```sql
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
```

### Task 3. List all movies released in a specific year (e.g., 2020)
```sql
select 
	type,
	Title,
	Release_year
from Netflix
Where Type = 'Movie' and Release_year = 2000;
```

### Task 4. Find the top 5 countries with the most content on Netflix
```sql
Select 
	unnest(string_to_array(Country,' ,'))
from Netflix
Where Country is Not Null
Order by 1 Desc
limit 5;
```

### Task 5. Identify the longest movie
```sql
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
```
			-- OR ---

```sql		
select 
	*
from (select type, split_part(duration, ' ', 1)::numeric as time from netflix) as t1
where type = 'Movie' and time is not null
order by time desc
limit 1;
```

### Task 6. Find content added in the last 5 years
```sql
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
```

### Task 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
```sql
Select 
	Type,
	director
from Netflix
Where Director = 'Rajiv Chilaka';
```

### Task 8. List all TV shows with more than 5 seasons
```sql
Select
	Type,
	duration
from Netflix
where type = 'TV Show' and duration > '5 season';
```

### Task 9. Count the number of content items in each genre
```sql
select 
	unnest(String_to_array(listed_in, ',')) as genre,
	count(*) as total_content
from netflix
group by 1
order by 2;
```

### Task 10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
```sql
Select 
	country,
	release_year,
	count(show_id) as Total_release
from Netflix
where country = 'India'
group by 1,2
order by total_release Desc
limit 5;
```

### Task 11. List all movies that are documentaries
```sql
select
	show_id,
	type,
	listed_in
from Netflix
where type like '%Movie%' and Listed_in like '%Documentaries%';
```

### Task 12. Find all content without a director
```sql
Select
	show_id,
	type,
	director,
	country,
	listed_in
from Netflix
where director is null;
```

### Task 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
```sql
Select 
	*
from Netflix
Where casts like '%Salman Khan%' 
and Release_year > Extract(year from current_date) - 10;
```

### Task 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
```sql
Select 
	unnest(String_to_array(casts, ',')) as actor,
	count(*)
from Netflix
Where type = 'Movie' and Country = 'India'
group by 1
order by 2 desc
limit 10;
```

### Task 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
```sql
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
```


**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.