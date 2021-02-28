/* Write a SQL query to find all numbers that appear at least three times consecutively.

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

-- Solution 1
select distinct(t.num) as 'ConsecutiveNums'
from
(select 
num, lead(num,1) over (order by id) lead_1, lead(num,2) over (order by id)lead_2
from Logs
)t
where t.num = t.lead_1
and t.num=t.lead_2

-- Solution 2
--consecutive nums with self joins
select distinct(l1.num) as 'ConsecutiveNums'
from logs l1
inner join logs l2
on l1.id = l2.id+1
and l1.num=l2.num
inner join logs l3
on l2.id=l3.id+1
and l2.num = l3.num