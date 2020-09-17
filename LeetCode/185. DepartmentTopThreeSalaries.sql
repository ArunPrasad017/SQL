
--solution 1
select d.Name as 'Department', t.name as 'Employee', t.Salary as 'Salary'
from 
(select DepartmentId, Name,Salary, dense_rank() over(partition by DepartmentId order by salary desc)rnk
from Employee)t
inner join Department d
on t.DepartmentId = d.ID
where t.rnk<4

--sol2:
with cte
as
(
    select D.name,E.Id, dense_rank() over(partition by E.departmentID order by Salary desc)rnk
    from Employee E
    inner join Department D
    on D.Id = E.DepartmentId
)
select c.name as 'Department', e.name as 'Employee', e.salary
from cte c
inner join Employee e
on e.id = c.id
where c.rnk<4