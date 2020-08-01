
1. Median: 50th percentile
with cte as
(
	select marks,
	row_number() over (order by marks asc)row_num,
	cnt = count(*) over ()
	from classA
)
select avg(c.marks)
from cte c
where c.row_num in ((cnt+1)/2,  (cnt+2)/2)

================================================================================================================================================
-- 2. 90th percentile(Nth percentile)
with cte as
(
	select marks,
	row_number() over (order by marks asc)row_num,
	cnt = count(*) over ()
	from classA
)
select max(case when c.row_num/c.cnt<=0.9 then c.marks else null) as NthPercentile
from cte c

/*================================================================================================================================================*/
-- 3. How to find sum of sales by Category and sub category.

-- Table:
-- Customer ID, Product ID, Category ID, sub Category ID, Sales
-- kartik, P001, C001, S001, 1000

-- Output:
-- Customer ID, Category ID, Sub Category ID, Sales, Sales by Category, Sales by Sub Category.


Ans:	select Category ID, subcategoryID, sum(Sales)
		from table
		group by Category ID, subcategoryID
/*
	The understanding was wrong on this one we need to find the sum of sales category and sub category along with the other params shown, more like
	a cumulative sum on the side. Below is the corrected code
*/

select CustomerID,CategoryID, subcategoryID, sales,
sum(Sales) over(partition by CategoryID) as sales_by_category,
sum(Sales) over(partition by subCategoryID) as sales_by_subcategory
from table
/*================================================================================================================================================*/
-- 5) Given below data find the manager of the employee, if there is no manager, print "no manager"

-- Employee ID, employee Name, manager_id

-------------- Wrong one --------------
-- select 
-- e1.employeeName as 'EmpName',
-- ISNULL(e2.employeeName, 'no manager')
-- from employee e1
-- left join employee e2
-- on e1.manager_id = e2.emp_id
-----------------------------------
select 
e1.emp_id,
case 
when e2.emp_id is null then 'no manager' 
else e2.emp_name
end as emp
from employees e1
left join employees e2
on e1.manager_id = e2.emp_id

/*================================================================================================================================================*/
/* 6) Given the below data, find how many employees where in the building at 10:30 AM  --Involves lead/lag and will need to be learnt

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
/*================================================================================================================================================*/
