# Computer Hardware Store Inventory Analysis
### Overview
After a company wide inventory count, a computer hardware company is left with a single file that includes product details such as part numbers, descriptions, location, and quantity.  The products are distributed among its multiple international warehouses.

The company stakeholders request a summary of the inventory dataset that includes the devlierables below for the company overall and warehouses.

<br>

### Deliverables
* Total product ***count*** and ***value*** overall and grouped by product category.
* ***Highest priced*** products.
* Products with the ***highest gross values***.
* ***Most profitable***  products.

<br>


### Tools
*  PostgreSQL (PgAdmnin4)
*  Microsoft Excel

--- 

<br>

## Table of Contents
### ▫️ [Data](https://github.com/sjlloyd07/portfolio_projects/tree/main/hardware_store#data)
### ▫️ [Analysis & Deliverables](https://github.com/sjlloyd07/portfolio_projects/tree/main/hardware_store#inventory-analysis--deliverables)

<br>

---

<br>

# Data 
The mock dataset used in this analysis was sourced from this [retail store computer hardware inventory dataset](https://www.kaggle.com/datasets/ivanchvez/hardwarestore?select=hardwareStore.csv). 

A complete list of data preparation steps can be found [here](hardware_store/data_prep.md) and included the following:
-  [inspection and upload](/hardware_store/data_prep.md#inspection-and-upload) of the dataset to a table in a newly created database
-  [normalizing the database](/hardware_store/data_prep.md#normalization) to ensure data integrity and avoid redundancy
-  [cleaning](/hardware_store/data_prep.md#cleaning) the data

<br>

<!-- perform analysis using sql -->
# Inventory Analysis & Deliverables
### Count and Value
The company inventory includes [208 unique products with a total of almost 120,000 pieces](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-company-wide) located in [9 warehouses](/hardware_store/data_prep.md#table-warehouse).

The total product cost amounts to _**$85 million USD**_ with a list value of _**$107 million**_. 

Of the 9 warehouses located in 6 countries, the **San Francisco warehouse** holds the most inventory - [over 28,000 pieces with a total list value of over $23 million](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-at-each-warehouse). 

The gross product value at the **San Francisco warehouse** is about **22%** of the gross value of all company inventory.

The **storage** category of products has the most items - [47,000 pieces with a total list value of $27 million](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-company-wide-1). But the **video card** category has fewer items - 39,000 - and a list value of almost double that of storage - $50 million. 

<br>

### Highest Priced
[Three of the top 5 highest priced company products are video cards](/hardware_store/analysis.md#highest-priced-company-products), but a storage product - the _Intel SSDPECME040T401_ - is the _number one highest priced item_ - listed at over $8,000.00 - and is 60% more expensive than the next highest priced item.

<br>

### Gross Value
[Video card products have highest gross asset value at almost every warehouse](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-at-each-warehouse-1) and have the _highest_ share of gross asset value at the **Southlake warehouse** with **98%** of the product value there.

[Video cards represent nine of the top 10 products with the highest gross inventory values.](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-company-wide-top-10) 

The product with the highest gross inventory value is the **PNY VCQM6000-PB video card** with over _1,400_ in stock valued at almost _$4.6 million._ 

The product with the [highest gross inventory value at each warehouse](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-at-each-warehouse-2) is one of the top 3 products on this list.

<br>

The following are products with the highest gross value in each category:

| category     | product                          | gross_product_qty | gross_product_value |
|--------------|----------------------------------|-------------------|---------------------|
| Video Card   | PNY VCQM6000-PB                  | 1413              | $   4,599,301       |
| Storage      | Intel SSDPECME040T401            | 360               | $   3,192,476       |
| CPU          | Intel Xeon E5-2699 V4 (OEM/Tray) | 846               | $   1,485,576       |
| Mother Board | Supermicro X10SDV-8C-TLN4F       | 825               | $     782,917       |

<br>
<br>

### Most Profitable
Products with both the [*highest and lowest net profit per unit*](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-highest--lowest-product-net-profit-by-category) are in the **storage** category.

| category     | product_net_profit_highest       | profit_per_unit  | product_net_profit_lowest   | profit_per_unit-2 |
|--------------|----------------------------------|------------------|-----------------------------|-------------------|
| Storage      | Intel SSDPECME040T401            | $       1,744.33 | Western Digital WD2500AAJS  | $           1.76  |
| Video Card   | PNY VCQP6000-PB                  | $       1,441.00 | MSI GTX 1080 TI AERO 11G OC | $          82.54  |
| CPU          | Intel Xeon E5-2699 V3 (OEM/Tray) | $         542.95 | Intel Xeon E5-2640 V2       | $          63.76  |
| Mother Board | Supermicro X10SDV-8C-TLN4F       | $         284.70 | Asus VANGUARD B85           | $          28.90  |

<br>

However, products with both the [*highest and lowest rate of return*](/hardware_store/analysis.md#%E2%84%B9%EF%B8%8F-highest--lowest-product-rate-of-return-by-category) are motherboards.


| category     | product_id | product_ror_hi             | rate_of_return | product_id-2 | product_ror_lo              | rate_of_return-2 |
|--------------|------------|----------------------------|----------------|--------------|-----------------------------|------------------|
| CPU          | 80         | Intel Xeon E5-1650 V3      | 41.30 %        | 163          | Intel Xeon E5-2683 V4       | 11.31 %          |
| Mother Board | 190        | Supermicro X10SDV-8C-TLN4F | 42.86 %        | 145          | Asus VANGUARD B85           | 11.20 %          |
| Storage      | 30         | G.Skill Ripjaws V Series   | 42.57 %        | 14           | G.Skill Ripjaws V Series    | 11.26 %          |
| Video Card   | 238        | EVGA 06G-P4-4998-KR        | 42.37 %        | 174          | MSI GTX 1080 TI AERO 11G OC | 11.53 %          |

<br>

* The motherboard _Supermicro X10SDV-8C-TLN4F_ is the most profitable product at **5 out of 9 warehouses** with a rate of return of **42.9%**.
* The storage unit _Corsair Vengeance LPX_ - RoR **42.4%** - and video card _Zotac ZT-P10810C-10P_ - RoR **42.0%** - are the most profitable products at 2 each of the remaining 4 warehouses. 

Overall, the [video card product category is the most profitable](/hardware_store/analysis.md#average-gross-profit-and-rate-of-return-by-category) with the highest average rate of return - **_26.1%_** - followed by storage - **_25.7%_**.
