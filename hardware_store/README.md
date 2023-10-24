# Scenario
After a company wide inventory count, a computer hardware company is left with a dataset that includes product details such as part numbers, descriptions, location information, and quantity counted.  The products are distributed among its multiple international warehouses.

The company stakeholders request a summary of the inventory dataset that includes the following figures with relation to the company as a whole and each individual warehouse:

* total product *count* and *value*
* total product *count* and *value* of **each product category**
* product with **_highest gross value_**
* **_most_** and **_least profitable_**  product

<br><br>


# Data 
The mock dataset used in this analysis was sourced from this [retail store computer hardware inventory dataset](https://www.kaggle.com/datasets/ivanchvez/hardwarestore?select=hardwareStore.csv). The dataset was downloaded to local storage before data preparation took place utilizing Microsoft Excel and PostgreSQL. Data preparation included initial [inspection and upload](/hardware_store/data_prep.md#preparation) of the dataset to a table in a newly created database, [normalizing the database](/hardware_store/data_prep.md#normalization) to ensure data integrity and avoid redundancy, and [cleaning](/hardware_store/data_prep.md#cleaning) the data.

<!-- perform analysis using sql -->
# Summary
The company inventory includes [208 unique products with a total of almost 120,000 pieces](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-company-wide) located in 9 warehouses. The total product cost amounts to $85 million USD with a list value of $107 million. 

The **San Francisco warehouse** holds the most inventory - [over 28,000 pieces with a total list value of over $23 million](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-at-each-warehouse). This is about **22%** of the gross value of all products.

The **storage** category of products has the most items - [47,000 pieces with a total list value of $27 million](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-company-wide-1). But the **video card** category has fewer items - 39,000 - and a list value of almost double that of storage - $50 million. [Video card products have highest gross asset value at almost every warehouse](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-at-each-warehouse-1) and have the _highest_ share of gross asset value at the **Southlake warehouse** with **98%** of gross product value there.

[Three of the top 5 highest priced company products are video cards](), but a storage product - the _Intel SSDPECME040T401_ - is the number one highest priced item - listed at over $8,000.00 - and is 60% more expensive than the next highest priced item.


<!-- create interactive dashboard w/ tableau -->
