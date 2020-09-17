/* Find the top 3 sectors in the United States by the average rank
Find the top 3 sectors in the United States by the average rank.
Output the average rank along with the sector name.
Order records based on the average rank in ascending order.*/

select sector,
avg(rank) as avg_rank
from forbes_global_2010_2014
-- where country= 'United States'
group by sector
order by avg_rank
limit 3;

/* 3. Find continents that have the highest number of companies.
Output the continents along with the corresponding number of companies.
Order results based on the number of companies in descending order.
*/
select continent,
count(company) as company_count
from forbes_global_2010_2014
group by continent
order by company_count desc;

-- we might have to add count distinct if we there are no distinct company IDs in the list

/*4. Find industries with the highest market value in Asia.
Output the industries along with the corresponding total market value.
Sort records based on the market value in descending order.
*/
select industry,
sum(marketvalue) as max_market_value
from forbes_global_2010_2014
where lower(continent) = 'asia'
group by industry
order by max_market_value desc;


/*5. Find industries with the highest number of companies.
Output the industry along with the number of companies.
Sort records based on the number of companies in descending order.
*/
select 
    industry,
    count(distinct company) as n_companies
    from forbes_global_2010_2014
    group by industry
    order by n_companies desc
limit 5;

/*6
Find the average profit for major banks.
*/
select
industry, avg(profits)
from forbes_global_2010_2014
where lower(industry) = 'major banks' 
group by industry;

/*7
Find the country that has the most companies listed on Forbes.  
Output the country along with the number of companies.
Order records based on the number of companies in descending order.
*/
select country, count(distinct company) n_companies
from forbes_global_2010_2014
group by country
order by n_companies desc
limit 1;

/*8
Find the most popular sector from the Forbes list based on the number of companies in each sector.
Output the sector along with the number of companies.
Sort records based on the number of companies in descending order
*/
select sector, count(distinct company) as n_companies
from forbes_global_2010_2014
group by sector
order by n_companies desc
limit 1;

/*9
Find the total market value for the financial sector.
*/
select sum(marketvalue) as financials_sector_mktval
from forbes_global_2010_2014
where lower(sector) = 'financials';
