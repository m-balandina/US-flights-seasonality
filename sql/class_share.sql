-- Доля рейсов по классам перевозок
-- Считаю: количество рейсов
-- Делю на: общее кол-во рейсов
-- Сравниваю с: 100%

-- классы G и P имеют свою долю в перевозках, однако, т.к. мы ориентируемся на 
-- пассажирские рейсы, они участвовать не будут. Считалось это для обоснования включения
-- чартерных рейсов в расчёты. 

select f.CLASS, sum(f.DEPARTURES_PERFORMED) as class_flights, 
  round((sum(f.DEPARTURES_PERFORMED) * 100.0/ (select sum(f1.DEPARTURES_PERFORMED) from flights f1)),2) as percentage
from flights f
group by f.CLASS
