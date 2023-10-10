# NHTSA Accident Data
***
# 📋 Preparation

After the NHTSA `accident.csv` file was downloaded to local storage, Microsoft Excel was utilized to view the `accident.csv` data and isolate the column headers in order to retain them as column names in the newly created raw data table. At this point, table `nhtsa_accident_2019_raw` [was created](/fatal_crash_project/queries.sql#L6). A newly created local PostgreSQL database served to house this and all future project data tables.

* The raw data was copied to the `nhtsa_accident_2019_raw` table from the `accident.csv` file using the `psql` client copy command: `\copy`. 

  ```sql
    \copy nhtsa_accident_2019_raw(STATE,STATENAME,ST_CASE,VE_TOTAL,VE_FORMS,PVH_INVL,PEDS,PERSONS,PERMVIT,PERNOTMVIT,COUNTY,COUNTYNAME,CITY,CITYNAME,DAY,DAYNAME,MONTH,MONTHNAME,YEAR,DAY_WEEK,DAY_WEEKNAME,HOUR,HOURNAME,MINUTE,MINUTENAME,NHS,NHSNAME,ROUTE,ROUTENAME,TWAY_ID,TWAY_ID2,RUR_URB,RUR_URBNAME,FUNC_SYS,FUNC_SYSNAME,RD_OWNER,RD_OWNERNAME,MILEPT,MILEPTNAME,LATITUDE,LATITUDENAME,LONGITUD,LONGITUDNAME,SP_JUR,SP_JURNAME,HARM_EV,HARM_EVNAME,MAN_COLL,MAN_COLLNAME,RELJCT1,RELJCT1NAME,RELJCT2,RELJCT2NAME,TYP_INT,TYP_INTNAME,WRK_ZONE,WRK_ZONENAME,REL_ROAD,REL_ROADNAME,LGT_COND,LGT_CONDNAME,WEATHER1,WEATHER1NAME,WEATHER2,WEATHER2NAME,WEATHER,WEATHERNAME,SCH_BUS,SCH_BUSNAME,RAIL,RAILNAME,NOT_HOUR,NOT_HOURNAME,NOT_MIN,NOT_MINNAME,ARR_HOUR,ARR_HOURNAME,ARR_MIN,ARR_MINNAME,HOSP_HR,HOSP_HRNAME,HOSP_MN,HOSP_MNNAME,CF1,CF1NAME,CF2,CF2NAME,CF3,CF3NAME,FATALS,DRUNK_DR) FROM 'C:/Users/steve/OneDrive/Desktop/NHTSA_raw/FARS2019NationalCSV/accident.csv' DELIMITER ',' CSV HEADER;
  ```
<br>

* Table `nhtsa_accident_2019_raw` contains 91 columns.  

  <details>
    <summary><strong>View Data Dictionary</strong></summary><br>
	
	```sql
	SELECT column_name, data_type, character_maximum_length
	FROM information_schema.columns
	WHERE table_name = 'nhtsa_accident_2019_raw'
	```
	<br>
   
  | column_name  | data_type         | character_maximum_length |
  |--------------|-------------------|--------------------------|
  | state        | character varying | 255                      |
  | statename    | character varying | 255                      |
  | st_case      | character varying | 255                      |
  | ve_total     | character varying | 255                      |
  | ve_forms     | character varying | 255                      |
  | pvh_invl     | character varying | 255                      |
  | peds         | character varying | 255                      |
  | persons      | character varying | 255                      |
  | permvit      | character varying | 255                      |
  | pernotmvit   | character varying | 255                      |
  | county       | character varying | 255                      |
  | countyname   | character varying | 255                      |
  | city         | character varying | 255                      |
  | cityname     | character varying | 255                      |
  | day          | character varying | 255                      |
  | dayname      | character varying | 255                      |
  | month        | character varying | 255                      |
  | monthname    | character varying | 255                      |
  | year         | character varying | 255                      |
  | day_week     | character varying | 255                      |
  | day_weekname | character varying | 255                      |
  | hour         | character varying | 255                      |
  | hourname     | character varying | 255                      |
  | minute       | character varying | 255                      |
  | minutename   | character varying | 255                      |
  | nhs          | character varying | 255                      |
  | nhsname      | character varying | 255                      |
  | route        | character varying | 255                      |
  | routename    | character varying | 255                      |
  | tway_id      | character varying | 255                      |
  | tway_id2     | character varying | 255                      |
  | rur_urb      | character varying | 255                      |
  | rur_urbname  | character varying | 255                      |
  | func_sys     | character varying | 255                      |
  | func_sysname | character varying | 255                      |
  | rd_owner     | character varying | 255                      |
  | rd_ownername | character varying | 255                      |
  | milept       | character varying | 255                      |
  | mileptname   | character varying | 255                      |
  | latitude     | character varying | 255                      |
  | latitudename | character varying | 255                      |
  | longitud     | character varying | 255                      |
  | longitudname | character varying | 255                      |
  | sp_jur       | character varying | 255                      |
  | sp_jurname   | character varying | 255                      |
  | harm_ev      | character varying | 255                      |
  | harm_evname  | character varying | 255                      |
  | man_coll     | character varying | 255                      |
  | man_collname | character varying | 255                      |
  | reljct1      | character varying | 255                      |
  | reljct1name  | character varying | 255                      |
  | reljct2      | character varying | 255                      |
  | reljct2name  | character varying | 255                      |
  | typ_int      | character varying | 255                      |
  | typ_intname  | character varying | 255                      |
  | wrk_zone     | character varying | 255                      |
  | wrk_zonename | character varying | 255                      |
  | rel_road     | character varying | 255                      |
  | rel_roadname | character varying | 255                      |
  | lgt_cond     | character varying | 255                      |
  | lgt_condname | character varying | 255                      |
  | weather1     | character varying | 255                      |
  | weather1name | character varying | 255                      |
  | weather2     | character varying | 255                      |
  | weather2name | character varying | 255                      |
  | weather      | character varying | 255                      |
  | weathername  | character varying | 255                      |
  | sch_bus      | character varying | 255                      |
  | sch_busname  | character varying | 255                      |
  | rail         | character varying | 255                      |
  | railname     | character varying | 255                      |
  | not_hour     | character varying | 255                      |
  | not_hourname | character varying | 255                      |
  | not_min      | character varying | 255                      |
  | not_minname  | character varying | 255                      |
  | arr_hour     | character varying | 255                      |
  | arr_hourname | character varying | 255                      |
  | arr_min      | character varying | 255                      |
  | arr_minname  | character varying | 255                      |
  | hosp_hr      | character varying | 255                      |
  | hosp_hrname  | character varying | 255                      |
  | hosp_mn      | character varying | 255                      |
  | hosp_mnname  | character varying | 255                      |
  | cf1          | character varying | 255                      |
  | cf1name      | character varying | 255                      |
  | cf2          | character varying | 255                      |
  | cf2name      | character varying | 255                      |
  | cf3          | character varying | 255                      |
  | cf3name      | character varying | 255                      |
  | fatals       | character varying | 255                      |
  | drunk_dr     | character varying | 255                      |

</details>

<br><br>

The scope of the project requires 11 of the 91 data elements stored in `nhtsa_accident_2019_raw`.  
Data elements `st_case`, `statename`, `countyname`, `year`, `month`, `day`, `hour`, `day_weekname`, `rur_urbname`, `lgt_condname`, and `fatals` are isolated in a `TEMP TABLE` named `accident_temp` for further cleaning, manipulation, and analysis.  At this point, the number data elements are cast as `int` data types to aid further processing.

  ```sql
  CREATE TEMP TABLE accident_temp AS
    SELECT
      st_case::int AS id,
      statename AS state,
      countyname AS county,
      year::int, 
      month::int, 
      day::int, 
      hour::int,
      day_weekname AS day_of_week,
      rur_urbname AS rural_urban,
      lgt_condname AS light_condition,
      fatals::int AS fatalities
    FROM nhtsa_accident_2019_raw
  ```
 
  <details>
    <summary><strong>View Table Summary</strong></summary><br>
	  
```sql
   SELECT *
   FROM accident_temp
   LIMIT 5
```
<br>
        
  | id    | state   | county        | year | month | day | hour | day_of_week | rural_urban | light_condition    | fatalities |
  |-------|---------|---------------|------|-------|-----|------|-------------|-------------|--------------------|------------|
  | 10001 | Alabama | LEE (81)      | 2019 | 2     | 7   | 12   | Thursday    | Urban       | Daylight           | 1          |
  | 10002 | Alabama | ETOWAH (55)   | 2019 | 1     | 23  | 18   | Wednesday   | Urban       | Dark - Not Lighted | 1          |
  | 10003 | Alabama | CLEBURNE (29) | 2019 | 1     | 22  | 19   | Tuesday     | Rural       | Dark - Not Lighted | 1          |
  | 10004 | Alabama | ETOWAH (55)   | 2019 | 1     | 22  | 3    | Tuesday     | Rural       | Dark - Not Lighted | 1          |
  | 10005 | Alabama | BALDWIN (3)   | 2019 | 1     | 18  | 5    | Friday      | Urban       | Dark - Not Lighted | 1          |

  </details>
  <br>

***

<br>

# 🧹 Cleaning

⚠️ **Issue**  
* Inspection of the new data subset shows the `county` column contains county names as well as county id numbers.  
    
🛠️ **Action**  
* Separate the county name from the id number with an `UPDATE` statement using a `SUBSTRING()` function.
	```sql
	UPDATE accident_temp
	SET county = SUBSTRING(county FROM 1 FOR position('(' IN county)-2)
	 ```
	
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary><br>
		
	```sql
	SELECT *
	FROM accident_temp
	ORDER BY id
	LIMIT 5
	```
	<br>
	
	| id    | state   | county   | year | month | day | hour | day_of_week | rural_urban | light_condition    | fatalities |
	|-------|---------|----------|------|-------|-----|------|-------------|-------------|--------------------|------------|
	| 10001 | Alabama | LEE      | 2019 | 2     | 7   | 12   | Thursday    | Urban       | Daylight           | 1          |
	| 10002 | Alabama | ETOWAH   | 2019 | 1     | 23  | 18   | Wednesday   | Urban       | Dark - Not Lighted | 1          |
	| 10003 | Alabama | CLEBURNE | 2019 | 1     | 22  | 19   | Tuesday     | Rural       | Dark - Not Lighted | 1          |
	| 10004 | Alabama | ETOWAH   | 2019 | 1     | 22  | 3    | Tuesday     | Rural       | Dark - Not Lighted | 1          |
	| 10005 | Alabama | BALDWIN  | 2019 | 1     | 18  | 5    | Friday      | Urban       | Dark - Not Lighted | 1          |
	
	</details>
 <br><br><br>

⚠️ **Issue**  
* The data source asserts that the `ST_CASE` data element (now `id`) is unique to each record. Confirm the dataset does not contain duplicate rows.
    
🛠️ **Action**  
* Check the total number of rows using the `COUNT()` function and `DISTINCT`.

	```sql
	SELECT
	COUNT(*) AS total_count,
	COUNT(DISTINCT id) AS unique_id_count
	FROM accident_temp
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
	    
	| total_count | unique_id_count |
	|-------------|-----------------|
	| 33487       | 33487           |
	    
	</details>
 <br><br><br>


⚠️ **Issue**  
* Check if any `NULL` values exist in the dataset.
    
🛠️ **Action**  
* Use `IS NULL` to confirm no `NULL` values exist in any column.
	
	```sql
	SELECT *
	FROM accident_temp
	WHERE id IS NULL OR state IS NULL OR county IS NULL IS NULL OR day IS NULL
		OR month IS NULL OR year IS NULL OR hour IS NULL OR day_of_week IS NULL 
		OR rural_urban IS NULL OR light_condition IS NULL OR fatalities IS NULL
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
	    
	`No Results`
	    
	</details>
 <br><br><br>

⚠️ **Issue**  
* The `county` column is the only column that contains all uppercase string values.    

🛠️ **Action**  
* Use `UPPER()` function to transform remaining column values from capitalized to all uppercase.

	```sql
	UPDATE accident_temp
		SET state = UPPER(state),
		rural_urban = UPPER(rural_urban),
		light_condition = UPPER(light_condition),
		day_of_week = UPPER(day_of_week)
	
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary><br>
			
	```sql
	SELECT *
	FROM accident_temp
	ORDER BY id
	LIMIT 5
	```
	<br>
		  
	| id    | state   | county   | year | month | day | hour | day_of_week | rural_urban | light_condition    | fatalities |
	|-------|---------|----------|------|-------|-----|------|-------------|-------------|--------------------|------------|
	| 10001 | ALABAMA | LEE      | 2019 | 2     | 7   | 12   | THURSDAY    | URBAN       | DAYLIGHT           | 1          |
	| 10002 | ALABAMA | ETOWAH   | 2019 | 1     | 23  | 18   | WEDNESDAY   | URBAN       | DARK - NOT LIGHTED | 1          |
	| 10003 | ALABAMA | CLEBURNE | 2019 | 1     | 22  | 19   | TUESDAY     | RURAL       | DARK - NOT LIGHTED | 1          |
	| 10004 | ALABAMA | ETOWAH   | 2019 | 1     | 22  | 3    | TUESDAY     | RURAL       | DARK - NOT LIGHTED | 1          |
	| 10005 | ALABAMA | BALDWIN  | 2019 | 1     | 18  | 5    | FRIDAY      | URBAN       | DARK - NOT LIGHTED | 1          |
	  
	</details>
 <br><br><br>

⚠️ **Issue**  
* Check that all U.S. states and the District of Columbia - 51 total - are present in the `state` column.

🛠️ **Action**  
* Use `COUNT()` function and `DISTINCT` to count and view unique values in `state` column.
	
	```sql
	SELECT COUNT(DISTINCT state)  -- should be 51 (states + D.C.)
	FROM accident_temp
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
		  
	| count |
	|-------|
	| 51    |
		  
	</details>
 <br>

* View all `state` values using `DISTINCT`.
	
	```sql
	SELECT DISTINCT state  -- should be 51 (states + D.C.)
	FROM accident_temp
 	ORDER BY state
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
		  
	| state                |
	|----------------------|
	| ALABAMA              |
	| ALASKA               |
	| ARIZONA              |
	| ARKANSAS             |
	| CALIFORNIA           |
	| COLORADO             |
	| CONNECTICUT          |
	| DELAWARE             |
	| DISTRICT OF COLUMBIA |
	| FLORIDA              |
	| GEORGIA              |
	| HAWAII               |
	| IDAHO                |
	| ILLINOIS             |
	| INDIANA              |
	| IOWA                 |
	| KANSAS               |
	| KENTUCKY             |
	| LOUISIANA            |
	| MAINE                |
	| MARYLAND             |
	| MASSACHUSETTS        |
	| MICHIGAN             |
	| MINNESOTA            |
	| MISSISSIPPI          |
	| MISSOURI             |
	| MONTANA              |
	| NEBRASKA             |
	| NEVADA               |
	| NEW HAMPSHIRE        |
	| NEW JERSEY           |
	| NEW MEXICO           |
	| NEW YORK             |
	| NORTH CAROLINA       |
	| NORTH DAKOTA         |
	| OHIO                 |
	| OKLAHOMA             |
	| OREGON               |
	| PENNSYLVANIA         |
	| RHODE ISLAND         |
	| SOUTH CAROLINA       |
	| SOUTH DAKOTA         |
	| TENNESSEE            |
	| TEXAS                |
	| UTAH                 |
	| VERMONT              |
	| VIRGINIA             |
	| WASHINGTON           |
	| WEST VIRGINIA        |
	| WISCONSIN            |
	| WYOMING              |
	  
	</details>
 <br><br><br>
 

⚠️ **Issue**  
* Check that `day` column only contains integers 1-31.

🛠️ **Action**  
* Use `DISTINCT` to return all unique integer column values.
	
	```sql
	SELECT DISTINCT day
	FROM accident_temp
	ORDER BY day
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
	
	| day |
	|-----|
	| 1   |
	| 2   |
	| 3   |
	| 4   |
	| 5   |
	| 6   |
	| 7   |
	| 8   |
	| 9   |
	| 10  |
	| 11  |
	| 12  |
	| 13  |
	| 14  |
	| 15  |
	| 16  |
	| 17  |
	| 18  |
	| 19  |
	| 20  |
	| 21  |
	| 22  |
	| 23  |
	| 24  |
	| 25  |
	| 26  |
	| 27  |
	| 28  |
	| 29  |
	| 30  |
	| 31  |
	
	  
	</details>
 <br><br><br>

⚠️ **Issue**  
* Check that `month` column only contains integers 1-12.

🛠️ **Action**  
* Use `DISTINCT` to return all unique integer column values.
	
	```sql
	SELECT DISTINCT month
	FROM accident_temp
	ORDER BY month
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
	
	| month |
	|-------|
	| 1     |
	| 2     |
	| 3     |
	| 4     |
	| 5     |
	| 6     |
	| 7     |
	| 8     |
	| 9     |
	| 10    |
	| 11    |
	| 12    |
	
	</details>
 <br><br><br>

⚠️ **Issue**  
* Check that `year` column only contains integers 2019.

🛠️ **Action**  
* Use `DISTINCT` to return all unique integer column values.

	```sql
	SELECT DISTINCT year
	FROM accident_temp
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
	
	| year |
	|------|
	| 2019 |
	
	  
	</details>
 <br><br><br>

⚠️ **Issue**  
* Check that `day_of_week` column contains all 7 days of the week.

🛠️ **Action**  
* Use `DISTINCT` to return all unique `day_of_week` column values.
	
	```sql
	SELECT DISTINCT day_of_week
	FROM accident_temp
	ORDER BY day_of_week
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
	
	| day_of_week |
	|-------------|
	| FRIDAY      |
	| MONDAY      |
	| SATURDAY    |
	| SUNDAY      |
	| THURSDAY    |
	| TUESDAY     |
	| WEDNESDAY   |
	  
	</details>
 <br><br><br>

⚠️ **Issue**  
* Check that `hour` column only contains integers 0-23.

🛠️ **Action**  
* Use `DISTINCT` to return all unique integer column values.
	
	```sql
	SELECT DISTINCT hour
	FROM accident_temp
	ORDER BY hour 
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary>  
	<br>
		  
	| hour |
	|------|
	| 0    |
	| 1    |
	| 2    |
	| 3    |
	| 4    |
	| 5    |
	| 6    |
	| 7    |
	| 8    |
	| 9    |
	| 10   |
	| 11   |
	| 12   |
	| 13   |
	| 14   |
	| 15   |
	| 16   |
	| 17   |
	| 18   |
	| 19   |
	| 20   |
	| 21   |
	| 22   |
	| 23   |
	| 99   |
	  
	</details>
 <br><br><br>

⚠️ **Issue**  
* Column `hour` contains values integers **0-23** as well as **99**.  Further investigation of data source reveals that value **99** represents an unknown value in the `hour` column. In order for future analysis to proceed, change column value **99** to `NULL`.

🛠️ **Action**  
* Change all **99** column values to `NULL`.
	
	```sql
	UPDATE accident_temp
	SET hour = NULL WHERE hour = 99
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary><br>
			
	```sql
	SELECT DISTINCT hour
	FROM accident_temp
	ORDER BY hour
	```
	<br>
		  
	| hour |
	|--------|
	| 0      |
	| 1      |
	| 2      |
	| 3      |
	| 4      |
	| 5      |
	| 6      |
	| 7      |
	| 8      |
	| 9      |
	| 10     |
	| 11     |
	| 12     |
	| 13     |
	| 14     |
	| 15     |
	| 16     |
	| 17     |
	| 18     |
	| 19     |
	| 20     |
	| 21     |
	| 22     |
	| 23     |
	| NULL   |
	
	  
	</details>
 <br><br><br>

⚠️ **Issue**  
* Convaluted `light_condition` column values make understanding the information overly complicated for the purposes of this project. 

🛠️ **Action**  
* Investigate source data element descriptions and elucidate `light_condition` values by grouping column values that can reasonably be combined for the intentions of the project analysis.

   - List unique `light_condition` values. 

		```sql
	  SELECT DISTINCT light_condition
	  FROM accident_temp
		```
		  
		<details>
		<summary><strong><code>View Table Summary</code></strong></summary>  
		<br>
			  
		| light_condition         |
		|-------------------------|
		| DARK - UNKNOWN LIGHTING |
		| OTHER                   |
		| NOT REPORTED            |
		| DAYLIGHT                |
		| DARK - LIGHTED          |
		| DUSK                    |
		| REPORTED AS UNKNOWN     |
		| DAWN                    |
		| DARK - NOT LIGHTED      |
		  
		</details><br>

   - Combine column values **NOT REPORTED, REPORTED AS UNKNOWN, and OTHER** as value **UNKNOWN**
  
		```sql
		UPDATE accident_temp
		SET light_condition = 'UNKNOWN'
		WHERE light_condition NOT IN ('DAWN', 'DUSK', 'DAYLIGHT')
		AND light_condition NOT LIKE 'DARK%'
		```
		  
		<details>
		<summary><strong><code>View Table Summary</code></strong></summary><br>
			
		```sql
		SELECT DISTINCT light_condition
		FROM accident_temp
		```
		<br>
		
		| light_condition         |
		|-------------------------|
		| DARK - UNKNOWN LIGHTING |
		| DAYLIGHT                |
		| UNKNOWN                 |
		| DARK - LIGHTED          |
		| DUSK                    |
		| DAWN                    |
		| DARK - NOT LIGHTED      |
			  
		</details><br>

   - Combine column values **DARK-LIGHTED, DARK-NOT LIGHTED, and DARK-UNKNOWN LIGHTING** as value **DARK**
	  	```sql
	   UPDATE accident_temp
	   SET light_condition = 'DARK'
	   WHERE light_condition LIKE 'DARK%'
		```
		  
		<details>
		<summary><strong><code>View Table Summary</code></strong></summary><br>
			
		```sql
		SELECT DISTINCT light_condition
		FROM accident_temp
		```
		<br>
	
		| light_condition |
		|-----------------|
		| DAYLIGHT        |
		| UNKNOWN         |
		| DARK            |
		| DUSK            |
		| DAWN            |
		  
		</details>
 <br><br><br>

⚠️ **Issue**  
* Unnecessary `rural_urban` column value distinctions are redundant for the purposes of this project.

🛠️ **Action**  
* Combine redundant `rural_urban` values **TRAFFICWAY NOT IN STATE INVENTORY, NOT REPORTED,** and **UNKNOWN** as **UNKNOWN**.

   - List unique `rural_urban` values.
		    
		```sql
		SELECT DISTINCT rural_urban
   		FROM accident_temp
		```
		  
		<details>
		<summary><strong><code>View Table Summary</code></strong></summary>  
		<br>
			  
		| rural_urban                       |
		|-----------------------------------|
		| TRAFFICWAY NOT IN STATE INVENTORY |
		| RURAL                             |
		| NOT REPORTED                      |
		| UNKNOWN                           |
		| URBAN                             |
			  
		</details><br>

   - Combine values **TRAFFICWAY NOT IN STATE INVENTORY, NOT REPORTED, and UNKNOWN** as **UNKNOWN**.
   
		```sql
		UPDATE accident_temp
   		SET rural_urban = 'UNKNOWN'
		WHERE rural_urban NOT IN ('RURAL', 'URBAN')
		```
		  
		<details>
		<summary><strong><code>View Table Summary</code></strong></summary><br>
			
		```sql
		SELECT DISTINCT rural_urban
		FROM accident_temp
		```
		<br>
			  
		| rural_urban |
		|-------------|
		| RURAL       |
		| UNKNOWN     |
		| URBAN       |
					  
		</details>
 <br><br><br>

⚠️ **Issue**  
* Columns `month`,`day`,`year`, and `hour` should be combined to create a `timestamp` value for each row that will aid analysis.

🛠️ **Action**  
* Concatenate columns `month`,`day`,`year`, and `hour` using function `MAKE_TIMESTAMP()`.

   - Add column `time` to `accident_temp`.
	
		```sql
		ALTER TABLE accident_temp
		ADD COLUMN time timestamp
		```
		
	  	<br>

   - Insert concatenated timestamp values into `time` column with and `UPDATE` statement and `MAKE_TIMESTAMP()` function.
	   	
		```sql
		UPDATE accident_temp
		SET time = MAKE_TIMESTAMP(year, month, day, hour, 0, 0)
		```
	
	   	<details>
		<summary><strong><code>View Table Summary</code></strong></summary><br>
			
		```sql
		SELECT *
		FROM accident_temp
		ORDER BY id
		LIMIT 5
		```
		<br>
	
	 	| state   | county   | year | month | day | hour | day_of_week | rural_urban | light_condition | fatalities | time                |
		|---------|----------|------|-------|-----|------|-------------|-------------|-----------------|------------|---------------------|
		| ALABAMA | LEE      | 2019 | 2     | 7   | 12   | THURSDAY    | URBAN       | DAYLIGHT        | 1          | 2019-02-07 12:00:00 |
		| ALABAMA | ETOWAH   | 2019 | 1     | 23  | 18   | WEDNESDAY   | URBAN       | DARK            | 1          | 2019-01-23 18:00:00 |
		| ALABAMA | CLEBURNE | 2019 | 1     | 22  | 19   | TUESDAY     | RURAL       | DARK            | 1          | 2019-01-22 19:00:00 |
		| ALABAMA | ETOWAH   | 2019 | 1     | 22  | 3    | TUESDAY     | RURAL       | DARK            | 1          | 2019-01-22 03:00:00 |
		| ALABAMA | BALDWIN  | 2019 | 1     | 18  | 5    | FRIDAY      | URBAN       | DARK            | 1          | 2019-01-18 05:00:00 |
	
		</details><br>

   - Drop column `hour` from dataset because it is now redundant. Columns `day`, `month`, and `year` remain because they do not contain `NULL` values.
	  
		```sql
		ALTER TABLE accident_temp
		DROP hour
		```
	
	   	<details>
		<summary><strong><code>View Table Summary</code></strong></summary><br>
			
		```sql
		SELECT *
		FROM accident_temp
		ORDER BY id
		LIMIT 5
		```
		<br>
	
		| id    | state   | county   | year | month | day | day_of_week | rural_urban | light_condition | fatalities | time                |
		|-------|---------|----------|------|-------|-----|-------------|-------------|-----------------|------------|---------------------|
		| 10001 | ALABAMA | LEE      | 2019 | 2     | 7   | THURSDAY    | URBAN       | DAYLIGHT        | 1          | 2019-02-07 12:00:00 |
		| 10002 | ALABAMA | ETOWAH   | 2019 | 1     | 23  | WEDNESDAY   | URBAN       | DARK            | 1          | 2019-01-23 18:00:00 |
		| 10003 | ALABAMA | CLEBURNE | 2019 | 1     | 22  | TUESDAY     | RURAL       | DARK            | 1          | 2019-01-22 19:00:00 |
		| 10004 | ALABAMA | ETOWAH   | 2019 | 1     | 22  | TUESDAY     | RURAL       | DARK            | 1          | 2019-01-22 03:00:00 |
		| 10005 | ALABAMA | BALDWIN  | 2019 | 1     | 18  | FRIDAY      | URBAN       | DARK            | 1          | 2019-01-18 05:00:00 |
	
		</details>
 <br><br><br>

### 🏁 **Add clean dataset to new table for analysis.**

* Create table for cleaned dataset.
 
	```sql
	DROP TABLE IF EXISTS accident_data_2019
	CREATE TABLE accident_data_2019 AS
		SELECT *
		FROM accident_temp
		ORDER BY id

	```
	<br>

* Add `PRIMARY KEY` constraint for column `id` in `accident_data_2019`.

	 ```sql
	ALTER TABLE accident_data_2019
	ADD PRIMARY KEY(id)
	```	
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary><br>
		
	```sql
	SELECT *
	FROM accident_data_2019
	ORDER BY id
	LIMIT 5
	```
	<br>
	
	| id    | state   | county   | year | month | day | day_of_week | rural_urban | light_condition | fatalities | time                |
	|-------|---------|----------|------|-------|-----|-------------|-------------|-----------------|------------|---------------------|
	| 10001 | ALABAMA | LEE      | 2019 | 2     | 7   | THURSDAY    | URBAN       | DAYLIGHT        | 1          | 2019-02-07 12:00:00 |
	| 10002 | ALABAMA | ETOWAH   | 2019 | 1     | 23  | WEDNESDAY   | URBAN       | DARK            | 1          | 2019-01-23 18:00:00 |
	| 10003 | ALABAMA | CLEBURNE | 2019 | 1     | 22  | TUESDAY     | RURAL       | DARK            | 1          | 2019-01-22 19:00:00 |
	| 10004 | ALABAMA | ETOWAH   | 2019 | 1     | 22  | TUESDAY     | RURAL       | DARK            | 1          | 2019-01-22 03:00:00 |
	| 10005 | ALABAMA | BALDWIN  | 2019 | 1     | 18  | FRIDAY      | URBAN       | DARK            | 1          | 2019-01-18 05:00:00 |
	
	</details><br><br>

***
***
<br>

# U.S. Census Data
***
# 📋 Preparation
Microsoft Excel was utilized to perform an intial inspection on the previously downloaded census population file `DECENNIALPL2020.P1-Data.csv`. Inspection revealed that the only required data elements for the project analysis were located in the first three columns. The file was altered using Excel to remove all but the first 3 columns of data before being saved as `DECENNIALPL2020.P1-Data-V2.csv` in preparation to be uploaded to the local PostgreSQL server. At this point, table `census_raw` [was created](/fatal_crash_project/queries.sql#L250) with a `CREATE TABLE` statement. in which to copy the altered dataset..

  * The raw data was copied from the `DECENNIALPL2020.P1-Data-V2.csv` file into the `census_raw` table using the `psql` client copy command: `\copy`. 

  ```sql
    \copy census_raw(geography, geographic_area, total) FROM 'C:\Users\steve\portfolio_projects\fatal_crash_project_repo\census data\DECENNIALPL2020.P1-Data-V2.csv' DELIMITER ',' CSV HEADER;
  ```
<br>

* Table `census_raw` contains 3 columns.  

  <details>
	<summary><strong>View Data Dictionary</strong></summary><br>
	  
	```sql
	SELECT column_name, data_type, character_maximum_length
	FROM information_schema.columns
	WHERE table_name = 'census_raw'
	```
	<br>

  | column_name     | data_type         | character_maximum_length |
  |-----------------|-------------------|--------------------------|
  | total           | integer           | NULL                     |
  | geography       | character varying | 255                      |
  | geographic_area | character varying | 255                      |

  </details>
 
  <details>
	<summary><strong>View Table Summary</strong></summary><br>
	  
	```sql
	SELECT *
	FROM census_raw
	LIMIT 5
	```
	<br>

   | geography           | geographic_area                           | total |
   |---------------------|-------------------------------------------|-------|
   | 0600000US0100190171 | Autaugaville CCD, Autauga County, Alabama | 3185  |
   | 0600000US0100190315 | Billingsley CCD, Autauga County, Alabama  | 2645  |
   | 0600000US0100192106 | Marbury CCD, Autauga County, Alabama      | 6359  |
   | 0600000US0100192628 | Prattville CCD, Autauga County, Alabama   | 46616 |
   | 0600000US0100390207 | Bay Minette CCD, Baldwin County, Alabama  | 25186 |
	
 </details>

<br><br>


Next, table `census_temp` was created as a `TEMP TABLE` to isolate the raw data elements `geographic_area` and `total` from the raw data table for further cleaning, manipulation, and analysis.  At this point, column `state` was created for the state name extracted from the `geographic_area` column using the `SPLIT_PART()` and `LTRIM()` functions.

```sql
CREATE TEMP TABLE census_temp AS
	SELECT 	geographic_area,
		LTRIM(SPLIT_PART(geographic_area, ',', -1), ' ') AS state,
		total
	FROM census_raw
```

<details>
<summary><strong>View Table Summary</strong></summary><br>
	
```sql
SELECT *
FROM census_temp
LIMIT 5
```
<br>
	
| geographic_area                           | state   | total |
|-------------------------------------------|---------|-------|
| Autaugaville CCD, Autauga County, Alabama | Alabama | 3185  |
| Billingsley CCD, Autauga County, Alabama  | Alabama | 2645  |
| Marbury CCD, Autauga County, Alabama      | Alabama | 6359  |
| Prattville CCD, Autauga County, Alabama   | Alabama | 46616 |
| Bay Minette CCD, Baldwin County, Alabama  | Alabama | 25186 |


</details>

<br><br>

***
# 🧹 Cleaning

⚠️ **Issue:**  
* Check that every state, D.C., and Puerto Rico were successfully extracted from the raw data.
    
🛠️ **Action**  
* Use `COUNT()` function and `SELECT DISTINCT` statement to view the number and list of unique `state` values.

	```sql
 	SELECT COUNT(DISTINCT state)
 	FROM census_temp
  	```

  	<details>
    	<summary><strong>View Table Summary</strong></summary><br>
	
	| count |
	|-------|
	| 52    |

	</details>
	
	<br><br>
 
  	```sql
 	SELECT DISTINCT state
 	FROM census_temp
	ORDER BY state
  	```
	  
  	<details>
	<summary><strong>View Table Summary</strong></summary><br>

	| state                |
	|----------------------|
	| Alabama              |
	| Alaska               |
	| Arizona              |
	| Arkansas             |
	| California           |
	| Colorado             |
	| Connecticut          |
	| Delaware             |
	| District of Columbia |
	| Florida              |
	| Georgia              |
	| Hawaii               |
	| Idaho                |
	| Illinois             |
	| Indiana              |
	| Iowa                 |
	| Kansas               |
	| Kentucky             |
	| Louisiana            |
	| Maine                |
	| Maryland             |
	| Massachusetts        |
	| Michigan             |
	| Minnesota            |
	| Mississippi          |
	| Missouri             |
	| Montana              |
	| Nebraska             |
	| Nevada               |
	| New Hampshire        |
	| New Jersey           |
	| New Mexico           |
	| New York             |
	| North Carolina       |
	| North Dakota         |
	| Ohio                 |
	| Oklahoma             |
	| Oregon               |
	| Pennsylvania         |
	| Puerto Rico          |
	| Rhode Island         |
	| South Carolina       |
	| South Dakota         |
	| Tennessee            |
	| Texas                |
	| Utah                 |
	| Vermont              |
	| Virginia             |
	| Washington           |
	| West Virginia        |
	| Wisconsin            |
	| Wyoming              |

	</details>
 
 <br><br><br>

### 🏁 **Add clean dataset to new table for analysis.**

* Create final table with uppercase `state` values, `population` column with summed `total` values grouped by `state`, and `state` value "Puerto Rico" exluded from dataset.
	
	```sql
	 CREATE TABLE state_pop AS
		SELECT UPPER(state) AS state, 
			SUM(total) AS population
		FROM census_temp
		WHERE state NOT ILIKE 'puerto rico'
		GROUP BY state
		ORDER BY state
	```
	  
	<details>
	<summary><strong><code>View Table Summary</code></strong></summary><br>
		
	```sql
	SELECT *
	FROM state_pop
	```
	<br>

	| state                | population |
	|----------------------|------------|
	| ALABAMA              | 5024279    |
	| ALASKA               | 733391     |
	| ARIZONA              | 7151502    |
	| ARKANSAS             | 3011524    |
	| CALIFORNIA           | 39538223   |
	| COLORADO             | 5773714    |
	| CONNECTICUT          | 3605944    |
	| DELAWARE             | 989948     |
	| DISTRICT OF COLUMBIA | 689545     |
	| FLORIDA              | 21538187   |
	| GEORGIA              | 10711908   |
	| HAWAII               | 1455271    |
	| IDAHO                | 1839106    |
	| ILLINOIS             | 12812508   |
	| INDIANA              | 6785528    |
	| IOWA                 | 3190369    |
	| KANSAS               | 2937880    |
	| KENTUCKY             | 4505836    |
	| LOUISIANA            | 4657757    |
	| MAINE                | 1362359    |
	| MARYLAND             | 6177224    |
	| MASSACHUSETTS        | 7029917    |
	| MICHIGAN             | 10077331   |
	| MINNESOTA            | 5706494    |
	| MISSISSIPPI          | 2961279    |
	| MISSOURI             | 6154913    |
	| MONTANA              | 1084225    |
	| NEBRASKA             | 1961504    |
	| NEVADA               | 3104614    |
	| NEW HAMPSHIRE        | 1377529    |
	| NEW JERSEY           | 9288994    |
	| NEW MEXICO           | 2117522    |
	| NEW YORK             | 20201249   |
	| NORTH CAROLINA       | 10439388   |
	| NORTH DAKOTA         | 779094     |
	| OHIO                 | 11799448   |
	| OKLAHOMA             | 3959353    |
	| OREGON               | 4237256    |
	| PENNSYLVANIA         | 13002700   |
	| RHODE ISLAND         | 1097379    |
	| SOUTH CAROLINA       | 5118425    |
	| SOUTH DAKOTA         | 886667     |
	| TENNESSEE            | 6910840    |
	| TEXAS                | 29145505   |
	| UTAH                 | 3271616    |
	| VERMONT              | 643077     |
	| VIRGINIA             | 8631393    |
	| WASHINGTON           | 7705281    |
	| WEST VIRGINIA        | 1793716    |
	| WISCONSIN            | 5893718    |
	| WYOMING              | 576851     |
	  
	</details>
 <br><br><br>


***









