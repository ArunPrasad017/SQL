/*
Find the average distance traveled in each hour.
Output the hour along with the corresponding average traveled distance.
Sort records by the hour in ascending order.
*/
select 
    hour,
    avg(travel_distance)
from lyft_rides
group by hour
order by hour asc;