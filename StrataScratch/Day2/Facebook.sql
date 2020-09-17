-- 3.
-- What is the overall friend acceptance rate by date?
-- Order by the latest friend request date to the earliest date
/* My answer:
select date,
sum(case when action='sent' then 1 else 0 end) as total_sent,
sum(case when action='accepted' then 1 else 0 end) as total_accepted,
sum(case when action='accepted' then 1 else 0 end)/sum(case when action='sent' then 1 else 0 end) as percentage_accepted
from fb_friend_requests
group by date
having total_accepted>0 and total_sent>0
order by date;
*/

-- Issues seen:
-- Corner case condition where the current number of requests received or sent if they cease to zero
-- we either get zero division error or zero number percentage

select a.date,
count(a.user_id_sender) as total_sent,
count(b.user_id_receiver) as total_received,
count(b.user_id_receiver)/cast(count(a.user_id_sender) as float) as percentage_acceptance
from
(select date, user_id_sender, user_id_receiver
from fb_friend_requests
where action ='sent'
)a
left join
(select date,user_id_sender,user_id_receiver 
from fb_friend_requests
where action='accepted'
)b
on a.user_id_sender = b.user_id_sender
group by a.date
order by a.date desc;


/* 4.
Find the average popularity of the Hack per office location
Facebook has developed a new programing language called Hack.To measure the popularity of Hack they ran a survey with their employees. 
The survey included data on previous programing familiarity as well as the number of years of experience, age, gender and most importantly satisfaction with Hack. Due to an error location data was not collected, 
but your supervisor demands a report showing average popularity of Hack by office location.
Luckily the user IDs of employees completing the surveys were stored.
Based on the above, find the average popularity of the Hack per office location.
Output the location along with the average popularity.
*/
-- my answer

select
f.location,
avg(fh.popularity) 
from facebook_employees f
inner join facebook_hack_survey fh
on f.id = fh.employee_id
group by f.location;

-- suggested
select
f.location,
avg(fh.popularity) 
from facebook_employees f
left outer join facebook_hack_survey fh
on f.id = fh.employee_id
group by f.location;

/* 5
Find the most common reaction for day 1 by counting the number of occurrences for each reaction.
Output the reaction alongside its number of occurrences.
Order the result based on the number of occurrences in descending order.
*/
select reaction,
count(*) as n_occurences
from facebook_reactions
where date_day = 1
group by reaction
order by n_occurences desc;

/* 6
Find the number of relationships that user 1 has been excluded from.
keyword - excluded from means that there are no occurences on the both columns for the
data we are looking for
*/
select 
sum(case when user1<>1 and user2<>1 then 1 else 0 end) as user1_not_in_relationship
from facebook_friends;

/*7 Find the number of views each post has.
Output the post id along with the number of views.
Order records by post id in ascending order.
*/
select post_id,
count(viewer_id)
from facebook_post_views
group by post_id
order by post_id asc;

/*8
Find the total number of interactions on days 0 and 2.
Output the result alongside the day.
*/
-- my answer
select day,
sum(user1+user2)
from facebook_user_interactions
where day in(0,2)
group by day;

-- actual answer
select day,
count(*)
from facebook_user_interactions
where day in(0,2)
group by day;