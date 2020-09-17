/*
1. Find all users that have more than 3 friends. 
*/
select user_id
from google_friends_network
group by user_id
having count(distinct friend_id)>3;

/*2
Find the minimal adwords earnings for each business type.
Output the business type along with the minimal earning.
*/
select business_type,
min(adwords_earnings)
from google_adwords_earnings
group by business_type;

/*3
Find the winning teams of DeepMind employment competition.
Output the team along with the average team score.
Sort records by the team score in descending order.
*/
select
cp.team, avg(score)
from google_competition_participants cp
left join google_competition_scores cs
on cp.id = cs.id
group by cp.team
order by avg(score) desc
;