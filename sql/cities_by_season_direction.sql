-- У скольких городов растёт доля в какой сезон

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
ORDER by quantity_pass desc),
info as (
select DEST_CITY_NAME, quantity_pass, season,
ROUND((quantity_pass * 100.0 / season_all),2) as percentage
from (select DEST_CITY_NAME, quantity_pass, season, 
sum(quantity_pass) over (partition by season) as season_all from cities)
where quantity_pass > 174000
order by percentage desc)
select 
sum(case when difference > 0 then 1 else 0 end) as Зима,
sum(case when difference < 0 then 1 else 0 end) as Лето
from 
(select *,
((percentage - lead(percentage) over (partition by DEST_CITY_NAME
order by season))) as difference
from info
order by difference desc, season)
where difference is not null
