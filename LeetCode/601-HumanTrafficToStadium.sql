/*
X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

For example, the table stadium:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
For the sample data above, the output is:

+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
*/

select id, visit_date, people
from
(select id, visit_date, people,
lag(people,1) over (order by id, visit_date) as l2,
lag(people,2) over (order by id, visit_date) as l3,
lead(people) over(order by id, visit_date) as p2,
lead(people,2) over(order by id, visit_date) as p3
from stadium)t
where (t.people>=100 and t.p2>=100 and t.p3>=100) 
        or(t.people>=100 and t.l2>=100 and t.l3>=100)
        or(t.people>=100 and t.p2>=100 and t.l2>=100)