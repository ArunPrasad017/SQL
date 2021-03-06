/*
Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) 
and their respective average city populations (CITY.Population) rounded down to the nearest integer.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/

select ct.continent, avg(c.population)
from country ct
inner join city c
on c.CountryCode = ct.code
group by ct.continent