# Scenario
After a company wide inventory count, a computer hardware company is left with an inventory dataset that includes product details such as part numbers, descriptions, and location information.  The products are distributed among its multiple international warehouses.

The company stakeholders request a summary of the inventory dataset that includes the following:

* confirmation that the inventory dataset includes all products and warehouses
* total product *count* and *value*
	* company-wide
	* at each warehouse
* total product *count* and *value* of **each product category**
	* company-wide
	* at each warehouse
* product with **_highest gross value_**
	* company-wide
	* at each warehouse
* **_most_** and **_least profitable_**  product
	* at each warehouse

<br><br>


# Data 
The mock dataset used in this analysis was sourced from this [retail store computer hardware inventory dataset](https://www.kaggle.com/datasets/ivanchvez/hardwarestore?select=hardwareStore.csv). The dataset was downloaded to local storage before data preparation took place utilizing Microsoft Excel and PostgreSQL. Data preparation included initial [inspection and upload](/hardware_store/data_prep.md#preparation) of the dataset to a table in a newly created database, [normalizing the database](/hardware_store/data_prep.md#normalization) to ensure data integrity and avoid redundancy, and [cleaning](/hardware_store/data_prep.md#cleaning) the data.

<!-- perform analysis using sql -->
# Analysis Summary



<!-- create interactive dashboard w/ tableau -->
