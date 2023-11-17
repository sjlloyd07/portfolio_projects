# Office Superstore Sales Trend Analysis

### In 2015, the business stakeholders at an office supply super store want to know how they should plan their resources for the future by examining the previous years' sales records.

<br>

The stakeholders request the following information with which they'll use to make decisions:
* What times of year had the most sales?
* What segment had the most/least growth?
* What product category had the most sales?
* What was the most profitable category/subcategory of products?
* What were the top selling products?

<br>

## Data 
The data was taken from this [kaggle dataset](https://www.kaggle.com/datasets/ishanshrivastava28/superstore-sales) that consists of mock superstore sales transaction records taken from 2011 to 2014.

The data was confirmed to be complete and consistent during [cleaning and preparation](/superstore_sales/cleaning.md).

<br><br>

## Analysis
### What times of year had the most sales?

**September, November,** and **December** were the *highest* selling months in every year.  

**March** was fourth highest in **2011** and **2012**, and then fell behind **October** in **2013** and **2014.**

<br>

![monthly_sales](/superstore_sales/images/montly_sales.PNG)

[⏯️ **Go to Animated Sales Dashboard**](/superstore_sales/.README.md#Sales-Dashboard---Years)

<br><br>

### What segment had the most/least growth?

Both the **Corporate** and **Home Office** segments had significant growth between **2012** and **2014** after having either no and negative growth from **2011** to **2012.**  

Similarly, the **Consumer** segment had almost no growth from **2011** to **2012,** but has had steadily increasing sales since **2012.**

<br>

![segment_sales](/superstore_sales/images/segment_sales.PNG)

<br><br>

### What product category had the most sales?

#### Consumer
Product category sales varied little over the timeline, and 2014 sales are only slightly above 2011 sales.  

The most significant variations occurred when **technology** sales *increased 20%* from 2012 to 2013 and **office supplies** sales *increased 30%* from 2013 to 2014.

Both **corporate** and **home office** sales varied drastically in comparison to **consumer** sales.

<br>

#### Corporate
From 2011 to 2012, **furniture** had little growth while **technology** sales *increase 40%*, and inversely, **office supplies** *dropped 30%*. 

**All category** sales *increased over 50%* into 2013.  

**Office supplies** *increase another 70%* into 2014, **technology** over *15%*, and **furniture** sales *dropped 20%* from 2013.

<br>

#### Home Office
**Furniture** and **office supplies** both *increased over 15%* from 2011 to 2012, while **technology** sales *decreased 50%* during this time.  

Going into 2013, sales for **furniture** *decreased 30%*, **office supplies** continued to *grow over 90%*, and **techonolgy** rebounded with *80% growth*.  

**Technology** sales continued to *grow more than 80%* into 2014 along with **furniture** sales that *increased more than 100%*. **Office supplies** *decreased slightly*.

<br>

![category_sales](/superstore_sales/images/category_sales.PNG)

 [⏯️ **Go to Sales Dashboard**](/superstore_sales/.README.md#Sales-Dashboard---Segment)

<br><br>

### What was the most profitable category/subcategory of products?
Products in the technology category were the most profitable over the timeline, and copiers were the most profitable sub-category of products within that followed by phones and accessories. This was true with regards to every segment.  

The least profitable products by far were tables in the furniture category with negative profits of almost $20000.

<br>

![profits](/superstore_sales/images/profits.PNG)

<br>

### Best Selling Products
The highest selling product from 2011 to 2014 was a **Canon brand copier** of which all of its sales occurred in 2013 and 2014.

<br>

![best_selling](/superstore_sales/images/best_selling.PNG)

<br>

## Conclusion
The consumer segment made up just over half of all sales during this time period, followed by corporate and home office.

<br>

**Observation:**  
* While sales in every segment increased toward the end of the year starting in September, sales in the consumer segment spiked most drastically at this time before dropping in October and then raising again in November and December.  
* I suspect this increase might be due to consumers being more likely to take advantage of Labor Day and Back to School sales during this time. 

**Recommendations:**  
* Target new customers during this time of increased traffic.
* Run limited promotions for customers to incentivize return with limited time offers to increase October sales.

<br><br>

**Observation:**  
* Sales increase at the end of the year and drop significantly in the new year and are at their lowest in Februrary.

**Recommendations:**  
* Run promotional discounts for holiday customers to incentivize return in the new year.

<br><br>

**Observation:**  
* Corporate furniture sales dropped and office supplies sales raised sharply going into 2014. The inverse happened for home office furniture and office supplies sales.

**Recommendations:**  
* Run promotional discounts targeting corporate customers for furniture and home office customers for office supplies.

<br><br>

**Observation:**  
* Tables have a negative profit margin.

**Recommendations:**  
* Identify lowest table model sales and reduce inventory.
* Run additional promotions focused on tables.


<br><br>

## Sales Dashboard - Years
![sales_dash_years](/superstore_sales/images/year_sales_dash.gif)

<br>

## Sales Dashboard - Segment
![sales_dash_segment](/superstore_sales/images/segment_sales_dah.gif)
