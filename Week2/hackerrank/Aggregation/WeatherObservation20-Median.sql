/*
Median
 A median is defined as a number separating the higher half of a data set from the lower half. 
 Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.
Two methods - 
    1. one by asc order and desc order -> we find the mid points where they both match up and derive the result 
    2. the second is by asc and total count value -> we return the points where the row_number when sorted by value is
        matching with (count+1/2 and count+2/2) (ex) for 500 inputs get the 250 and 251 rows matched
*/

--approach 1
with CTE as
(
    select LAT_N, row_number() over(order by LAT_N asc)LAT_A, 
    row_number() over (order by LAT_N desc)LAT_B
    from station
)
select format(avg(c.LAT_N),'N4')
from CTE c
where c.LAT_A in (c.LAT_B,C.LAT_B-1, c.LAT_B+1)

--approach 2
with cte as
(
    select LAT_N,
    c = count(*) over (),
    row_number() over(order by LAT_N)LAT_B
    from station
)
select format(avg(c.LAT_N),'N4')
from cte c
where c.LAT_B in ((c+1)/2, (c+2)/2)