/*
Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33
*/

-- # solution1
select 
round(cast(sum(case when datediff(day,lead_date,event_date)=-1 and rnk=1 then 1 else 0 end) as float)/count(distinct player_id),2) as fraction
from
(
    select
    player_id, 
    device_id,
    event_date,
    lead(event_date,1) over(partition by player_id order by event_date) as lead_date,
    row_number() over(partition by player_id order by event_date) as rnk
    from activity
)t

-- # solution2
select 
round(cast(sum(case when datediff(day,first_login,event_date)=1 then 1 else 0 end) as float)/count(distinct player_id),2) as fraction
from
(    
    select
    player_id, 
    device_id,
    event_date,
    first_value(event_date) over(partition by player_id order by event_date) as first_login
    from activity
)t