-- 1. get student ID and score at 90th percentile
-- or How do you find the Nth percentile
select r.studentID, r.Score
from 
(SELECT 
t.StudentID,
t.[Score],
ROW_NUMBER() over(order by t.score asc) as rownum,
count(*) over () as cnt
from TestScore t)r
where cast(r.rownum as float)/r.cnt = 0.9

-- (or)

select max(case when (r.rownum*1.0)/r.cnt<=0.9 then r.score else null end) as '90th'
from 
(SELECT 
t.StudentID,
t.[Score],
ROW_NUMBER() over(order by t.score asc) as rownum,
count(*) over () as cnt
from TestScore t)r
------------------------------------------------------------------------------------------
-- #2 median
select avg(r.score)
from
(SELECT 
t.StudentID,
t.[Score],
ROW_NUMBER() over(order by t.score asc) as rownum,
count(*) over (partition by 1) as cnt
from TestScore t)r
where r.rownum between (cnt+1)/2 and (cnt+2)/2

-- other 
select
PERCENTILE_DISC(0.5) within group(order by t.score asc) over()
from TestScore t
------------------------------------------------------------------------------------------
--3
-- sum of sales by category and sub category
select *, sum(sales) over(partition by categoryID), sum(sales) over(partition by subcategoryID)
from sales_tbl
------------------------------------------------------------------------------------------
--4. sales_begining_of_month_to_current_date
/* input
Order_id, order_date, sales

output:

order_date,sales, sales_begining_of_month_to_current_date
*/

select order_date, sales, 
sum(sales) over(partition by d.start_of_month order by o.order_date rows between unbounded preceding and current row) 
from orders o
join dim_date d
on o.order_date = d.date
------------------------------------------------------------------------------------------

/* 5) Given below data find the manager of the employee, if there is no manager, print "no manager"

Employee ID, employee Name, manager_id
*/

select
e.employeeName,
case when m.employee_name is null then 'no manager' else m.employee_name end as manager
from employee e
left join Employee m
on e.managerid = m.employeeid
------------------------------------------------------------------------------------------
/*
6) Given the below data, find how many employees where in the building at 10:30 AM

Employee_ID, event_type, event_time,
A    IN        06:00
A    OUT       07:14
B    IN        07:25
C    IN        08:45
B    OUT       10:01
D    IN        10:30
A    IN        10:32
B    IN        11:05
C    OUT       12:00
*/
--input
select * into employee_time from
(select 'A' as id, 'IN' as event, '06:00' as event_time
union
select 'A' as id, 'OUT' as event, '07:14' as event_time
union
select 'B' as id, 'IN' as event, '07:25' as event_time
union
select 'C' as id, 'IN' as event, '08:45' as event_time
union
select 'B' as id, 'OUT' as event, '10:01' as event_time
union
select 'D' as id, 'IN' as event, '10:30' as event_time
union
select 'A' as id, 'IN' as event, '10:32' as event_time
union
select 'B' as id, 'IN' as event, '11:05' as event_time
union
select 'C' as id, 'OUT' as event, '12:00' as event_time)t;

select * from
(select *,lead(event_time) over(partition by id order by event_time) as lead_time from employee_time)t
where event = 'IN' and event_time<='10.30' and lead_time>='10.30'

select count(*) as total_emps
from
(SELECT id, event,event_time, lead(event_time) over(partition by id order by event_time) as lead_time
from employee_time)t
where t.event='IN' and t.event_time<='10:30' and (t.lead_time>='10:30' or t.lead_time is null)

--other(with self join)
select * from
(select e1.*,e2.event_time as lead_time
from employee_time e1
left join employee_time e2
on e1.id = e2.id and e1.event_time<e2.event_time and e1.event<>e2.event) t
where t.event = 'IN' and t.event_time<='10.30' and t.lead_time>='10.30'
------------------------------------------------------------------------------------------
--7 Given the below data, find the 2 actors (male and female both) who have worked together in 2 or more movies.

/* actor_id, actor_name, actor_gender, movie_id, movie_name
101, RDJ, M, M01, Avengers
102, Scarlette, F, M01, Avengers
*/

with cte_male as(
    select m.actor_id,m.movie_id
    from movie m
    where m.actor_gender = 'M'
),
cte_female as(
    select m.actor_id,m.movie_id
    from movie m
    where m.actor_gender = 'F'
)
select cm.actor_id, cf.actor_id, count(*)
from cte_male cm
inner join cte_female cf
on cm.movie_id = cf.movie_id
group by cm.actor_id, cf.actor_id
------------------------------------------------------------------------------------------
--11 Find the employees whose salary is more than the average sales in their respective departments.

-- employee_id, employee_name, department_id, salary


select e.* from employees e
join
(select deptid, avg(salary) as avg_sal
from employees e
group by deptid)t
on t.dept_id = e.dept_id
and e.salary>t.avg_sal

-- other method(correlated subquery)
select e.* from Employee 
where e.salary >(select avg(salary) from Employee t 
                where t.dept_id=e.dept_id 
                group by t.dept_id)
------------------------------------------------------------------------------------------
--12 2nd highest salary 
/*
method 1 - using rank or row_number over and order by salary desc where rnk =2
method 2 - using the max(salary) from table where a.salary < subquery(max(salary)) b
*/
------------------------------------------------------------------------------------------
-- 13 -
/*Given the below data, find the following. Students are allowed to take either of 2 subjects i.e. maths or science 

Student_id, student_name, subject_id, subject_name

Find the students who have taken only Maths or Science and NOT both.
*/

select 
t.studentID,
t.studentName
from
(select s.*,
sum(case when s.subject_name='Math' then 1 when s.subject_name='science' then 1 else 0 end) as total_subj_flag
from subjects s)t
where t.total_subj = 1
------------------------------------------------------------------------------------------
-- 14.
/*
 Lets say we have two tables, one maps product to color
and the other table maps stores to products.
*/
drop table table2
select * into table1 from(
    select 'A' as product, 'yellow' as color
    union 
    select 'A' as product, 'blue' as color
    union
    select 'B' as product, 'orange' as color
    union
    select 'C' as product, 'yellow' as color
    UNION
    select 'D' as product, 'blue' as color
    union
    select 'D' as product, 'black' as color
    UNION
    select 'E' as product, 'yellow' as color
)t

select * into table2 from(
    select 1 as store, 'A' as product
    union
    select 1 as store, 'C' as product
    union 
    select 1 as store, 'E' as product
    union
    select 2 as store, 'A' as product
    union
    select 2 as store, 'B' as product
    union
    select 3 as store, 'D' as product
    union
    select 3 as store, 'E' as product
)t

-- a)How many stores have yellow color products?
select count (distinct p.store)
from table1 s
join table2 p
on s.product = p.product
where lower(color) = 'yellow'

--
select count(*) 
from(select
store
from
table1 a,
table2 b
where
a.product=b.product and color='YELLOW'
group by store)t


--b) Which store has the most number of colors of any stores?
select t.store from
(
select store, RANK() over(order by count(t1.color) desc) as rnk
from table1 t1
join table2 t2
on t1.product = t2.product
group by store
)t
where t.rnk =1
-- 
select top 1 store
from
(select
store, a.product,a.color
from
table1 a,
table2 b
where
a.product=b.product)t
group by t.store
order by count(*) desc
--------------------------------
--c) What is the maximum number of colors any store carries?
select t.cnt as max_cnt
from (
    select t2.store, count(*) as cnt, RANK() over(order by count(*) desc) as rnk
    from table1 t1
    join table2 t2 
    on t1.product = t2.product
    group by t2.store
)t
where t.rnk
------------------------------------------------------------------------------------------
-- 15) There are 2 tables with entries of Apples and Oranges sold each day. Write a query to get difference between apples and oranges sold each day.
/*
Fruit, sale_date, sales_amount
Apple, Sep 1st 2015, 100
oranges, sep 1st 2015, 200
*/
select * into fruits_tbl from(
    select 'apple' as fruit, cast('2020-01-01' as date) as sales_date, 100 as sales_amount
    union
    select 'orange' as fruit, cast('2020-01-01' as date) as sales_date, 200 as sales_amount
)t

select sales_date, sum(case when fruit='orange' then -sales_amount else sales_amount end)as diff
from fruits_tbl s
group by sales_date
------------------------------------------------------------------------------------------
-- 16 
/*
Given the below data, flatten out the data in one row.

Cusomer_id, event_type, event_time,
101, 'UBER BOOKED', Sep 1st 10:00 AM
101, 'UBER Confirmed', Sep 1st 10:05 AM
101, 'UBER Arrived', Sep 1st 10:10 AM
101, 'UBER Dropped', Sep 1st 10:30 AM
*/
-- max(case when ) is one possible solution to pivot
select * from (select 
customer_id,
event_type,
event_time
from uber_events)t
pivot(
    max(event_time)
    for event_type in (
        [Uber Booked],
        [Uber Confirmed],
        [Uber Arrived],
        [Uber Dropped]
    )
)piv
------------------------------------------------------------------------------------------
-- 17-difference between union, union all and intersect
------------------------------------------------------------------------------------------
--18 row number without rownumber (assumption is that there is a unique column called name in the table)
select
a.name,
(select count(*) from table1 b where a.name>=b.name) as rownum
from table1 a
------------------------------------------------------------------------------------------
--- 19 - ISLANDS AND GAPS PROBLEM
/*
Given the below data, find out the number of tasks and the time taken to finish every task.

		create table tasks
		(
		start_date date,
		end_date date
		)

		insert into tasks values('2016-09-01','2016-09-02');
		insert into tasks values('2016-09-02','2016-09-03');
		insert into tasks values('2016-09-03','2016-09-04');
		insert into tasks values('2016-09-05','2016-09-06');
		insert into tasks values('2016-09-06','2016-09-07');
		insert into tasks values('2016-09-07','2016-09-08');
		insert into tasks values('2016-09-10','2016-09-11');
		insert into tasks values('2016-09-11','2016-09-12');
*/
SELECT MIN(t.startdate) as task_start_date, MAX(t.enddate) as task_end_date, count(*) as duration
FROM
(SELECT
startdate, enddate, ROW_NUMBER() over(ORDER by startDate) as rn, day(startdate) - ROW_NUMBER()OVER(ORDER BY STARTDATE) as diff
from tasks)T
group by t.diff
------------------------------------------------------------------------------------------
--20
/*
Given the below table, give me the list of all objects which are associated with all tags.

Objects table - has object ID and object name.
Tags Table: has tag ID and Tag name
Bridge table: mapping relation between tag and objects
*/

select o.obj_id
from objects o
join bridge b
on b.obj_id = o.obj_id
where b.tag_id = all(select tag_id from tags)
--or--
with cte as(
    select o.obj_id,count(b.tag_id) as cnt
    from objects o
    join bridge b
    on o.obj_id = b.bridge_id
    join tags t
    on t.tag_id = b.tag_id
),
cte2 as(
    select count(*) as tag_cnt
    from tags
)
select cte1.obj_id
from cte1
join cte2
on cte1.cnt = cte2.tag_cnt
------------------------------------------------------------------------------------------
--21
/*
Given thebelow tables, find the list of authors for which the books count dont match with the books table.

			Books
           ------------------
           Book_id (PK)
           book_name
           Author_id (FK to authors.author_id)
           published_date
           number_of_words
           number_pages
           number_of_sales

           Authors
           -------------------
           Author_id (PK)
           author_name
           Number_of_books_written
*/
with cte1 as(
    select author_id, count(distinct book_id) as cnt
    from books 
    group by author_id
),
cte2 as (select author_id, number_of_books_written
from authors
)
select author_id
from cte1
join cte2
on cte1.author_id = cte2.author_id
and cte1.cnt<>cte2.number_of_books_written
------------------------------------------------------------------------------------------

--21 b) recursive cte for manager to employee -- managerid = empid for VP

with rec_cte as(
    select employee_id, employee_name,manager_id, employee_name as mgr_name
    from employee
    where employee_id = manager_id -- or manager_id is null for other cases when it is null
    union ALL
    select employee_id, employee_name,r.employee_id, r.employee_name as mgr_name
    from Employee e
    join rec_cte r
    on e.manager_id = r.employee_id
)
select * from rec_cte where mgr_name = 'ABCXYZ'
-- if not recursive then we can use the left join of employee table with the manager type table
------------------------------------------------------------------------------------------
-- 22) Given the below data, explore it for every start and end point. meaning replicate the rows.
/*
city 		start_ip 	end_ip
seattle 	100			200
portland 	300			400
San Jose	500			700
*/
select * into cities from(
    select 'seattle' as city, 100 as start_ip, 200 as end_ip
    union
    select 'portland' as city, 300 as start_ip, 400 as end_ip
    union 
    select 'san jose' as city, 500 as start_ip, 700 as end_ip
)t

select city, start_ip, end_ip,
start_ip+sum(1) over(PARTITION BY city order by city rows unbounded preceding) as row_rnk
from cities
------------------------------------------------------------------------------------------
-- 25.Given the below table, rank the salary of employees in each depart in descing and rank commission of employees in each dept in ascending
-- Employee_id, employee_name, Dept_id, salary, commision

select employee_name, Dept_id,salary, commision,
rank() over(partition by dept_id order by salary desc),
rank() over(partition by dept_id order by commission asc)
from Employees e
------------------------------------------------------------------------------------------
--26
/*
 Given two tables Friend_request (requester_id, sent_to_id, time) Request_accepted (acceptor_id, requestor_id, time) Find the overall acceptance rate of requests
Assumption: It can take upto one week to accept a request.
*/
-- acceptance ratio is just (total number of requests accepted)/(total number of requests made)
with cte_total as(
    select count(*) as total_requests from (select distinct requester_id, send_to_id 
    from Friend_request)t

),
cte_accepted as(
    select count(*) as accepted_requests from (select distinct acceptor_id, requestor_id
    from request_accepted)
)
select cast(c2.accepted_requests as float)/c1.total_requests
from cte_total c1, cte_accepted c2

------------------------------------------------------------------------------------------
--30) Given a table which has 2 columns seat number and status of a movie hall.
--  Given me the list of 5 consecutive seats in a row which are vacant and which can be booked.

Create table movies
(
seat_num integer,
status varchar(100)
);

insert into movies values(1,'booked');
insert into movies values(2,'Available');
insert into movies values(3,'Available');
insert into movies values(4,'Available');
insert into movies values(5,'booked');
insert into movies values(6,'booked');
insert into movies values(7,'booked');
insert into movies values(8,'booked');
insert into movies values(9,'booked');
insert into movies values(10,'Available');
insert into movies values(11,'booked');
insert into movies values(12,'Available');
insert into movies values(13,'Available');
insert into movies values(14,'Available');
insert into movies values(15,'Available');
insert into movies values(16,'Available');
insert into movies values(17,'Available');
insert into movies values(18,'booked');
insert into movies values(19,'booked');
insert into movies values(20,'Available');
insert into movies values(21,'Available');
insert into movies values(22,'Available');
insert into movies values(23,'booked');
insert into movies values(24,'booked');
insert into movies values(25,'booked');
insert into movies values(26,'booked');
insert into movies values(27,'Available');
insert into movies values(28,'Available');
insert into movies values(29,'Available');
insert into movies values(30,'Available');
insert into movies values(31,'Available');
insert into movies values(32,'booked');

-- gaps and islands problem (we needed to add a clause for availability as we are looking for most continous islands)
select min(seat_num), max(seat_num), count(*)
from
(select seat_num,[status],
ROW_NUMBER() over(order by seat_num) as rn,
seat_num - ROW_NUMBER() over(order by seat_num) as diff
from movies
where [status] = 'Available')t
group by diff
having count(*)>5
order by count(*)
------------------------------------------------------------------------------------------------------------
--53 - Given a table which has one column which has only integer values, 
-- write a query to find max value from this table without 
-- using any of MAX, RANK, Window functions.

create table test_tbl(col1 int)
insert into test_tbl values(1)
insert into test_tbl values(2)
insert into test_tbl values(3)
insert into test_tbl values(4)
insert into test_tbl values(5)
insert into test_tbl values(7)
insert into test_tbl values(6)

select 
a.col1
from test_tbl a
left join test_tbl b
on a.col1>b.col1
group by a.col1 
having count(*) = (select count(*) from test_tbl)-1
------------------------------------------------------------------------------------------------------------
--54
/*
Given the below table data, give the number of first time visitors per day.

user_id date
adam	jan 1st
adam	jan 2nd
adam	jan 3rd
kartik	jan 4th
vong	jan 3rd

*/
select date, count(*)
from 
(select user_id,min(date) -- per user's min date(might be more than 1 person logging in for the first time in that date)
from visits
group by user_id)
group by date
------------------------------------------------------------------------------------------------------------
--55
/*
Given the below table data, give the count of visitors who came the previous day and the current day as well

user_id date
adam	jan 1st null
adam	jan 2nd jan1
adam	jan 4th jan2
adam 	jan 5th jan4
kartik	jan 4th null
kartik jan 5th jan4th
vong	jan 3rd null

Output:

jan 1st 0
jan 2nd 1
jan 3rd 0
jan 4th 0
jan 5th 2
*/
-- drop table visitors

select * into visitors from(
    select 'Adam' as userid, '2020-01-01' as tdate
    UNION
    select'Adam' as userid, '2020-01-02' as tdate
    union
    select 'Adam' as userid, '2020-01-04' as tdate
    UNION
    select 'Adam' as userid, '2020-01-05' as tdate
    UNION
    select 'Karthik' as userid, '2020-01-04' as tdate
    UNION
    select 'Karthik' as userid, '2020-01-05' as tdate
    UNION
    select 'vong' as userid, '2020-01-03' as tdate

)t

--solution
select t.tdate, sum(case when datediff(day,t.tdate,t.lag_date) = -1 then 1 else 0 end) as visit_cnt
from
(select userid, tdate, lag(tdate) over (partition by userid order by tdate asc) as lag_date
from visitors)t
group by t.tdate

------------------------------------------------------------------------------------------------------------
--56 (Solution from previous practice) TBD in 3
/*
Order table (OrderId, OrderDate, Customer_id) -- assuming that customer_id is added to this table(not defined in qustions found)

Item Table (ItemId, Name)

Order Item table (OrderId, ItemId)

1. Find all customers who purchased items - Kindle and Alexa both (Exclude customers who purchased only 1 item)
2. Find the items in the first purchase for a customer - Print customer id, item id
3. Delete duplicate rows from the Order table  
*/
--1. answer
select t.customer_id
from
(
    select o.customer_id,
    sum(case when i.name ='Alexa' then 1 when i.name = 'Kindle' then 1 else 0 end) as ka_sum
    from Orders o
    join OrderItem oi
    on o.OrderId = oi.OrderID
    join Item i
    on i.itemId = oi.itemID
)t
where t.ka_sum<>0 and t.ka_sum%2=0

--2 answer
select o.customer_id, oi.item_id
from Orders o
join 
(
    select o1.customer_id, min(o1.order_date) as first_order_date
    from orders o1
    group by o1.customer_id
)t
on  t.customer_id = o.customer_id
    and o.order_date = t.first_order_date
join orderItem oi
on t.orderid = oi.ORDER_id

--3 
-- brute way to do using window functions
delete from orders where
(select o.*, ROW_NUMBER() over (order by o.OrderID asc,o.OrderDate asc) as rnk
from orders o
)t where t.rnk<>1
------------------------------------------------------------------------------------------------------------
--57
-- drop table f_users
select * into f_users from(
    select 'ashish' as userid, 'richa' as friendid
union
select 'ashish' as userid, 'sia' as friendid
union all
select 'ashish' as userid, 'sia' as friendid
)t

select * into f_pages from(
    select 'ashish' as userid, 'whatsapp' as pagename
union
select 'ashish' as userid, 'chir' as pagename
union
select 'richa' as userid, 'fb' as pagename
union
select 'richa' as userid, 'whatsapp' as pagename
union
select 'sia' as userid, 'amazon' as pagename
)t

--Solution
select *
from f_users u
join f_pages p
on u.friendid = p.userid
where p.pagename not in(select s.pagename from f_pages s where u.userid = s.userid)
------------------------------------------------------------------------------------------------------------
--58

select right('Hello',2)

------------------------------------------------------------------------------------------------------------

-- repracticing most programs
-- 1. Nth Percentile 95th percentile
select max(case when cast(row_num as float)/cnt <=0.95 then score else null end) as 
from 
(select score,
ROW_NUMBER() over (order by score asc) as row_num,
count(*) over() as cnt
from percentile)t

-- 2. 
SELECT avg(test)
from 
(select
test, count(*) over () as cnt, ROW_NUMBER() over(order by id)rn
from median_tbl)t
where rn BETWEEN (cnt+1)/2 and (cnt+2)/2

-- 3,4 already done
-- 5 is a self join (manager and employee scenario)
-- 6
select t.*
from
(
    select id, event, event_time, LEAD(event_time) over (partition by id order by event_time) as next_event
    from employee_time e
) t where t.event = 'IN' and t.event_time <= '10:30' and (t.next_event is null or t.next_event > '10:30');
------------------------------------------------------------------------------------------------------------
-- 10
select m.actor_name, f.actor_name, count(*)
from
(
    select actor_name, movie_id
    from movies
    where actor_gender = 'M'
)m
join 
(
    select actor_name, Movie_id
    from movies 
    where actor_gender = 'F'
)f
on m.movie_id = f.movie_id
group by m.actor_name, f.actor_name,
having count(*)>=2
---------------------------------------------------------------------------------------------------------------
-- 11 
select e.employee_id, e.employee_name, e.department_id, e.salary
from Employee e
join (
    select e.department_id, avg(salary) as avg_sal
    from Employee e
    group by e.department_id
)t
on e.department_id = t.department_id
and e.salary>t.avg_sal
---------------------------------------------------------------------------------------------------------------
--12 use rank or join table twice- where a.salary<b.salary
---------------------------------------------------------------------------------------------------------------
--13 maths or science (we can use the sum(case when) - involves hardcoding the case statements in the )
---------------------------------------------------------------------------------------------------------------
--14 
-- a) instead of distinct we used the group by option to eliminate duplicates
select count(*)
from
(select t2.store
from table1 t1
join table2 t2
on t1.product = t2.product and lower(t1.color) = 'yellow'
GROUP by t2.store)t

--b) 
select t.store
from
(select t2.store,rank() over (order by count(t1.color) desc)rnk
from table1 t1
join table2 t2
on t1.product = t2.product 
group by t2.store)t
where t.rnk=1

--c)
select top 1 cnt
from
(select t2.store, count(t1.color) cnt
from table1 t1
join table2 t2
on t1.product = t2.product
group by t2.store
)t
order by t.cnt desc
---------------------------------------------------------------------------------------------------------------
-- 15)
select sales_date, sum(case when fruit = 'orange' then -sales_amount else sales_amount end) as total_sales
from fruits_tbl
group by sales_date
---------------------------------------------------------------------------------------------------------------
-- 16) pivot table or case when 
-- 17) 
--18(only happens in an ordered list)
select c1.Col, (select count(*) from cols c2 where c1.Col>=c2.col) as rnum
from Cols c1
---------------------------------------------------------------------------------------------------------------
--19)
select min(startdate), max(enddate)
from
(select startdate, enddate,
day(startdate) - ROW_NUMBER() over(order by startdate) as rownm
from tasks)t
group by t.rownm
---------------------------------------------------------------------------------------------------------------
--20) all object with all tags
select t1.obj_id
from 
(select o.obj_id, count(t.tag_id) as cnt
from objects o
join bridge b
on b.obj_id = o.obj_id
join tags t
on t.tag_id = b.bridge_id) t1
join 
(select count(*) as cnt
from tags)t2
on t1.cnt  = t2.cnt
---------------------------------------------------------------------------------------------------------------
--21) 
-- select t.author_id
-- from (select author_id, count(book_id) as cnt
-- from books b
--group by author_id)t
-- join authors a
-- on a.author_id = t.author_id
-- and a.num_books_written <> a.cnt
---------------------------------------------------------------------------------------------------------------
--21 recursive cte
-- assuming vp's id = emp_id
/*
with rec_cte as(
    -- anchor query
    select e.emp_id, e.emp_name, e.mgr_id, e.mgr_name
    from employee e
    where e.emp_id = e.mgr_id
    union all
    select e.emp_id, e.emp_name, e.mgr_id, r.emp_name
    from employee e
    join rec_cte r
    on r.emp_id = e.mgr_id
)
select * from rec_cte where id = 1
*/
---------------------------------------------------------------------------------------------------------------
--22,23,24
---------------------------------------------------------------------------------------------------------------
--25 using row_number over() for both cases one ascending and one descending
---------------------------------------------------------------------------------------------------------------
--26
with cte_requests as(
    select count(cnt) as total_requests from (
        select count(*) as cnt
        from f_users
        group by userid, friendid)t
),
cte_accepted as(
    select count(*) as total_accept from (select acceptor_id, requester_id
    from f_accepted
    group by acceptor_id, requester_id)t
)
select cast(c2.total_accept as float)/c1.total_requests
from cte_requests c1, cte_accepted c2
---------------------------------------------------------------------------------------------------------------
--27 - rolling sum using the rows between concept 
-- rows between 1 and between 2 gives out the rolling two day sum
---------------------------------------------------------------------------------------------------------------
-- 28 second highest salary in dept
---------------------------------------------------------------------------------------------------------------
-- 28 Given the below table, get all actor who has acted in maximum number of movies.

-- Movie_id, City, Location_id, Actor_1, Actor_2, Actor_3

select actor, sum(cnt) as total_movies_acted
from 
(select m1.actor1 as actor,
count(*) as cnt
from movies m1
group by m1.actor1
union all
select m2.actor2 as actor,
count(*) as cnt
from movies m2
group by m2.actor2
union all
select m3.actor3 as actor,
count(*) as cnt
from movies m3
group by m3.actor3)t
group by t.actor
order by sum(cnt) desc 
---------------------------------------------------------------------------------------------------------------
-- 29
---------------------------------------------------------------------------------------------------------------


--10/04/2020 Practice3
-- 1.nth percentile
with cte as(select score, ROW_NUMBER() over (order by score asc) as rownum, count(*) over() as cnt
from tbl1)
SELECT max(case when (rownum as float)/cnt <=0.9 then score else 0 end) as nth_percentile --or cast((rownum*100) as float)/cnt<=90 
from cte

--2. median
SELECT avg(t.score) as median_score
from 
(SELECT score, ROW_NUMBER() over(order by score) as rownum, count(*) over () as cnt
from tbl1)t
where t.rownum between (cnt+1)/2 and (cnt+2)/2

--3. Sum(amt) over(partition by categoryid), Sum(amt) over(partition by subcategoryid) to get the value

--4. Order_id, order_date, sales
-- order_date, sales, sales_month_to_date

select o.order_date, 
    sum(sales) over(partition by o.order_date) as sales,
    sum(sales) over(partition by d.FirstDateofMonth order by o.order_date rows between unbounded preceding and current row) as sales_month_to_date
from sales_test o
join dim_date d
on d.date = o.order_date

insert into Sales_test values('2016-12-01',2000,1)
insert into Sales_test values('2016-12-02',3000,1)

--5 
select
e1.EmpName,
case when e2.id is null then 'no manager' else e2.EmpName end as manager
from employees e1
left join Employees e2
on e1.mgr_id = e2.emp_id

--6
-- select * from employee_time
with cte1 as(select id, event,event_time, lead(event_time) over(partition by id ORDER BY event_time) as next_event_time
from employee_time)
select count(id) as cnt
from cte1 c
where c.event = 'IN' and c.event_time<='10:30' and (c.next_event_time >'10:30' or c.next_event_time is null)

--10 2 or more movies
with cte_male as (
    SELECT Movie_id,actor_id, actor_name
    from actors
    where gender = 'M'
),
cte_female as (
    SELECT Movie_id,actor_id, actor_name
    from actors
    where gender = 'F'
)
select c1.actor_id, c2.actor_id
from cte_female c1
join cte_male c2
on c1.Movie_id = c2.Movie_id
group by c1.actor_id, c2.actor_id
having count(distinct movie_id) >=2


--11 employees greater than avg salary in dept
SELECT empid, EmpName
from employees e
join
(select Department_id, avg(salary) as avg_sal
group by Department_id)t
on e.department_id = t.department_id
and e.salary>t.avg_sal

--12 2nd highest(do the max_score byranking)

-- 13 either one subject only
select t.student_id,t.student_name
from
(select student_id, student_name, sum(case when subject_name ='math' then 1 
                                      when subject_name ='science' then 1
                                      else 0 end) as flag_cnt
from student)t
where t.flag_cnt =1

-- similarly for both then %2=0 and flag_cnt<>0

--14a
select count (distinct(t2.store))
from table1 t1
join table2 t2
on t1.product = t2.product
where t1.color = 'yellow'

--14b
select t.store
from
(select t2.store, row_number() over(order by count(t1.color) desc) as rnk
from table1 t1
join table2 t2
on t1.product = t2.product
group by t2.store)t
where t.rnk=1

--14c
select t.cnt as max_cnt
from
(select t2.store, count(t1.color) as cnt,row_number() over(order by count(t1.color) desc) as rnk
from table1 t1
join table2 t2
on t1.product = t2.product
group by t2.store)t
where t.rnk=1


--15
select sales_date, sum(case when lower(fruit)='orange' then (-1.0*sales_amount) else sales_amount end) as diff
from fruits_tbl
group by sales_date

--16 -- flatten data using max(case when)

--19 - Islands and Gaps problem as a task reference
select min(t.startdate) as task_start, max(t.enddate) as task_end, DATEDIFF(day,min(t.startdate) ,max(t.enddate)) as num_of_tasks
from 
(select 
startdate, enddate,
day(enddate) - ROW_NUMBER() over (order by startdate) as diff
from tasks)t
group by t.diff

--20 - Given the below table, give me the list of all objects which are associated with all tags.
select obj.object_id, obj.object_name
from
(SELECT o.object_id, o.object_name, count(*) as cnt
from objects o
join bridge b
on o.object_id = b.object_id
group by o.object_id, o.object_name)obj
join 
(select count(*) as cnt
from tags)tag
on tag.cnt = obj.cnt

--21 - authors count <> count of books by author
--21 b all subordinates under a single manager
with rec_cte as(
    select emp_id
    from Employee
    where emp_id = mgr_id
    union all
    select e.emp_id
    from employee e
    join rec_cte c
    on e.mgr_id = c.emp_id
)
select *
from rec_cte where manager_name = 'ABC'

--25 rank() or row_number() over
