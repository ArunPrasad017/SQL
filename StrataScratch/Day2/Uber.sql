/*1. 
Find the average cost of each request status.
Request status can be either 'success' or 'fail'.
Output the request status along with the average cost.
*/
select request_status, 
avg(monetary_cost)
from uber_ride_requests
group by request_status;

/*2 Find the sum of numbers whose index is less than 5 and greater than 5*/
select sum(number)
from transportation_numbers
where index>5
union all
select sum(number)
from transportation_numbers
where index<5


/*3
Find all combinations of 3 numbers that sum up to 8.
Output 3 numbers in the combination.
Avoid summing up a number with itself.
*/
select distinct n1.number, n2.number, n3.number
from transportation_numbers n1
inner join transportation_numbers n2
on n1.index<>n2.index
inner join transportation_numbers n3
on n2.index<> n3.index and n1.index<>n3.index
where n1.number+n2.number+n3.number=8

/*4
Find all number pairs whose first number is smaller than the second one and 
the product of two numbers is larger than 11.
Output both numbers in the combination.*/
select distinct n1.number, n2.number
from transportation_numbers n1
inner join transportation_numbers n2
on n1.index <> n2.index
where n1.number*n2.number>11 and n1.number<n2.number
;

/*5
Find the total costs and total customers acquired in each year.
Output the year along with corresponding total money spent and total acquired customers.
*/
select 
year, sum(money_spent),sum(customers_acquired)
from uber_advertising
group by 1
order by 1;