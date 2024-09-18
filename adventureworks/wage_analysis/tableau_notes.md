# AdventureWorks Wage Analysis Tableau Dashboard


### MinWageImpactBar
Bar chart w/ number of affected employees and increased wage totals.
* Dims: departments
* Measures: dollar impact of min wage, employee count below min wage


parameters:
* company min Wage
* months of service

Calculated fields:
* ! emp_id: Wage < Min Wage
	
	// Checks if wage is less than min wage param
	IF [Hourly Wage] < [Company Min Wage]
	THEN [Emp Id]
	ELSE NULL
	END


* !Wage CNT Label Zero to NULL

	// Turns 0 value NULL for labeling
	IF COUNT([! emp_id: Wage < Min Wage]) = 0
	THEN NULL
	ELSE COUNT([! emp_id: Wage < Min Wage])
	END

	
* ! hourly_wage: Wage < Min Wage

	// Checks if wage is less than min wage param
	IF [Hourly Wage] < [Company Min Wage]
	THEN [Hourly Wage]
	ELSE NULL
	END
	
	
* !Wage SUM Label Zero to NULL

	// Turns 0 value NULL for labeling
	IF SUM([! hourly_wage: Wage < Min Wage]) = 0
	THEN NULL
	ELSE SUM([! hourly_wage: Wage < Min Wage])*40
	END
	
	
	