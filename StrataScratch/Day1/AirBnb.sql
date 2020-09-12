-- Day1
----------------------------------------------------------------------------------------------------
-- 1. Find the average number of bathrooms and bedrooms by city and property type.
-- Output the result along with the city name and the property type.
select city, property_type, avg(bathrooms) as n_avg_bathrooms, avg(bedrooms) as n_avg_bedrooms
from airbnb_search_details
group by city, property_type

-- 2. Bin the reviews into groups: NO, FEW, SOME, MANY, A LOT based on the number of reviews
/*To better understand the effect of the review count on the price, 
categorize the number of reviews into the following groups along with the log price.
    0 reviews: NO
    1 to 5 reviews: FEW
    5 to 15 reviews: SOME
    15 to 40 reviews: MANY
    more than 40 reviews: A LOT*/
select 
case when number_of_reviews <1 then 'NO'
     when number_of_reviews between 1 and 5 then 'FEW'
     when number_of_reviews between 5 and 15 then 'SOME'
     when number_of_reviews between 15 and 40 then 'MANY'
     when number_of_reviews>40 then 'A LOT'
end as reviews_qualificiation, log_price
from airbnb_search_details

--3. Find the average age of guests reviewed by each host.
-- Output the user along with the average age.
select r.from_user, avg(g.age)
from airbnb_reviews r
    inner join airbnb_guests g
    on r.to_user = g.guest_id
where r.from_type = 'host'
group by r.from_user

--4. Find the average number of searches made by each user and present 
-- the result with their corresponding user id.
select id_user, avg(n_searches)
from airbnb_searches
group by id_user;

--5. Find how many hosts are verified by the Airbnb staff and how many aren't.
select host_identity_verified, count(*)
from airbnb_search_details
group by host_identity_verified

--6. Find the average room-to-bed ratio, per city, among search details for shared rooms
select city,avg(accommodates/beds) as avg_crowdness_ratio
from airbnb_search_details
where room_type = 'Shared room'
group by city
order by avg_crowdness_ratio;

--7.Find the number of hosts that have apartments in countries of which they are not citizens. 
select count(*) as num_hosts
from airbnb_hosts host
inner join airbnb_apartments apt
on host.host_id = apt.host_id
where apt.country<>host.nationality;

--8. Find the price of the cheapest property for every city.
select city, min(log_price)
from airbnb_search_details
group by city

--9. Find the price of the most expensive beach properties for each city. 
-- Output the result along with the city name.
select city, max(log_price)
from airbnb_search_details
where description ilike '%beach%'
group by city;

--10.Find the total number of searches for houses in Westlake neighborhood with a TV among the amenities.
select count(*) 
from airbnb_search_details
where neighbourhood ilike '%westlake%';

--11 Find the first 5 columns by joining search details and contacts datasets.

select *
from airbnb_contacts ac
inner join airbnb_searches ase
on ac.id_guest = ase.id_user
limit 5;

------------------------------------------------------------------------------------------------------------