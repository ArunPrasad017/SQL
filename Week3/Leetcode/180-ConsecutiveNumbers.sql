/*
Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
*/
select num as 'ConsecutiveNums'
from 
(
    SELECT id, num,
    lag(num,1) over(order by id) as lag_A,
    lag(num,2) over(order by id) as lag_B
    from Logs
)t
where t.num = t.lag_A and t.lag_A = t.lag_B