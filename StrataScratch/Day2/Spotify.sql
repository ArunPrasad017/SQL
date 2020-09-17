/*
1. Find artists that have been on Spotify the most number of times.
Output the artist name along with the corresponding number of occurrences.
Order records by the number of occurrences in descending order.
*/
select artist,count(*) as played_times
from spotify_worldwide_daily_song_ranking
group by 1
order by 2 desc
;

/*
2. Find songs that have placed in the top position the most number of times.
Output the track name along with the number of times it ranked as the top.
Sort records by the number of top positions in descending order.
*/
select trackname,
count(position) as times_top1
from spotify_worldwide_daily_song_ranking
where position = 1
group by trackname
order by times_top1 desc;

/*3.
Find artists with the highest number of top 10 ranked songs over the years.
Output the artist along with the corresponding number of top 10 rankings.
Sort records by the number of top 10 ranks in descending order.
*/
select artist,
count(position) as no_top10
from spotify_worldwide_daily_song_ranking
where position<=10
group by artist
order by no_top10 desc;

/*4
Find the highest number of streams in the dataset.
*/
select max(streams) from spotify_worldwide_daily_song_ranking;