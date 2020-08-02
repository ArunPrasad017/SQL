select score, dense_rank() over(order by score desc)Rank
from scores
