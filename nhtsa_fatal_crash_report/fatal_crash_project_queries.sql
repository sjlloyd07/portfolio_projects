-- --:::::::::: IMPORT RAW DATA ::::::::::----

-- -- NHTSA

-- --** create new table to hold imported NHTSA/FARS accident data **----
-- CREATE TABLE nhtsa_accident_2019_raw (
-- 	state VARCHAR(255),
-- 	statename VARCHAR(255),
-- 	st_case VARCHAR(255),
-- 	ve_total VARCHAR(255),
-- 	ve_forms VARCHAR(255),
-- 	pvh_invl VARCHAR(255),
-- 	peds VARCHAR(255),
-- 	persons VARCHAR(255),
-- 	permvit VARCHAR(255),
-- 	pernotmvit VARCHAR(255),
-- 	county VARCHAR(255),
-- 	countyname VARCHAR(255),
-- 	city VARCHAR(255),
-- 	cityname VARCHAR(255),
-- 	day VARCHAR(255),
-- 	dayname VARCHAR(255),
-- 	month VARCHAR(255),
-- 	monthname VARCHAR(255),
-- 	year VARCHAR(255),
-- 	day_week VARCHAR(255),
-- 	day_weekname VARCHAR(255),
-- 	hour VARCHAR(255),
-- 	hourname VARCHAR(255),
-- 	minute VARCHAR(255),
-- 	minutename VARCHAR(255),
-- 	nhs VARCHAR(255),
-- 	nhsname VARCHAR(255),
-- 	route VARCHAR(255),
-- 	routename VARCHAR(255),
-- 	tway_id VARCHAR(255),
-- 	tway_id2 VARCHAR(255),
-- 	rur_urb VARCHAR(255),
-- 	rur_urbname VARCHAR(255),
-- 	func_sys VARCHAR(255),
-- 	func_sysname VARCHAR(255),
-- 	rd_owner VARCHAR(255),
-- 	rd_ownername VARCHAR(255),
-- 	milept VARCHAR(255),
-- 	mileptname VARCHAR(255),
-- 	latitude VARCHAR(255),
-- 	latitudename VARCHAR(255),
-- 	longitud VARCHAR(255),
-- 	longitudname VARCHAR(255),
-- 	sp_jur VARCHAR(255),
-- 	sp_jurname VARCHAR(255),
-- 	harm_ev VARCHAR(255),
-- 	harm_evname VARCHAR(255),
-- 	man_coll VARCHAR(255),
-- 	man_collname VARCHAR(255),
-- 	reljct1 VARCHAR(255),
-- 	reljct1name VARCHAR(255),
-- 	reljct2 VARCHAR(255),
-- 	reljct2name VARCHAR(255),
-- 	typ_int VARCHAR(255),
-- 	typ_intname VARCHAR(255),
-- 	wrk_zone VARCHAR(255),
-- 	wrk_zonename VARCHAR(255),
-- 	rel_road VARCHAR(255),
-- 	rel_roadname VARCHAR(255),
-- 	lgt_cond VARCHAR(255),
-- 	lgt_condname VARCHAR(255),
-- 	weather1 VARCHAR(255),
-- 	weather1name VARCHAR(255),
-- 	weather2 VARCHAR(255),
-- 	weather2name VARCHAR(255),
-- 	weather VARCHAR(255),
-- 	weathername VARCHAR(255),
-- 	sch_bus VARCHAR(255),
-- 	sch_busname VARCHAR(255),
-- 	rail VARCHAR(255),
-- 	railname VARCHAR(255),
-- 	not_hour VARCHAR(255),
-- 	not_hourname VARCHAR(255),
-- 	not_min VARCHAR(255),
-- 	not_minname VARCHAR(255),
-- 	arr_hour VARCHAR(255),
-- 	arr_hourname VARCHAR(255),
-- 	arr_min VARCHAR(255),
-- 	arr_minname VARCHAR(255),
-- 	hosp_hr VARCHAR(255),
-- 	hosp_hrname VARCHAR(255),
-- 	hosp_mn VARCHAR(255),
-- 	hosp_mnname VARCHAR(255),
-- 	cf1 VARCHAR(255),
-- 	cf1name VARCHAR(255),
-- 	cf2 VARCHAR(255),
-- 	cf2name VARCHAR(255),
-- 	cf3 VARCHAR(255),
-- 	cf3name VARCHAR(255),
-- 	fatals VARCHAR(255),
-- 	drunk_dr VARCHAR(255)
-- 	)


-- --** COPY CSV DATA TO TABLE (using psql) **----
-- \copy nhtsa_accident_2019_raw(STATE,STATENAME,ST_CASE,VE_TOTAL,VE_FORMS,PVH_INVL,PEDS,PERSONS,PERMVIT,PERNOTMVIT,COUNTY,COUNTYNAME,CITY,CITYNAME,DAY,DAYNAME,MONTH,MONTHNAME,YEAR,DAY_WEEK,DAY_WEEKNAME,HOUR,HOURNAME,MINUTE,MINUTENAME,NHS,NHSNAME,ROUTE,ROUTENAME,TWAY_ID,TWAY_ID2,RUR_URB,RUR_URBNAME,FUNC_SYS,FUNC_SYSNAME,RD_OWNER,RD_OWNERNAME,MILEPT,MILEPTNAME,LATITUDE,LATITUDENAME,LONGITUD,LONGITUDNAME,SP_JUR,SP_JURNAME,HARM_EV,HARM_EVNAME,MAN_COLL,MAN_COLLNAME,RELJCT1,RELJCT1NAME,RELJCT2,RELJCT2NAME,TYP_INT,TYP_INTNAME,WRK_ZONE,WRK_ZONENAME,REL_ROAD,REL_ROADNAME,LGT_COND,LGT_CONDNAME,WEATHER1,WEATHER1NAME,WEATHER2,WEATHER2NAME,WEATHER,WEATHERNAME,SCH_BUS,SCH_BUSNAME,RAIL,RAILNAME,NOT_HOUR,NOT_HOURNAME,NOT_MIN,NOT_MINNAME,ARR_HOUR,ARR_HOURNAME,ARR_MIN,ARR_MINNAME,HOSP_HR,HOSP_HRNAME,HOSP_MN,HOSP_MNNAME,CF1,CF1NAME,CF2,CF2NAME,CF3,CF3NAME,FATALS,DRUNK_DR) FROM 'C:/Users/steve/OneDrive/Desktop/NHTSA_raw/FARS2019NationalCSV/accident.csv' DELIMITER ',' CSV HEADER;


-- ** CREATE TEMP TABLE accident_temp FOR DATA TO CLEAN AND KEEP **----
-- CREATE TEMP TABLE accident_temp AS
-- 	SELECT
-- 		st_case::int AS id,
-- 		statename AS state,
-- 		countyname AS county,
-- 		year::int, 
-- 		month::int, 
-- 		day::int, 
-- 		hour::int,
-- 		day_weekname AS day_of_week,
-- 		rur_urbname AS rural_urban,
-- 		lgt_condname AS light_condition,
-- 		fatals::int AS fatalities
-- 	FROM nhtsa_accident_2019_raw



-- --:::::::::: CLEANING / MANIPULATION ::::::::::----

-- -- NHTSA ACCIDENT

-- --** UPDATE county column to county name w/o county id number -----
-- UPDATE accident_temp
-- SET county = substring(county FROM 1 FOR position('(' IN county)-2)

   
-- --** CHECK FOR DUPLICATE ROWS AND REMOVE
-- SELECT
-- 	COUNT(*) AS total_count,
-- 	COUNT(DISTINCT id) AS unique_id_count
-- FROM accident_temp
-- -- total count and count of uniqe id values match


-- --** CHECK FOR NULL VALUES
-- SELECT *
-- FROM accident_temp
-- WHERE id IS NULL OR state IS NULL OR county IS NULL IS NULL OR day IS NULL
-- 	OR month IS NULL OR year IS NULL OR hour IS NULL OR day_of_week IS NULL 
-- 	OR rural_urban IS NULL OR light_condition IS NULL OR fatalities IS NULL
-- -- no NULL values returned


-- --** REPLACE ALL CAPITALIZED STRINGS W/ UPPERCASE STRINGS 
-- UPDATE accident_temp
-- 	SET state = UPPER(state),
-- 	rural_urban = UPPER(rural_urban),
-- 	light_condition = UPPER(light_condition),
-- 	day_of_week = UPPER(day_of_week)


-- --** CHECK state COUNT
-- SELECT COUNT(DISTINCT state)  -- should be 51 (states + D.C.)
-- FROM accident_temp

-- --** CHECK state DISTINCT
-- SELECT DISTINCT state  -- should be 51 (states + D.C.)
-- FROM accident_temp
-- ORDER BY state

-- --** CHECK THAT DATE & TIME VALUES ARE VALID - CHANGE VALUES REPRESENTING UNKNOWN TO NULL
-- SELECT DISTINCT day
-- FROM accident_temp
-- ORDER BY day

-- SELECT DISTINCT month
-- FROM accident_temp
-- ORDER BY month

-- SELECT DISTINCT year
-- FROM accident_temp

-- SELECT DISTINCT day_of_week
-- FROM accident_temp

-- SELECT DISTINCT hour
-- FROM accident_temp
-- ORDER BY hour 
-- dataset value 99 represents unknown value, change to NULL 

-- UPDATE accident_temp
-- SET hour = NULL WHERE hour = 99


-- --** CHECK AND SIMPLIFY VALUES IN light_condition
-- SELECT DISTINCT light_condition
-- FROM accident_temp

-- -- combine column values NOT REPORTED, REPORTED AS UNKNOWN, and OTHER as value UNKNOWN
-- UPDATE accident_temp
-- SET light_condition = 'UNKNOWN'
-- 	WHERE light_condition NOT IN ('DAWN', 'DUSK', 'DAYLIGHT')
-- 		AND	light_condition NOT LIKE 'DARK%'

-- -- combine column values DARK-LIGHTED, DARK-NOT LIGHTED, DARK-UNKNOWN LIGHTING as value DARK
-- UPDATE accident_temp
-- SET light_condition = 'DARK'
-- 	WHERE light_condition LIKE 'DARK%'

  
-- --** CHECK AND SIMPLIFY VALUES IN rural_urban
-- SELECT DISTINCT rural_urban
-- FROM accident_temp

-- UPDATE accident_temp
-- SET rural_urban = 'UNKNOWN'
-- 	WHERE rural_urban NOT IN ('RURAL', 'URBAN')
-- -- combine column values that are not RURAL or URBAN as UNKNOWN


-- --** CONCATENATE day, month, year, hour TO NEW COLUMN TIME - TYPE TIMESTAMP
-- ALTER TABLE accident_temp
-- ADD COLUMN time timestamp

-- UPDATE accident_temp
-- SET time = make_timestamp(year, month, day, hour, 0, 0)
	
-- DROP NOW REDUNDANT COLUMN hour -keep day, month, and year because they do not have null values
-- ALTER TABLE accident_temp
-- DROP hour


-- --** CREATE NEW TABLE FOR FINAL DATASET AND INSERT DATA FROM accident_temp
-- DROP TABLE IF EXISTS accident_data_2019
-- CREATE TABLE accident_data_2019 AS
-- 	SELECT *
-- 	FROM accident_temp
-- 	ORDER BY id

-- ALTER TABLE accident_data_2019
-- ADD PRIMARY KEY(id)

-- SELECT *
-- FROM accident_data_2019
-- ORDER BY id
-- LIMIT 5





-- -- U.S. CENSUS

-- -- CREATE TABLE FOR RAW CENSUS DATA
-- CREATE TABLE census_raw (
-- 	geography VARCHAR(255),
-- 	geographic_area VARCHAR(255),
-- 	total INT
-- 	)

-- -- ALTER RAW DATA CSV TO ONLY HAVE FIRST 3 COLUMNS
-- -- USE psql TO COPY RAW DATA TO NEW TABLE
-- \copy census_raw(geography, geographic_area, total) FROM 'C:\Users\steve\portfolio_projects\fatal_crash_project_repo\census data\DECENNIALPL2020.P1-Data-V2.csv' DELIMITER ',' CSV HEADER;

-- SELECT *
-- FROM census_raw
-- LIMIT 5


-- -- CREATE TEMP TABLE TO ISOLATE DATA ELEMENTS geographic_area, state, AND total FROM census_raw TABLE
-- CREATE TEMP TABLE census_temp AS
-- 	SELECT 
-- 		geographic_area,
-- 		ltrim(split_part(geographic_area, ',', -1), ' ') AS state,
-- 		total
-- 	FROM census_raw

-- -- CHECK THAT ALL STATES PLUS D.C. ARE IN DATASET
-- SELECT COUNT(DISTINCT state)
-- FROM census_temp

-- SELECT DISTINCT state
-- FROM census_temp
-- ORDER BY state



-- -- CREATE FINAL TABLE WITH UPPERCASE STATE VALUES, SUMMING total DATA ELEMENT GROUPED BY STATE, AND EXCLUDING 'PUERTO RICO' FROM FINAL DATASET
-- CREATE TABLE state_pop AS
-- 	SELECT 
-- 		UPPER(state) AS state, 
-- 		SUM(total) AS population
-- 	FROM census_temp
-- 	WHERE state NOT ILIKE 'puerto rico'
-- 	GROUP BY state
-- 	ORDER BY state

-- SELECT *
-- FROM state_pop

