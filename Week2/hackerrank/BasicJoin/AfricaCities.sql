/*
Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) 
and their respective average city populations (CITY.Population) rounded down to the nearest integer.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/

select c.name
from city c
inner join country ct
on c.CountryCode = ct.Code
where lower(ct.CONTINENT) = 'africa'