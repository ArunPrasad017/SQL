/* 1. Find the top 5 businesses with most reviews.
Output the business name along with the total number of reviews.
Order records by the total reviews in descending order.
*/
select name, sum(review_count) as total_of_reviews
from yelp_business
group by name
order by total_of_reviews desc
limit 5;

/*2*/
select
categories, sum(review_count) as total_reviews
from yelp_business
group by categories
order by total_reviews desc;

/*3
Find the average number of stars for each state.
Output the state name along with the corresponding average number of stars.
*/
select state, avg(stars)
from yelp_business
group by state;

/*4*/
select max(cool) from yelp_reviews;

/*5
Find the number of entries per star.
Output each number of stars along with the corresponding number of entries.
Order records by stars in ascending order.
*/
