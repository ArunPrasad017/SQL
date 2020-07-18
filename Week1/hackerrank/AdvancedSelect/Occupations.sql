/*
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. 
The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation.
Pivoting without pivot 

Output:
Jenny    Ashley     Meera  Jane
Samantha Christeen  Priya  Julia
NULL     Ketty      NULL   Maria

*/

SELECT a.name,
         b.name,
        c.name,
        d.name
FROM 
    (SELECT row_number() over(order by o1.name)rnk,
         o1.name AS name
    FROM occupations o1
    WHERE lower(o1.occupation)='doctor')a full outer
JOIN 
    (SELECT row_number() over(order by o2.name)rnk,
         o2.name AS name
    FROM occupations o2
    WHERE lower(o2.occupation)='professor')b
    ON a.rnk = b.rnk full outer
JOIN 
    (SELECT row_number() over(order by o3.name)rnk,
         o3.name AS name
    FROM occupations o3
    WHERE lower(o3.occupation)='singer')c
    ON isnull(a.rnk,b.rnk) = c.rnk full outer
JOIN 
    (SELECT row_number() over(order by o4.name)rnk,
         o4.name AS name
    FROM occupations o4
    WHERE lower(o4.occupation)='actor')d
    ON isnull(b.rnk,c.rnk) = d.rnk