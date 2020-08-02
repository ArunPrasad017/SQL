CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        /* Write your T-SQL query statement below. */

        select s.salary
        from (
                select distinct salary, dense_rank() over (order by salary desc)rnk
                from Employee
             )s
        where s.rnk=@N
    );
END