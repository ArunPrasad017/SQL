/* 
Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780.
Round your answer to  decimal places.
*/
SELECT format(min(LAT_N),'N4')
from STATION
where LAT_N >38.7780