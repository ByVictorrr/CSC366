-- Lab 1: SQL Refresher
-- vdelapla
-- Sep 19, 2020

USE `BIKES`;
-- BIKES-1
-- List each city and the number of stations in that city.  Sort by number of stations (highest to lowest), then by city name (A-Z).
SELECT station.city, COUNT(station.station_id)
FROM station
GROUP By station.city
ORDER BY COUNT(station.station_id) DESC;


USE `BIKES`;
-- BIKES-2
-- Find all stations with a name that contains the name of the city in which the station resides. List city name and station name. Sort by city, then station name. For example, the station "San Jose Civic Center" contains "San Jose"
select city, station_name from station
where LOCATE(city,station_name) != 0
ORDER BY city, station_name;


USE `BIKES`;
-- BIKES-3
-- Find the percentage of self-loops among all trips. A "self-loop" is defined as a trip that starts and ends at the same station. Print the percentage of self-loop trips, rounded to 2 decimal places.
WITH ST_Trips AS (
    SELECT COUNT(*) AS ST
    FROM trip
    WHERE start_station_name = end_station_name
),Tot_Trips AS (
    SELECT COUNT(*) AS TT
    FROM trip
)

SELECT ROUND((ST/TT)*100, 2)
FROM ST_Trips, Tot_Trips;


USE `BIKES`;
-- BIKES-4
-- Find all trips that ended in a different city than the trip begin. List trip ID, start city, end city, and trip length in hours (rounded to 3 decimal places).  Sort by trip length in hours, shortest to longest. In case of ties, sort by start city.
/*SELECT id, start_city, end_city, hours*/
WITH end_trip AS(
	SELECT t.id, s.city, t.end_station_id AS station_id, t.end_time
	FROM trip t, station s
	WHERE t.end_station_id = s.station_id
),start_trip AS(
	SELECT t.id, s.city, t.end_station_id AS station_id, t.start_time
	FROM trip t, station s
	WHERE t.start_station_id = s.station_id
)
SELECT st.id, st.city, et.city, ROUND(TIME_TO_SEC(TIMEDIFF(end_time, start_time))/3600,3) as hours
FROM end_trip et, start_trip st
WHERE et.id = st.id AND et.city != st.city
ORDER BY hours, st.city;


USE `BIKES`;
-- BIKES-5
-- Find the ID of bike(s) that have been to the greatest number of *different* stations (as either the start or end station)  List bike ID and the number of different stations.
WITH bike_station_id AS(
    SELECT t.bike_id, t.station_id
    FROM (
        SELECT bike_id, start_station_id as station_id FROM trip  
            UNION 
        SELECT bike_id, end_station_id as station_id FROM trip
        ) as t
),
bike_id_count AS(
SELECT bsi.bike_id, COUNT(*) as num_stations
FROM bike_station_id bsi
GROUP BY bike_id
)

SELECT bike_id, num_stations
FROM bike_id_count 
WHERE num_stations >= ALL (
    SELECT num_stations
    FROM bike_id_count
);


USE `BIKES`;
-- BIKES-6
-- Find bikes that have been to *all* stations in Redwood City (as either the start or end station). List bike IDs in ascending order.
WITH bike_id_stations AS(
    SELECT t.bike_id, COUNT(t.station_id) as stations
    FROM (
        SELECT bike_id, start_station_id as station_id FROM trip  
            UNION 
        SELECT bike_id, end_station_id as station_id FROM trip
        ) as t, station s
    WHERE t.station_id = s.station_id AND s.city = "Redwood City"
	GROUP BY t.bike_id
)

SELECT bike_id
FROM bike_id_stations b
WHERE b.stations IN (
	SELECT COUNT(*)
	FROM station
	WHERE city = "Redwood City"
)
ORDER BY bike_id;


USE `BIKES`;
-- BIKES-7
-- For each city, find the least popular station(s) considering both trip start and trip end. Determine popularity based on trip count. Any trips that start and end at the same station should count only once. List city name, station name and visit count, sorted alphabetically by city, then station.
/* UNION will remove duplicates */

WITH id_station AS(
    SELECT tis.station_id, city, COUNT(*) as trips
    FROM 
        (
		SELECT id, start_station_id as station_id, start_station_name as station_name
		FROM trip t
            UNION
		SELECT id, end_station_id as station_id, end_station_name as station_name
		FROM trip t
        ) AS tis, station s
	WHERE tis.station_id = s.station_id
	GROUP BY station_id, city
)

SELECT o.city, station_name, trips
FROM id_station o, station s
WHERE o.trips <= ALL (
    SELECT i.trips
    FROM id_station i
    WHERE i.city = o.city
) AND s.station_id = o.station_id
ORDER BY o.city, station_name, trips;


USE `BIKES`;
-- BIKES-8
-- Usually, but not always, if a bike ends its trip at station A, its next trip starts at station A.  Occasionally, a truck collects some bikes from station A, and moves them to station B to satisfy the higher demand there. Find all instances of non-trip movement of bike with ID 366.
SELECT e.id, end_time, end_station_name, s.id, start_time, start_station_name 
FROM 
	
	(SELECT id, end_station_id, end_station_name, end_time,  ROW_NUMBER() OVER() AS row_num FROM trip WHERE bike_id = 366 ORDER BY id) e,
	(SELECT id, start_station_id, start_station_name, start_time, ROW_NUMBER() OVER() AS row_num FROM trip WHERE bike_id = 366 ORDER BY id) s

WHERE e.row_num+1 = s.row_num AND e.end_station_id <> s.start_station_id;


USE `BIKES`;
-- BIKES-9
-- Compute a running total duration (in minutes) for each trip by bike with ID 555. For each trip, print end time, trip duration, and accumulated duration, sorted by trip end time.
select end_time, 
TIME_TO_SEC(TIMEDIFF(end_time, start_time))/60 as hours,
SUM(TIME_TO_SEC(TIMEDIFF(end_time, start_time))/60) OVER(ROWS UNBOUNDED PRECEDING) as rtot
from trip
where bike_id = 555
order by end_time;


USE `BIKES`;
-- BIKES-10
-- Find all cases where the database indicates that the same bike was used for two trips that overlap in time. You may assume that, for every trip, the start time precedes the end time. Print the bike id, former trip id, former start time, former end time, latter trip id, latter start time, latter end time.
SELECT t1.bike_id, t1.id, t1.start_time, t1.end_time, t2.id, t2.start_time, t2.end_time
FROM trip t1, trip t2
WHERE t1.start_time < t2.end_time AND t1.end_time > t2.start_time and t1.id < t2.id AND t1.bike_id = t2.bike_id
ORDER BY t1.bike_id;


USE `BIKES`;
-- BIKES-11
-- Formulate a new information request (different from those above) that you would consider to be "easy" in difficulty. Provide (a) an English-language information request as a SQL comment and (b) a valid SQL query that produces the requested result.
--;


USE `BIKES`;
-- BIKES-12
-- Formulate a new information request that you would consider to be "medium" difficulty. Provide (a) an English-language information request as a SQL comment and (b) a valid SQL query that produces the requested result.
(a) On 2013-09-11, what is the station_name, max_temp, mean_temp, min_temp at the any stations that have been visited on that day?

(b)
WITH id_station AS(
    SELECT s.station_id, s.station_name, time, zip_code
    FROM 
    (SELECT start_station_id as station_id, start_station_name as station_name, start_time as time FROM trip
    UNION 
    SELECT end_station_id as station_id, end_station_name as station_name, end_time as time FROM trip
    ) as st, station s
    WHERE st.station_id = s.station_id
)

SELECT DISTINCT station_name, max_temp, mean_temp, min_temp
FROM weather we, id_station s
WHERE  cast(time as Date) = CAST('2013-09-11' as date) AND we.date = cast(time as Date) AND we.zip_code = s.zip_code;


USE `BIKES`;
-- BIKES-13
-- Formulate a new information request that you would consider to be difficult. Provide (a) an English-language information request as a SQL comment and (b) a valid SQL query that produces the requested result.
(a) Assume that the absolute value between zip_codes is a unit of distance called zip's or zipage. So the next city or town should have incrmenting/decrementing values of the current zip code. If this is case the zipage would be 1. Print the total zipage each bike has over 0 zipage. Sort by bike_id (ascending)

(b)
WITH trip_zipage AS(
	SELECT t.id, t.bike_id, ABS(s1.zip_code - s2.zip_code) AS zipage
	FROM station s1, station s2, trip t
	Where t.start_station_id = s1.station_id AND t.end_station_id = s2.station_id
)

SELECT bike_id, SUM(zipage) as zipages
FROM trip_zipage 
GROUP BY bike_id
HAVING SUM(zipage) > 0
ORDER BY bike_id;


USE `BIKES`;
-- BIKES-14
-- Provide an information request that is unreasonably difficult (or impossible) to translate to a SQL query due to the current database structure, but would be readily solvable with a simple and compact SQL query if the database schema were to be altered.  Provide, as SQL comments, your information request and a brief description of the database changes that would be necessary.
Its impossible to see if a station on a given day is rainy and foggy at the same time (at least I dont see it in the table; it could be though) so making two sererate columns for events.;


