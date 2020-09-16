/*The Numbers table keeps the value of number and its frequency.

+----------+-------------+
|  Number  |  Frequency  |
+----------+-------------|
|  0       |  7          |
|  1       |  1          |
|  2       |  3          |
|  3       |  1          |
+----------+-------------+
In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

+--------+
| median |
+--------|
| 0.0000 |
+--------+
Write a query to find the median of all numbers and name the result as median.
*/

/* Write your T-SQL query statement below */
select cast(t.Number as float)
from
(select Number, Frequency, 
sum(Frequency) over(order by number) as rolling_freq,
sum(Frequency) over() as total_sum
from Numbers)t
where t.total_sum/2.0 between t.rolling_freq-frequency and t.frequency