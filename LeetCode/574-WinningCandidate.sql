/*
Table: Candidate

+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+  
Table: Vote

+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+
id is the auto-increment primary key,
CandidateId is the id appeared in Candidate table.
Write a sql to find the name of the winning candidate, the above example will return the winner B.

+------+
| Name |
+------+
| B    |
+------+
Notes:

You may assume there is no tie, in other words there will be only one winning candidate.
*/


/* Write your T-SQL query statement below */
-- solution 1
select t.name 
from
( select c.Name, rank() over(order by count(v.id) desc)rnk
from candidate c
join vote v
on c.id = v.CandidateId
group by c.name
)t
where t.rnk=1


-- solution 2
-- this is faster as the scan happens only until the first record
select top 1 t.name from
(select c.Name, count(v.id) as cnt
from candidate c
join vote v
on c.id = v.CandidateId
group by c.name)t
order by t.cnt desc