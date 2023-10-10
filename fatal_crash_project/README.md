# NHTSA Traffic Accident Fatality Report Analysis

Every year, the National Highway Traffic & Safety Administration (NHTSA) composes an amalgamation of traffic accident fatality data collected from transportation and law enforcement agencies all over the United States as reported by the [Fatality Analysis Reporting System (FARS)](https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813417#page=6). The data consists of crash characteristics that include location, time, vehicle description, persons involved, and environmental factors of traffic accidents that resulted in fatalities during the year. This project will perform an exploratory analysis on the NHTSA accident fatality data from 2019 in order to showcase the relationship between total numbers of fatalities, chronology, and location of each accident. The state population density in which accidents occurred will also be taken into consideration. The scope of this project is limited to the NHTSA *fatal* accident dataset, and therefore, all occurences of *accident(s)* in this analysis refer to records in this dataset. The population data was collected from the U.S. Census Bureau. 

This analysis seeks to provide answers to the following:
* How many accidents and resulting fatalities occurred during the year?
* Where did the most and least accidents and resulting fatalities occur?
* Where did the most and least accidents and fatalities occur relative to state population?
* When did the most accidents occur over the year?
* What times during the average week were associated with increased numbers of accidents?
* Does the time the most accidents occur differ significantly for rural and urban environments?
* Does environmental lighting affect the number of accidents for rural and urban environments?

<br>

***
***

<br>

## Data Source

The project utilizes publicly available NHTSA data in the `accident` data file which can be found in the [FARS 2019 National zip file](https://static.nhtsa.gov/nhtsa/downloads/FARS/2019/National/FARS2019NationalCSV.zip). 

The [FARS user manual](https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813417#page=12) describes the `accident` data file as containing information about crash characteristics and environmental conditions at the time of the crash.  There is one record per crash in this dataset. [Additional information about the raw data elements in `accident` file.](https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813417#page=32)

The FARS user manual defines the `ST_CASE` data element as a [case identifier unique to each row](https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813417#page=38). 

The analysis will also utilize publicly available United States population census data available for download at [data.census.gov](https://data.census.gov/table?q=population&g=010XX00US$0600000&tid=DECENNIALPL2020.P1).

<br>

***
***

<br>

## Data Preparation & Cleaning

Tools utilized for ***NHTSA Accident data*** [preparation](/data_prep.md#-preparation) and [cleaning](/data_prep.md#-cleaning) include Microsoft Excel and PostgreSQL. Initial examination and necessary alterations of the data elements were performed with Excel in order to extract the appropriate information to upload into a PostgreSQL database with accuracy.

The same tools were utilized and intitial examinations performed during [preparation](/data_prep.md#-preparation-1) and [cleaning](/data_prep.md#-cleaning-1) of the ***U.S. Census dataset***.

<br>

***
***

<br>

# Analysis
Analysis was performed on a dataset containing **33,487** NHTSA fatal accident records; each record represents one accident in which at least one fatality occurred.  These accidents resulted in almost [100](/analysis.md#%E2%84%B9%EF%B8%8F-total-number-of-accidents-and-resulting-fatalities) fatalities per day - a total of **36,355** for the year.



### Over the Year
Examination of [how traffic fatalities were distributed over the year](/analysis.md#%E2%84%B9%EF%B8%8F-accident-fatalities-per-month) reveals that the summer months **July, August,** and **September** had the ***most*** fatalities, and the winter months **January, February,** and **March** had the ***least***. The month with the most fatalities - **August** - had ***40%*** more fatalities than the month with the least - **February**.

Inspection of the number of fatalities that occurred [over the course of the average week](/analysis.md#%E2%84%B9%EF%B8%8F-accident-fatalities-by-day-of-week) reveals that most accident fatalities occurred on a ***Saturday***, followed by ***Friday*** and ***Sunday***. 

When examining the time of accident occurrences, a list constructed from the [ranked hours of the week by most fatalities in descending order](/analysis.md#%E2%84%B9%EF%B8%8F-accident-fatalities-by-hour-and-day-of-week) results in the first 24 entries being either **Friday, Saturday,** or **Sunday**, and ***8*** of the ***top 10*** individually most fatal hours fall between the hours of **6PM Saturday** and **3AM Sunday**.

<br>

### Location
The dataset also contains the variable `rural_urban`, of which the setting where an accident took place - `RURAL` or `URBAN` was recorded. [An examination of this variable in relation to the number of fatatalities](/analysis.md#%E2%84%B9%EF%B8%8F-rural--urban-accident-fatalities) provides further information about how the population density combined with other factors affected total fatality rates.


There is substantial variance for the times during the week at which most fatalities occurred in [urban vs. rural](/analysis.md#%E2%84%B9%EF%B8%8F-ten-most-fatal-hours-of-the-week-for-rural--urban-areas) settings. The three individual hours during the week at which the most fatalities occurred in ***rural*** settings were, in descending order, **Fridays** at **3:00 PM**, **Saturdays** at **3:00 PM**, and **Saturdays** at **7:00 PM.** In contrast, most fatal times in ***urban*** settings were **Sundays** at **2:00 AM**, **Saturdays** at **9:00 PM**, and **Sundays** at **1:00 AM.**

Another rural vs. urban setting comparison can be made with how light conditions at the time of the accident contributed to the total fatality distribution.

Each accident record has a `light_condition` variable at which the lighting condition at the time of each accident, if known, was recorded. Without regard to population desnsity, [initial analysis of the recorded lighting conditions](/analysis.md#%E2%84%B9%EF%B8%8F-accident-fatalities-by-light-condition), `DAYLIGHT` and `DARK` were split evenly - about ***48%*** each of the total accident fatalities, and the remaining amount was closely divided between `DAWN` and `DUSK` - about ***2%*** each.

[When considering the light condition in reference to population density and the `rural_urban` variable](/analysis.md#%E2%84%B9%EF%B8%8F-rural--urban-accident-fatalities-comparison-by-light-condition), the total number of accident fatalities in a `RURAL` setting had **55%** occur in `DAYLIGHT` and **40%** occur in `DARK`. The remaining **5%** was split closely between `DAWN` and `DUSK`. This distribution was reversed in an `URBAN` setting - **55%** occured after dark and **40%** occurred during the day.

<br>

### Population
The three states with the highest populations in the most recent (2020) census  - California, Texas, and Florida - also had, in corresponding order, the [most traffic accident fatalities over the year in 2019](/analysis.md#%E2%84%B9%EF%B8%8F-most-accident-fatalities-ranked-vs-population). This trend is limited to the top three, though; the fourth and fifth highest fatality rankings, Georgia and North Carlolina, are eighth and ninth in population size, and the remaining state fatality rankings are similarly only vaguely proximally related to their corresponding population. Out of all 50 states and Washington, D.C., **Massachusetts** had the highest disparity between rankings (in descending order) of total population - **15th** - and accident fatalities - **32nd**. **Mississippi** had the second highest disparity but in the opposite direction, **34th** and **20th**, respectively.


Additional information regarding accident fatallities and population can be examined by comparing the [number of fatalities per 100,000 residents](/analysis.md#%E2%84%B9%EF%B8%8F-accident-fatalities-per-100000-residents) in a state. This calculation reveals that the least populous state - **Wyoming** - had **25.5** fataliites per 100,000 residents - the ***most*** of any state and **17.5%** more than the next most on the list. The **District of Columbia** had the ***least*** - **3.3**.

<br>

***
***

<br>

# Conclusion

* In 2019, most accidents that resulted in fatalities in the U.S. occurred during the summer months and on the weekends. 

* Rural and urban settings trended differently with when accident fatalities commonly occurred; rural settings had more early afternoon accidents, and urban settings had more late evening accidents. 

* While areas with high population densities had higher numbers of total accident fatalities that occurred, many states with lower population densities had higher numbers of accident fatalities with relation to total population.

Additional conlcusions might be drawn from further analysis into where and when accident fatalities happened as explored in this dataset with the addition of supplemental datasets that contain survey details of how and when people use their vehicles, additional geographic information of accidents, or climatological data.









