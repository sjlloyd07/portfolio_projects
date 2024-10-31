> find & replace `****` to ```sql [code] ``` in github
> esc w/ #
> 

# AdventureWorks Wage Analysis Tableau Dashboard


## MinWageImpactBar
Bar chart w/ number of affected employees and increased wage totals.
* Dims: departments
* Measures: dollar impact of min wage, employee count below min wage


### Parameters:

* company min Wage
* months of service





### Calculated fields:


* Dollar Impact per Year

// Additional company cost of employee wages if every employee currently earning below minimum wage had their hourly wage increased to the proposed minimum wage.


((([!MoS-MinWage: emp_id CNT]
// multiplied by proposed min wage
* [p Company Min Wage]) 

// subtract sum of current wage
- [!MoS-MinWage: hourly_wage SUM])

// multiplied by hrs/week and weeks/year
*40)*52

		* !MoS-MinWage: emp_id CNT

		// Count emp_ids impacted by both params; returns NULL instead of 0

		IF 
		// If 0, return NULL
		COUNT(
		// Check if months of service >= MoS param
		IF NOT ISNULL([!>= MoS: emp_id])
		// Check if wage < Min Wage param
		THEN [!< MinWage: emp_id]
		ELSE NULL
		END
		) = 0
		THEN NULL
		ELSE
		// If not 0, return count
		COUNT(
		// Check if months of service >= MoS param
		IF NOT ISNULL([!>= MoS: emp_id])
		// Check if wage < Min Wage param
		THEN [!< MinWage: emp_id]
		ELSE NULL
		END
		)
		END


				* !>= MoS: emp_id

				// Checks if months of service >= months of service param

				IF [Months Of Service] >= [p Months of Service]
				THEN [Emp Id]
				ELSE NULL
				END


				* !< MinWage: emp_id

				// Checks if wage is less than min wage param

				IF [Hourly Wage] < [p Company Min Wage]
				THEN [Emp Id]
				ELSE NULL
				END


		* !MoS-MinWage: hourly_wage SUM

		// Sums hourly wages of emp_ids impacted by both params

		SUM(
		// Check if months of service < MoS param
		IF NOT ISNULL([!>= MoS: emp_id])
		// Check if wage < MW param
		THEN [!<MinWage: hourly_wage]
		ELSE NULL
		END)



				* !>= MoS: emp_id

				// Checks if months of service >= months of service param

				IF [Months Of Service] >= [p Months of Service]
				THEN [Emp Id]
				ELSE NULL
				END


				* !<MinWage: hourly_wage

				// Checks wage < min wage param

				IF [Hourly Wage] < [p Company Min Wage]
				THEN [Hourly Wage]
				ELSE NULL
				END






## Version 2
### Using SETs that filter: 
- Emp Ids making less than Min Wage param
- Emp Ids w/ Months of Service greater than or equal to Months of Service Limit param.


- **v2: Yearly Additional Cost After Increase**
```
// Calculates total yearly additional wages to be earned by employees currently earning less than company minimum wage param if minimum was increased to match the param.

(([v2: Hourly Cost: Wage After Increase]-[v2: Hourly Cost: Wage Before Increase])*40)*52
```


		- **v2: Hourly Cost: Wage Before Increase**
		```
		// Calculates total hourly wages of employees earning less than company minimum wage param.

		// If emp_id is in set
		IF MIN([v2: Emp Id < Min Wage])

		// Take the sum of each hourly wage multiplied by the number of employees who make that wage.
		THEN SUM([Hourly Wage]*{FIXED [Emp Id]:COUNT([Hourly Wage])})

		// Else return NULL
		ELSE NULL
		END
		```


		- **v2: Hourly Cost: Wage After Increase**
		```
		// Calculates total hourly wages of employees currently earning less than company minimum wage param if their wage was increased to the company minimum wage param.

		// If emp_id is in set
		IF MIN([v2: Emp Id < Min Wage])

		// Take the sum of company minimum wage param multiplied by the number of employees who currently have an hourly wage less than the company minimum wage param.
		THEN SUM([p Company Min Wage]*{FIXED [Emp Id]:COUNT([Hourly Wage])})

		// Else return NULL
		ELSE NULL
		END
		```


				- **v2: Emp Id < Min Wage SET**
				```
				// T/F: Checks if the hourly wage is less than  the company min wage param
				SUM([Hourly Wage]) < [p Company Min Wage]
				```