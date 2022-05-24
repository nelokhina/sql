--- 1. В каких городах больше одного аэропорта?

select city, count(airport_name)  
from airports a 
group by city
having count(airport_name) > 1;

--- 2. В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?

select distinct f.departure_airport, a.aircraft_code, a."range" 
from(
	select aircraft_code, max ("range")
	from aircrafts a
	group by aircraft_code
	order by ("range") desc 
	limit 1) t 
join aircrafts a on a.aircraft_code = t.aircraft_code
join flights f on f.aircraft_code  = a.aircraft_code 
order by departure_airport


--- 3. Вывести 10 рейсов с максимальным временем задержки вылета

select flight_id, (actual_departure - scheduled_departure) as delta
from flights
WHERE actual_departure IS NOT null
order by delta desc
limit 10


--- 4. Были ли брони, по которым не были получены посадочные талоны?
select t.ticket_no, t.book_ref, t.passenger_id, boarding_no, seat_no 
from boarding_passes bp 
right join tickets t on t.ticket_no = bp.ticket_no 
where boarding_no is null

--- 5. Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
--- Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных пассажиров из 
--- каждого аэропорта на каждый день. Т.е. в этом столбце должна отражаться накопительная сумма - 
--- сколько человек уже вылетело из данного аэропорта на этом или более ранних рейсах за день.


select bp.flight_id, count(bp.seat_no), s.aircraft_code, count(seat_no)
from (
	select count(seat_no), aircraft_code 
	from seats s
	group by aircraft_code) as s,
	select bp.flight_id, count(bp.seat_no)
	from boarding_passes bp) a
    from flights f 



select count(seat_no), aircraft_code 
from seats s
group by aircraft_code 



--- 6. Найдите процентное соотношение перелетов по типам самолетов от общего количества.

select aircraft_code, 
round(count(flight_id)*100./(select sum(flight_id) from flights f), 5) 
from flights f 
group by aircraft_code

-- 7. Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?
-- город перелет класс и цена
 

select distinct tf.flight_id, tf.fare_conditions, tf.amount, a.city 
from ticket_flights tf
join flights f on f.flight_id = tf.flight_id 
join airports a on a.airport_code = f.arrival_airport 
--where tf.flight_id = 137
order by flight_id 
