# Data Analysis

### ℹ️ Total Number of Accidents and Resulting Fatalities

```sql
SELECT
  COUNT(*) AS accident_total,
  COUNT(*) / 365 AS avg_accidents_per_day,
  SUM(fatalities) AS fatal_total,
  SUM(fatalities) / 365 AS avg_fatalities_per_day
FROM accident_data_2019;
```
<br>

| accident_total | avg_accidents_per_day | fatal_total | avg_fatalities_per_day |
|----------------|-----------------------|-------------|------------------------|
| 33487          | 91                    | 36355       | 99                     |


<br>
<br>



### ℹ️ Accident Fatalities Per Month

* **Months Ranked**
  ```sql
  SELECT
    TO_CHAR(TO_DATE(month::TEXT, 'MM'), 'MONTH') AS month,
    SUM(fatalities) AS fatalities_total,
    RANK() OVER(ORDER BY SUM(fatalities) DESC)
  FROM accident_data_2019
  GROUP BY month
  ORDER BY rank
  ```
  
  **Results:**
    | month     | fatalities_total | rank |
    |-----------|------------------|------|
    | AUGUST    | 3359             | 1    |
    | SEPTEMBER | 3331             | 2    |
    | JULY      | 3304             | 3    |
    | OCTOBER   | 3227             | 4    |
    | JUNE      | 3201             | 5    |
    | MAY       | 3172             | 6    |
    | NOVEMBER  | 3084             | 7    |
    | DECEMBER  | 3025             | 8    |
    | APRIL     | 2820             | 9    |
    | MARCH     | 2769             | 10   |
    | JANUARY   | 2670             | 11   |
    | FEBRUARY  | 2393             | 12   |

<br>

* **Percent Difference (Most vs Least)**
  ```sql
  WITH month_cte AS (
    SELECT
      month,
      SUM(fatalities) AS fatalities_total,
      RANK() OVER(ORDER BY SUM(fatalities) DESC)
    FROM accident_data_2019
    GROUP BY month
    ORDER BY month
  	)
  SELECT
    ROUND((MAX(fatalities_total) -
      MIN(fatalities_total))::decimal /
        MIN(fatalities_total) * 100, 1) AS percent_diff
  FROM month_cte
  ;
  ```
  
  **Results:**
    | percent_diff |
    |--------------|
    | 40.4         |

<br>
<br>



### ℹ️ Accident Fatalities by Day of Week

```sql
SELECT
  day_of_week,
  SUM(fatalities) AS fatalities_total
FROM accident_data_2019
GROUP BY day_of_week
ORDER BY fatalities_total DESC
```
<br>

**Results:**

| day_of_week | fatalities_total |
|-------------|------------------|
| SATURDAY    | 6208             |
| FRIDAY      | 5743             |
| SUNDAY      | 5643             |
| THURSDAY    | 4796             |
| MONDAY      | 4696             |
| TUESDAY     | 4656             |
| WEDNESDAY   | 4613             |

<br>
<br>



### ℹ️ Accident Fatalities by Hour and Day of Week

* **Hours Ranked**
  ```sql
  CREATE TEMP TABLE hours_ranked AS
  SELECT
    day_of_week,
    EXTRACT('hour' FROM time) AS time,
    SUM(fatalities) AS fatalities_total,
    RANK() OVER(ORDER BY SUM(fatalities) DESC)
  FROM accident_data_2019
  WHERE time IS NOT NULL
  GROUP BY
    day_of_week,
    EXTRACT('hour' FROM time);

  ```

  <details>
    <summary><code><strong>View Table Summary</strong></code></summary>

    ```sql
    SELECT *
    FROM hours_ranked
    LIMIT 25;
    ```

    | day_of_week | time | fatalities_total | rank |
    |-------------|------|------------------|------|
    | SATURDAY    | 21   | 388              | 1    |
    | SATURDAY    | 20   | 368              | 2    |
    | SATURDAY    | 23   | 361              | 3    |
    | SUNDAY      | 1    | 359              | 4    |
    | SUNDAY      | 2    | 358              | 5    |
    | SATURDAY    | 19   | 358              | 5    |
    | SATURDAY    | 22   | 356              | 7    |
    | FRIDAY      | 18   | 356              | 7    |
    | FRIDAY      | 21   | 346              | 9    |
    | SATURDAY    | 18   | 342              | 10   |
    | FRIDAY      | 20   | 339              | 11   |
    | SUNDAY      | 0    | 339              | 11   |
    | FRIDAY      | 23   | 336              | 13   |
    | FRIDAY      | 19   | 329              | 14   |
    | FRIDAY      | 22   | 328              | 15   |
    | FRIDAY      | 17   | 323              | 16   |
    | FRIDAY      | 15   | 322              | 17   |
    | SUNDAY      | 18   | 319              | 18   |
    | SATURDAY    | 2    | 315              | 19   |
    | SATURDAY    | 17   | 313              | 20   |
    | SUNDAY      | 21   | 310              | 21   |
    | SUNDAY      | 19   | 305              | 22   |
    | SATURDAY    | 0    | 299              | 23   |
    | SATURDAY    | 15   | 296              | 24   |
    | THURSDAY    | 20   | 291              | 25   |

  </details>  

<br>

* **Hours Ranked - Top 10 (Sat-Sun)**
  ```sql
  SELECT
    day_of_week,
    TO_CHAR(MAKE_TIME(time::int, 0, 0), 'HH:00:00 AM'),
    fatalities_total
  FROM hours_ranked
  WHERE rank < 11 AND day_of_week IN ('SATURDAY', 'SUNDAY')
  ORDER BY day_of_week, time
  ```
  
  **Results:**
  
  | day_of_week | to_char     | fatalities_total |
  |-------------|-------------|------------------|
  | SATURDAY    | 06:00:00 PM | 342              |
  | SATURDAY    | 07:00:00 PM | 358              |
  | SATURDAY    | 08:00:00 PM | 368              |
  | SATURDAY    | 09:00:00 PM | 388              |
  | SATURDAY    | 10:00:00 PM | 356              |
  | SATURDAY    | 11:00:00 PM | 361              |
  | SUNDAY      | 01:00:00 AM | 359              |
  | SUNDAY      | 02:00:00 AM | 358              |


<br>
<br>



### ℹ️ Rural & Urban Accident Fatalities 

```sql
SELECT
  rural_urban,
  COUNT(*) AS accident_count,
  SUM(fatalities) AS fatality_total
FROM accident_data_2019
WHERE rural_urban NOT ILIKE 'unknown'
GROUP BY rural_urban
```
<br>

**Results:**

| rural_urban | accident_count | fatality_total |
|-------------|----------------|----------------|
| RURAL       | 14626          | 16288          |
| URBAN       | 18753          | 19946          |

<br>
<br>



### ℹ️ Ten Most Fatal Hours of the Week For Rural & Urban Areas

```sql
WITH cte AS (
  SELECT ----every hour of every day total fatalities ranked desc
    rural_urban,
    day_of_week,
    TO_CHAR(time, 'HH:00:00 AM') AS time,
    SUM(fatalities) AS fatalities_total,
    RANK() OVER(PARTITION BY rural_urban ORDER BY SUM(fatalities) DESC)
  FROM accident_data_2019
  WHERE rural_urban NOT ILIKE 'unknown'
    AND time IS NOT NULL
  GROUP BY
    rural_urban,
    day_of_week,
    TO_CHAR(time, 'HH:00:00 AM')
  )

SELECT *
FROM cte
WHERE rank <= 10
ORDER BY rural_urban, day_of_week, time
```
<br>

**Results (Ordered by Day):**

| rural_urban | day_of_week | time        | fatalities_total | rank |
|-------------|-------------|-------------|------------------|------|
| ***RURAL***       | ***FRIDAY***      | ***03:00:00 PM*** | ***183***              | ***1***    |
| RURAL       | FRIDAY      | 05:00:00 PM | 154              | 7    |
| RURAL       | FRIDAY      | 06:00:00 PM | 160              | 5    |
| RURAL       | SATURDAY    | 03:00:00 PM | 175              | 2    |
| RURAL       | SATURDAY    | 06:00:00 PM | 150              | 9    |
| RURAL       | SATURDAY    | 07:00:00 PM | 163              | 3    |
| RURAL       | SATURDAY    | 08:00:00 PM | 155              | 6    |
| RURAL       | SUNDAY      | 02:00:00 PM | 150              | 9    |
| RURAL       | SUNDAY      | 04:00:00 PM | 162              | 4    |
| RURAL       | THURSDAY    | 03:00:00 PM | 151              | 8    |
| URBAN       | FRIDAY      | 08:00:00 PM | 208              | 10   |
| URBAN       | FRIDAY      | 09:00:00 PM | 213              | 6    |
| URBAN       | SATURDAY    | 02:00:00 AM | 211              | 7    |
| URBAN       | SATURDAY    | 08:00:00 PM | 211              | 7    |
| URBAN       | SATURDAY    | 09:00:00 PM | 248              | 2    |
| URBAN       | SATURDAY    | 10:00:00 PM | 230              | 4    |
| URBAN       | SATURDAY    | 11:00:00 PM | 222              | 5    |
| URBAN       | SUNDAY      | 01:00:00 AM | 242              | 3    |
| ***URBAN***       | ***SUNDAY***      | ***02:00:00 AM***| ***256***              | ***1***    |
| URBAN       | SUNDAY      | 12:00:00 AM | 210              | 9    |

<br>
<br>


### ℹ️ Accident Fatalities by Light Condition

```sql
WITH lc_cte AS (
  SELECT
    light_condition,
    SUM(fatalities) AS fatalities_total
  FROM accident_data_2019
  WHERE light_condition NOT ILIKE 'unknown'
  GROUP BY light_condition
  )
SELECT
  light_condition,
  fatalities_total,
  ROUND((fatalities_total /
    SUM(fatalities_total) OVER()) * 100, 1) || '%'
FROM lc_cte
```
<br>

**Results:**

| light_condition | fatalities_total | percent_total |
|----------------|-----------------|--------------:|
| DAWN            | 718              | 2.0 %          |
| DAYLIGHT        | 17242            | 47.7 %         |
| DARK            | 17316            | 47.9 %         |
| DUSK            | 842              | 2.3 %          |

<br>
<br>



### ℹ️ Rural & Urban Accident Fatalities Comparison by Light Condition

```sql
WITH cte AS (
  SELECT
    rural_urban,
    light_condition,
    SUM(fatalities) AS fatalities_total
  FROM accident_data_2019
  WHERE light_condition NOT ILIKE 'unknown'
    AND rural_urban NOT ILIKE 'unknown'
  GROUP BY rural_urban, light_condition
)

SELECT
  rural_urban,
  light_condition,
  fatalities_total,
  ROUND(fatalities_total /
    (SUM(fatalities_total) OVER(
      PARTITION BY rural_urban))*100, 1) || ' %' AS percent
  FROM cte
  ORDER BY rural_urban, light_condition
```
<br>

**Results:**

| rural_urban | light_condition | fatalities_total | percent |
|------------|----------------|-----------------|--------:|
| RURAL       | DARK            | 6388             | 39.6 %  |
| RURAL       | DAWN            | 373              | 2.3 %   |
| RURAL       | DAYLIGHT        | 8972             | 55.6 %  |
| RURAL       | DUSK            | 416              | 2.6 %   |
| URBAN       | DARK            | 10895            | 54.9 %  |
| URBAN       | DAWN            | 342              | 1.7 %   |
| URBAN       | DAYLIGHT        | 8199             | 41.3 %  |
| URBAN       | DUSK            | 421              | 2.1 %   |


<br>
<br>













### ℹ️ Most Accident Fatalities Ranked vs. Population

  ```sql
  SELECT
    a.state,
    RANK() OVER(ORDER BY SUM(a.fatalities) DESC) AS fatalities_rank,
    SUM(a.fatalities) AS fatalities_total,
    RANK() OVER(ORDER BY sp.population DESC) AS population_rank,
    sp.population
  FROM accident_data_2019 AS a
  JOIN state_pop AS sp
    ON a.state = sp.state
  GROUP BY a.state, sp.population
  ORDER BY fatalities_total DESC
  ```
  <br>
  
  **Results Summary:**
  
  | state                | fatalities_rank | fatalities_total | population_rank | population |
  |----------------------|:---------------:|:----------------:|:---------------:|:----------:|
  | CALIFORNIA           | 1               | 3719             | 1               | 39538223   |
  | TEXAS                | 2               | 3619             | 2               | 29145505   |
  | FLORIDA              | 3               | 3185             | 3               | 21538187   |
  | **GEORGIA**              | **4**               | **1492**             | **8**               | **10711908**   |
  | **NORTH CAROLINA**       | **5**               | **1457**             | **9**               | **10439388**   |
  
  <details>
  <summary><code><strong>View Full Results</strong></code></summary><br>
    
  | state                | fatalities_rank | fatalities_total | population_rank | population |
  |----------------------|:---------------:|:----------------:|:---------------:|:----------:|
  | CALIFORNIA           | 1               | 3719             | 1               | 39538223   |
  | TEXAS                | 2               | 3619             | 2               | 29145505   |
  | FLORIDA              | 3               | 3185             | 3               | 21538187   |
  | GEORGIA              | 4               | 1492             | 8               | 10711908   |
  | NORTH CAROLINA       | 5               | 1457             | 9               | 10439388   |
  | OHIO                 | 6               | 1153             | 7               | 11799448   |
  | TENNESSEE            | 7               | 1136             | 16              | 6910840    |
  | PENNSYLVANIA         | 8               | 1059             | 5               | 13002700   |
  | ILLINOIS             | 9               | 1009             | 6               | 12812508   |
  | SOUTH CAROLINA       | 10              | 1006             | 23              | 5118425    |
  | MICHIGAN             | 11              | 986              | 10              | 10077331   |
  | ARIZONA              | 12              | 979              | 14              | 7151502    |
  | NEW YORK             | 13              | 934              | 4               | 20201249   |
  | ALABAMA              | 14              | 930              | 24              | 5024279    |
  | MISSOURI             | 15              | 881              | 19              | 6154913    |
  | VIRGINIA             | 16              | 831              | 12              | 8631393    |
  | INDIANA              | 17              | 810              | 17              | 6785528    |
  | KENTUCKY             | 18              | 732              | 26              | 4505836    |
  | LOUISIANA            | 19              | 727              | 25              | 4657757    |
  | MISSISSIPPI          | 20              | 642              | 34              | 2961279    |
  | OKLAHOMA             | 21              | 640              | 28              | 3959353    |
  | COLORADO             | 22              | 597              | 21              | 5773714    |
  | WISCONSIN            | 23              | 567              | 20              | 5893718    |
  | NEW JERSEY           | 24              | 558              | 11              | 9288994    |
  | WASHINGTON           | 25              | 538              | 13              | 7705281    |
  | MARYLAND             | 26              | 535              | 18              | 6177224    |
  | ARKANSAS             | 27              | 511              | 33              | 3011524    |
  | OREGON               | 28              | 493              | 27              | 4237256    |
  | NEW MEXICO           | 29              | 425              | 36              | 2117522    |
  | KANSAS               | 30              | 410              | 35              | 2937880    |
  | MINNESOTA            | 31              | 364              | 22              | 5706494    |
  | IOWA                 | 32              | 336              | 31              | 3190369    |
  | MASSACHUSETTS        | 32              | 336              | 15              | 7029917    |
  | NEVADA               | 34              | 304              | 32              | 3104614    |
  | WEST VIRGINIA        | 35              | 260              | 39              | 1793716    |
  | CONNECTICUT          | 36              | 249              | 29              | 3605944    |
  | UTAH                 | 37              | 248              | 30              | 3271616    |
  | NEBRASKA             | 37              | 248              | 37              | 1961504    |
  | IDAHO                | 39              | 224              | 38              | 1839106    |
  | MONTANA              | 40              | 184              | 44              | 1084225    |
  | MAINE                | 41              | 157              | 42              | 1362359    |
  | WYOMING              | 42              | 147              | 51              | 576851     |
  | DELAWARE             | 43              | 132              | 45              | 989948     |
  | HAWAII               | 44              | 108              | 40              | 1455271    |
  | SOUTH DAKOTA         | 45              | 102              | 46              | 886667     |
  | NEW HAMPSHIRE        | 46              | 101              | 41              | 1377529    |
  | NORTH DAKOTA         | 47              | 100              | 47              | 779094     |
  | ALASKA               | 48              | 67               | 48              | 733391     |
  | RHODE ISLAND         | 49              | 57               | 43              | 1097379    |
  | VERMONT              | 50              | 47               | 50              | 643077     |
  | DISTRICT OF COLUMBIA | 51              | 23               | 49              | 689545     |
  
  </details>

<br>
<br>


### ℹ️ Accident Fatalities Per 100,000 Residents

```sql
SELECT
  a.state,
  ROUND((100000 / sp.population::decimal) *
    SUM(a.fatalities),1) AS fatalities_per_100k
FROM accident_data_2019 AS a
JOIN state_pop AS sp
  ON a.state = sp.state
GROUP BY a.state, sp.population
ORDER BY fatalities_per_100k DESC
```
<br>

  **Results Summary:**

  | state                | fatalities_per_100k |
  |--------------------|:---------------------:|
  | **WYOMING**              | **25.5**                  |
  | MISSISSIPPI          | 21.7                  |
  | NEW MEXICO           | 20.1                  |
  | SOUTH CAROLINA       | 19.7                  |
  | ALABAMA              | 18.5                  |
  
  <details>
  <summary><code><strong>View Full Results</strong></code></summary><br>
    
  | state                | fatalities_per_100000 |
  |--------------------|:---------------------:|
  | WYOMING              | 25.5                  |
  | MISSISSIPPI          | 21.7                  |
  | NEW MEXICO           | 20.1                  |
  | SOUTH CAROLINA       | 19.7                  |
  | ALABAMA              | 18.5                  |
  | ARKANSAS             | 17.0                  |
  | MONTANA              | 17.0                  |
  | TENNESSEE            | 16.4                  |
  | KENTUCKY             | 16.2                  |
  | OKLAHOMA             | 16.2                  |
  | LOUISIANA            | 15.6                  |
  | FLORIDA              | 14.8                  |
  | WEST VIRGINIA        | 14.5                  |
  | MISSOURI             | 14.3                  |
  | NORTH CAROLINA       | 14.0                  |
  | KANSAS               | 14.0                  |
  | GEORGIA              | 13.9                  |
  | ARIZONA              | 13.7                  |
  | DELAWARE             | 13.3                  |
  | NORTH DAKOTA         | 12.8                  |
  | NEBRASKA             | 12.6                  |
  | TEXAS                | 12.4                  |
  | IDAHO                | 12.2                  |
  | INDIANA              | 11.9                  |
  | OREGON               | 11.6                  |
  | MAINE                | 11.5                  |
  | SOUTH DAKOTA         | 11.5                  |
  | IOWA                 | 10.5                  |
  | COLORADO             | 10.3                  |
  | OHIO                 | 9.8                   |
  | MICHIGAN             | 9.8                   |
  | NEVADA               | 9.8                   |
  | VIRGINIA             | 9.6                   |
  | WISCONSIN            | 9.6                   |
  | CALIFORNIA           | 9.4                   |
  | ALASKA               | 9.1                   |
  | MARYLAND             | 8.7                   |
  | PENNSYLVANIA         | 8.1                   |
  | ILLINOIS             | 7.9                   |
  | UTAH                 | 7.6                   |
  | HAWAII               | 7.4                   |
  | VERMONT              | 7.3                   |
  | NEW HAMPSHIRE        | 7.3                   |
  | WASHINGTON           | 7.0                   |
  | CONNECTICUT          | 6.9                   |
  | MINNESOTA            | 6.4                   |
  | NEW JERSEY           | 6.0                   |
  | RHODE ISLAND         | 5.2                   |
  | MASSACHUSETTS        | 4.8                   |
  | NEW YORK             | 4.6                   |
  | DISTRICT OF COLUMBIA | 3.3                   |

  
  </details>

<br>
<br>



