----:::::::::: IMPORT RAW DATA ::::::::::----

----** CREATE TABLE TO HOLD accident data **----

-- CREATE TABLE accident_raw_2019 (
-- 	state INT,
-- 	state_name VARCHAR(255),
-- 	st_case INT,
-- 	ve_total INT,
-- 	ve_forms INT,
-- 	pvh_invl INT,
-- 	peds INT,
-- 	persons INT,
-- 	permvit INT,
-- 	pernotmvit INT,
-- 	county INT,
-- 	county_name VARCHAR(255),
-- 	city INT,
-- 	city_name VARCHAR(255),
-- 	day INT,
-- 	day_name INT,
-- 	month INT,
-- 	month_name VARCHAR(255),
-- 	year INT,
-- 	day_of_week INT,
-- 	day_of_week_name VARCHAR(255),
-- 	hour INT,
-- 	hour_name VARCHAR(255),
-- 	minute INT,
-- 	minute_name INT,
-- 	nhs INT,
-- 	nhs_name VARCHAR(255),
-- 	route INT,
-- 	route_name VARCHAR(255),
-- 	tway_id VARCHAR(255),
-- 	tway_id2 VARCHAR(255),
-- 	rur_urb INT,
-- 	rur_urb_name VARCHAR(255),
-- 	func_sys INT,
-- 	func_sys_name VARCHAR(255),
-- 	rd_owner INT,
-- 	rd_owner_name VARCHAR(255),
-- 	mile_pt INT,
-- 	mile_pt_name VARCHAR(255),
-- 	latitude VARCHAR(255),
-- 	latitude_name VARCHAR(255),
-- 	longitude VARCHAR(255),
-- 	longitude_name VARCHAR(255),
-- 	sp_jur INT,
-- 	sp_jur_name VARCHAR(255),
-- 	harm_ev INT,
-- 	harm_ev_name VARCHAR(255),
-- 	man_coll INT,
-- 	man_coll_name VARCHAR(255),
-- 	reljct1 INT,
-- 	reljct1_name VARCHAR(255),
-- 	reljct2 INT,
-- 	reljct2_name VARCHAR(255),
-- 	typ_int INT,
-- 	typ_int_name VARCHAR(255),
-- 	wrk_zone INT,
-- 	wrk_zone_name VARCHAR(255),
-- 	rel_road INT,
-- 	rel_road_name VARCHAR(255),
-- 	lgt_cond INT,
-- 	lgt_cond_name VARCHAR(255),
-- 	weather1 INT,
-- 	weather1_name VARCHAR(255),
-- 	weather2 INT,
-- 	weather2_name VARCHAR(255),
-- 	weather INT,
-- 	weather_name VARCHAR(255),
-- 	sch_bus INT,
-- 	sch_bus_name VARCHAR(255),
-- 	rail INT,
-- 	rail_name VARCHAR(255),
-- 	not_hour INT,
-- 	not_hour_name VARCHAR(255),
-- 	not_min INT,
-- 	not_min_name VARCHAR(255),
-- 	arr_hour INT,
-- 	arr_hour_name VARCHAR(255),
-- 	arr_min INT,
-- 	arr_min_name VARCHAR(255),
-- 	hosp_hr INT,
-- 	hosp_hr_name VARCHAR(255),
-- 	hosp_mn INT,
-- 	hosp_mn_name VARCHAR(255),
-- 	cf1 INT,
-- 	cf1_name VARCHAR(255),
-- 	cf2 INT,
-- 	cf2_name VARCHAR(255),
-- 	cf3 INT,
-- 	cf3_name VARCHAR(255),
-- 	fatals INT,
-- 	drunk_dr INT
-- );

----** LIST TABLE COLUMN NAMES **----
-- SELECT column_name 
-- FROM information_schema.columns 
-- WHERE table_name = 'accident_raw_2019' 
-- ORDER BY ordinal_position;

----** COPY CSV DATA TO TABLE (using psql) **----
-- \copy accident_raw_2019(state,state_name,st_case,ve_total,ve_forms,pvh_invl,peds,persons,permvit,pernotmvit,county,county_name,city,city_name,day,day_name,month,month_name,year,day_of_week,day_of_week_name,hour,hour_name,minute,minute_name,nhs,nhs_name,route,route_name,tway_id,tway_id2,rur_urb,rur_urb_name,func_sys,func_sys_name,rd_owner,rd_owner_name,mile_pt,mile_pt_name,latitude,latitude_name,longitude,longitude_name,sp_jur,sp_jur_name,harm_ev,harm_ev_name,man_coll,man_coll_name,reljct1,reljct1_name,reljct2,reljct2_name,typ_int,typ_int_name,wrk_zone,wrk_zone_name,rel_road,rel_road_name,lgt_cond,lgt_cond_name,weather1,weather1_name,weather2,weather2_name,weather,weather_name,sch_bus,sch_bus_name,rail,rail_name,not_hour,not_hour_name,not_min,not_min_name,arr_hour,arr_hour_name,arr_min,arr_min_name,hosp_hr,hosp_hr_name,hosp_mn,hosp_mn_name,cf1,cf1_name,cf2,cf2_name,cf3,cf3_name,fatals,drunk_dr) FROM 'C:/Users/steve/OneDrive/Desktop/NHTSA_raw/FARS2019NationalCSV/accident.csv' DELIMITER ',' CSV HEADER;

----** UPDATE COLUMN TYPE CHAR LENGTH **----
-- ALTER TABLE accident_raw_2019 
-- ALTER COLUMN harm_ev_name TYPE VARCHAR(255);


----** BEGIN DATA TABLE *NORMALIZATION BY EXTRACTING VALUES INTO NEW TABLES **---- --unneccessary for this analysis

----** STATE **----
-- CREATE TABLE state (
-- 	id SERIAL,
-- 	state_id INT,
-- 	name VARCHAR(56),
-- 	PRIMARY KEY(id)
-- );

-- INSERT INTO state(state_id, name) 
-- SELECT 
-- 	state,
-- 	state_name
-- FROM accident_raw_2019
-- GROUP BY state, state_name
-- ORDER BY state;

-- ALTER TABLE state
-- ADD PRIMARY KEY(state_id);

----** COUNTY **----
-- CREATE TABLE county (
-- 	id SERIAL PRIMARY KEY,
-- 	state_id INT,
-- 	name VARCHAR(56)
-- );

-- INSERT INTO county(state_id, name)
-- SELECT
-- 	DISTINCT state, county_name
-- FROM accident_raw_2019 
-- ORDER  BY state, county_name;

----** ROUTE **----
-- CREATE TABLE route (
-- 	route_id INT PRIMARY KEY,
-- 	route_type VARCHAR(56)
-- );

-- INSERT INTO route(route_id, route_type)
-- 	SELECT route, route_name
-- 	FROM accident_raw_2019
-- 	GROUP BY route, route_name
-- 	ORDER BY route;

----** RURAL URBAN **----
-- CREATE TABLE rural_urban (
-- 	rural_urban_id INT PRIMARY KEY,
-- 	category VARCHAR(56)
-- );

-- INSERT INTO rural_urban(rural_urban_id, category)
-- 	SELECT DISTINCT rur_urb, rur_urb_name
-- 	FROM accident_raw_2019
-- 	ORDER BY rur_urb;

----** HARMEV **----
-- CREATE TABLE harmful_event (
-- 	id INT PRIMARY KEY,
-- 	description VARCHAR(150)
-- );

-- INSERT INTO harmful_event(id, description)
-- 	SELECT DISTINCT harm_ev, harm_ev_name
-- 	FROM accident_raw_2019
-- 	ORDER BY harm_ev;

----** MANCOLL **----
-- CREATE TABLE collision_type (
-- 	id INT PRIMARY KEY,
-- 	description VARCHAR(128)
-- );

-- INSERT INTO collision_type(id, description)
-- 	SELECT DISTINCT man_coll, man_coll_name
-- 	FROM accident_raw_2019
-- 	ORDER BY man_coll;

----** LGT COND **----
-- CREATE TABLE light_condition (
-- 	id INT PRIMARY KEY,
-- 	condition VARCHAR(56)
-- 	);

-- INSERT INTO light_condition(id, condition)
-- 	SELECT DISTINCT lgt_cond, lgt_cond_name
-- 	FROM accident_raw_2019
-- 	ORDER BY lgt_cond;

----** WEATHER **----
-- CREATE TABLE weather (
-- 	id INT PRIMARY KEY,
-- 	description VARCHAR(56)
-- 	);

-- INSERT INTO weather(id, description)
-- 	SELECT DISTINCT weather, weather_name
-- 	FROM accident_raw_2019
-- 	ORDER BY weather;

-- SELECT 
-- 	st_case,
-- 	COUNT(st_case)
-- FROM accident_raw_2019
-- GROUP BY st_case
-- ORDER BY COUNT DESC;


----** ABANDONED DB BUILD - CREATE TABLE accident **----

-- CREATE TABLE accident (
-- 	id INT PRIMARY KEY,
-- 	state VARCHAR(56),
-- 	county VARCHAR(56),
-- 	route VARCHAR(56),
-- 	trafficway_name VARCHAR(56),
-- 	rural_urban VARCHAR(56),
-- 	harmful_event VARCHAR(256),
-- 	collision_type VARCHAR(128),
-- 	light_conditon VARCHAR(56),
-- 	weather VARCHAR(56),
-- 	date DATE,
-- 	day_of_week VARCHAR(28),
-- 	hour TIMESTAMP,
-- 	fatals INT
-- 	);
	
-- ALTER TABLE accident  --must cast w/ USING when changing datatype form timestamp w/o tz
-- ALTER COLUMN hour TYPE INT
-- USING CAST(EXTRACT('hour' FROM hour) AS integer);


----** INSERT accident_raw_2019 COLUMNS INTO accident **----
---- rename columns for legibility

-- INSERT INTO accident(id, state, county, route, trafficway_name, rural_urban, harmful_event,
-- 					collision_type, light_condition, weather, date, day_of_week, hour, fatals)
-- SELECT
-- 	st_case,  		--> id (primary key)
-- 	state_name,		--> state
-- 	county_name,	--> county
-- 	route_name,		--> route
-- 	tway_id,		--> trafficway_name
-- 	rur_urb_name,	--> rural_urban
-- 	harm_ev_name,	--> harmful_event
-- 	man_coll_name,	--> collision_type
-- 	lgt_cond_name,	--> light_condition
-- 	weather_name,	--> weather
-- 	to_date(to_char(year, '9999')||to_char(day, '09')||to_char(month, '09'), 'YYYY DD MM'),	--> concatenate year, month, day
-- 	to_char(to_date(day_of_week::text, 'DD'), 'Day'),	--> weekday number to weekday text
-- 	hour,
-- 	fatals
-- FROM accident_raw_2019;;

---- rename accident table for conciseness
-- ALTER TABLE accident
-- RENAME TO accident_clean

--ALTER TABLE accident_clean
-- RENAME route TO roadway_type;

-- ALTER TABLE accident_clean
-- RENAME trafficway_name TO roadway_name;

----:::::::::: CLEANING / MANIPULATION ::::::::::----

----** UPDATE county column to county name w/ county id number removed 

-- UPDATE accident 
-- SET county = substring(county FROM 1 FOR position('(' IN county)-2)


----** CHECK FOR DUPLICATE ROWS AND REMOVE - no duplicate rows found

-- WITH accident_cte AS (
-- 	SELECT *,
-- 		ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
-- 	FROM accident_clean
-- 	)
-- SELECT *
-- FROM accident_cte
-- WHERE row_num > 1;

----** CHECK FOR DUPLICATE IDs (because they're natural, not surrogate) AND REMOVE - no duplicates found

-- SELECT COUNT(DISTINCT id), COUNT(id)
-- FROM accident_clean


----** CHECK FOR NULL VALUES - no NULL values returned

-- SELECT *
-- FROM accident_clean
-- WHERE id IS NULL OR state IS NULL OR county IS NULL OR route IS NULL OR trafficway_name IS NULL 
-- 	OR rural_urban IS NULL OR harmful_event IS NULL OR collision_type IS NULL OR light_condition IS NULL
-- 	OR weather IS NULL OR date IS NULL OR day_of_week IS NULL OR hour IS NULL OR fatals IS NULL

----** REPLACE ALL CAPITALIZED STRINGS W/ UPPERCASE STRINGS 

-- UPDATE accident_clean
-- 	SET state = UPPER(state)
-- 	roadway_type = UPPER(roadway_type),
-- 	rural_urban = UPPER(rural_urban),
-- 	harmful_event = UPPER(harmful_event),
-- 	collision_type = UPPER(collision_type),
-- 	light_condition = UPPER(light_condition),
-- 	weather = UPPER(weather),
-- 	 day_of_week = UPPER(day_of_week)
-- ;

----** CHECK state COLUMN AND COUNT

-- SELECT DISTINCT state
-- FROM accident_clean;

-- SELECT COUNT(DISTINCT state)
-- FROM accident_clean;

----** CHECK THAT date COLUMN VALUES ARE VALID (all 2019)

-- SELECT *
-- FROM accident_clean
-- WHERE date NOT BETWEEN '2019-01-01'::date AND '12-31-2019'::date

----** CHECK THAT hour VALUES ARE B/T 0 AND 23 (inclusive) REPRESENTING A 24H CLOCK
		---- REPLACE VALUE 99 w/ 9999 FOR ADDITIONAL CLARITY WHILE KEEPING INTEGER
	
-- SELECT DISTINCT(hour)
-- FROM accident_clean
-- ORDER BY hour

-- UPDATE accident_clean
-- SET hour = 9999 WHERE hour = 99


-- DROP TABLE county, harmful_event, light_condition, route, rural_urban, state, weather



----:::::::::: ANALYSIS ::::::::::----

------ ACCIDENT RECORDS - TOTAL
-- SELECT COUNT(*)
-- FROM accident_clean

------ ACCIDENT RECORDS - TOTAL ACCIDENTS/FATALITIES PER STATE (TOP 10 FATAL DESC)
-- SELECT 
-- 	state, 
-- 	COUNT(*) AS total_accidents,
-- 	SUM(fatals) AS total_fatalities
-- FROM accident_clean
-- GROUP BY state
-- ORDER BY total_fatalities DESC
-- LIMIT 10;

------ ACCIDENT RECORDS - TOTAL ACCIDENTS/FATALITIES PER STATE (BOTTOM 10)
-- SELECT 
-- 	state, 
-- 	COUNT(*) AS total_accidents,
-- 	SUM(fatals) AS total_fatalities
-- FROM accident_clean
-- GROUP BY state
-- ORDER BY total_fatalities
-- LIMIT 10;

------ ACCIDENTS PER MONTH BY STATE IN 2019
-- SELECT
-- 	state,
-- 	EXTRACT('month' FROM date) AS month,
-- 	SUM(fatals) AS total	
-- FROM accident_clean
-- GROUP BY state, month
-- ORDER BY state, month
	
------ NATIONAL AVG DEADLY ACCIDENTS PER DAY IN 2019
-- SELECT COUNT(*) / 365 AS avg_per_day
-- FROM accident_clean

------ MOST DEADLY PIECE OF ROAD IN EVERY STATE
-- WITH death_count AS (
-- 	SELECT
-- 		state,
-- 		county,
-- 		roadway_name,
-- 		SUM(fatals) AS deaths
-- 	FROM accident_clean
-- 	GROUP BY state, county, roadway_name
-- 	ORDER BY state, SUM(fatals) DESC 
-- 	)
-- 	, death_count_ranked AS (
-- 	SELECT
-- 		state,
-- 		county, 
-- 		roadway_name,
-- 		deaths,
-- 		ROW_NUMBER() OVER (PARTITION BY state ORDER BY deaths DESC) AS rn
-- 	FROM death_count
-- 	)
	
-- SELECT state, county, roadway_name, deaths
-- FROM death_count_ranked
-- WHERE rn = 1
-- ORDER BY deaths DESC

------ DEATHS BY HARMFUL EVENT (description of primary cause of accident)
-- SELECT
-- 	harmful_event,
-- 	SUM(fatals) AS deaths
-- FROM accident_clean
-- GROUP BY harmful_event
-- ORDER BY deaths DESC

------ DEATHS BY LIGHT CONDITION
-- SELECT
-- 	light_condition,
-- 	SUM(fatals)
-- FROM accident_clean
-- GROUP BY 
-- 	light_condition 
-- ORDER BY sum DESC

------ DEATHS BY WEATHER CONDITION
-- SELECT	
-- 	weather,
-- 	SUM(fatals)
-- FROM accident_clean
-- GROUP BY weather
-- ORDER BY sum DESC

------ DEATHS BY DAY OF WEEK & PERCENT TOTAL
-- WITH day_cte AS (
-- 	SELECT
-- 		day_of_week,
-- 		SUM(fatals) AS deaths	
-- 	FROM accident_clean
-- 	GROUP BY day_of_week
-- 	ORDER BY deaths DESC
-- 	)
-- SELECT
-- 	day_of_week,
-- 	deaths,
-- 	trunc((deaths/SUM(deaths) OVER())*100,1) AS percent_total
-- FROM day_cte


------ DEATHS BY DAY OF WEEK AND HOUR
-- SELECT
-- 	day_of_week,
-- 	(CASE
-- 		WHEN hour > 23
-- 	 	THEN 'UNKNOWN'
-- 	 ELSE to_char(make_time(hour, 0, 0), 'HH12:MM AM')
-- 	 END) AS hour_of_accident,
-- 	SUM(fatals) AS deaths
-- FROM accident_clean
-- GROUP BY hour, day_of_week
-- ORDER BY deaths DESC



	 

-- SELECT *
-- FROM accident_clean
-- ORDER BY hour DESC
-- LIMIT 10;
