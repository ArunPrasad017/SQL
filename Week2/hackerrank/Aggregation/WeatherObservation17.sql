/*
Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7780. 
Round your answer to 4 decimal places.
*/

SELECT format(LONG_W,'N4')
from station where LAT_N = (select min(LAT_N) from station where LAT_N>38.7780)