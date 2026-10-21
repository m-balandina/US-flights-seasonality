-- Доля пассажиров перевезённых по сезонам.
-- Считаю: пассажиров по сезону
-- Делю на: общее кол-во пассажиров
-- Сравниваю с: 100%

with all_pass as (
select sum(f1.PASSENGERS) as pass_quan from flights f1
where f1.DEPARTURES_PERFORMED > 0
and f1.CLASS in ('F', 'L'))
select
CASE 
	when f."MONTH" between 3 and 8 then 'Лето'
	else 'Зима'
END as season, 
round((sum(f.PASSENGERS)*100.0 / pass_quan),2) as percentage
from flights f
cross join all_pass
where f.DEPARTURES_PERFORMED > 0 and f.CLASS in ('F', 'L')
group by season 
