-- Разница долей принятия пассажиров городами по годам
-- считаю: разницу долей
-- сравниваю: сезоны 

with cities as (
select f.DEST_CITY_NAME, f."YEAR" as year_data, sum(PASSENGERS) as quantity_pass, 
case
	when f."MONTH" between 3 and 8 then 'Лето'
	else 'Зима'
end as season 
from flights f
where f.DEPARTURES_PERFORMED > 0
and f.CLASS in ('F', 'L')
group by season, f.DEST_CITY_NAME, f."YEAR"
order by quantity_pass desc),
pass as (
select DEST_CITY_NAME, year_data, quantity_pass, season,
ROUND((quantity_pass * 100.0 / season_all),2) as percentage
from (select DEST_CITY_NAME, year_data, quantity_pass, season, 
sum(quantity_pass) over (partition by season, year_data) as season_all from cities
where quantity_pass > 174000)
order by percentage desc),
season_pass as (
select DEST_CITY_NAME, year_data,
sum(case when season = 'Лето' then quantity_pass else 0 end) as pass_summer,
sum(case when season = 'Зима' then quantity_pass else 0 end) as pass_winter,
sum(case when season = 'Лето' then percentage else 0 end) as perc_summer,
sum(case when season = 'Зима' then percentage else 0 end) as perc_winter from pass
GROUP by DEST_CITY_NAME, year_data)
select DEST_CITY_NAME, max(difference_2023, difference_2024, difference_2025) - min(difference_2023, difference_2024, difference_2025) as difference
from (select DEST_CITY_NAME,
max((case when year_data = 2023 then abs(perc_winter - perc_summer) else 0 end)) as difference_2023,
max((case when year_data = 2024 then abs(perc_winter - perc_summer) else 0 end)) as difference_2024,
max((case when year_data = 2025 then abs(perc_winter - perc_summer) else 0 end)) as difference_2025
from season_pass
group by DEST_CITY_NAME
order by difference_2025 desc)
order by difference desc
