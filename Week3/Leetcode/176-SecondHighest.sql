/*
Write a SQL query to get the second highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

For example, given the above Employee table, the query should return 200 as the 
second highest salary. If there is no second highest salary, 
then the query should return null.

Hint: There is an issue that while using dense_rank or rank function we end up with
a no null return value error when the actual rank value is unavailable.
We can help this when we use rank along with the max or any aggregate function then we 
can get null case resolved.

*/

/* Write your T-SQL query statement below */

with cte
as
(
    select salary, dense_rank() over (order by Salary desc)rnk
    from employee
)
select max(c.salary) as 'SecondHighestSalary'
    from cte c
    where rnk = 2
