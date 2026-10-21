-- доля распределения пассажиров по городам в зависимости от сезона
-- считаем: кол-во пассажиров по сезонам и городам
-- делим на : общее количество пассажиров в сезон
-- сравниваем с : города с другими городами в зависимости от сезона
-- Города с пассажиропотоком до 173 тыс. входят в расчёт общего потока пассажиров по стране, 
-- но их доля в общем потоке меньше 0,005 п.п., поэтому в расчёт доли они не идут.

with cities as (
select f.DEST_CITY_NAME, sum(PASSENGERS) as quantity_pass, 
CASE 
	when f."MONTH" between 3 and 8 then 'Лето'
	else 'Зима'
END as season 
from flights f
where f.DEPARTURES_PERFORMED > 0
and f.CLASS in ('F', 'L')
group by season, f.DEST_CITY_NAME
ORDER by quantity_pass desc)
select DEST_CITY_NAME, quantity_pass, season,
ROUND((quantity_pass * 100.0 / season_all),2) as percentage
from (select DEST_CITY_NAME, quantity_pass, season, 
sum(quantity_pass) over (partition by season) as season_all from cities)
where quantity_pass > 174000
order by percentage desc
