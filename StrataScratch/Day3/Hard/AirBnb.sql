/*1. Find the min, avg and max log price per review qualification
Find the min, avg, and max log_price, for each review qualification category. 
The review qualification is categorized by the number of reviews as defined below, along with the associated log_price.
    0 reviews: NO
    1 to 5 reviews: FEW
    5 to 15 reviews: SOME
    15 to 40 reviews: MANY
    more than 40 reviews: A LOT*/

select min(b.log_price), avg(b.log_price), max(b.log_price),
case when b.number_of_reviews between 1 and 5 then 'FEW'
when b.number_of_reviews between 5 and 15 then 'SOME'
when b.number_of_reviews between 15 and 40 then 'MANY'
when b.number_of_reviews>40 then 'A LOT'
else 'NO'
end as review_qual
from airbnb_search_details b
group by review_qual;

-- or 
select s.review_qual, min(s.log_price), avg(s.log_price), max(s.log_price)
from
(select
    case when b.number_of_reviews between 1 and 5 then 'FEW'
    when b.number_of_reviews between 5 and 15 then 'SOME'
    when b.number_of_reviews between 15 and 40 then 'MANY'
    when b.number_of_reviews>40 then 'A LOT'
    else 'NO'
end as review_qual,
log_price
from airbnb_search_details b)s
group by s.review_qual;



/* 2. Estimate the growth of Airbnb over each year by looking 
at the count of hosts registered for each year and present the result along with the year. Order the result in the ascending order based on the year. */

select t.host_since, t.total_people_registered, 
t.prev_total_people_registered, 
concat(cast(round((100*cast((t.total_people_registered - t.prev_total_people_registered) as numeric)/cast(t.prev_total_people_registered as numeric)),2) as varchar), '%') as estimated_growth
from (
select host_since, count(*) as total_people_registered,
coalesce(LAG(count(*)) over (order by host_since),1) as prev_total_people_registered
from airbnb_search_details
group by host_since
order by host_since
)t ;



/*3
Find guests of which gender are more generous in giving positive reviews based on review scores.
If male guests have given more review scores output as 'Males are more generous'. Otherwise, output as 'Females are more generous'.
*/
select 
case when m.male_rev_score>f.female_rev_score then 'Females are more generous' -- the data seems to be misleading as males are generous as per the total average
else 'Males are more generous'
end as winner
from 
(select avg(review_score) as male_rev_score
from airbnb_reviews r
inner join airbnb_guests g
on r.from_user = g.guest_id
where g.gender = 'M')m,
(select avg(review_score) as female_rev_score
from airbnb_reviews r
inner join airbnb_guests g
on r.from_user = g.guest_id
where g.gender = 'F')f
;

/*4
Find neighborhoods where you can sleep on a real bed in a villa with beach access while paying the minimum price possible. 

*/
select neighbourhood
from airbnb_search_details
where log_price =
(select min(log_price)
    from airbnb_search_details
    where lower(property_type) = 'villa'
    and lower(bed_type) = 'real bed'
    and description ILike '%beach%')
order by neighbourhood
    ;