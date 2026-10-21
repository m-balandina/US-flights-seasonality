INSERT INTO "select f.CLASS, sum(f.DEPARTURES_PERFORMED) as class_flights, 
round((sum(f.DEPARTURES_PERFORMED) * 100.0/ (select sum(f1.DEPARTURES_PERFORMED) 
from flights f1)),2) as percentage
from flights f
group by f.CLASS" (CLASS,class_flights,percentage) VALUES
	 ('F',24280100,91.94),
	 ('G',1357453.0,5.14),
	 ('L',483114.0,1.83),
	 ('P',289240.0,1.1);
