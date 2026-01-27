# Data Catalog – Gold Layer

## Overview
The **Gold Layer** represents business-ready, curated data designed for analytics and reporting.  
It follows a **star schema** approach and consists of **dimension tables** and **fact tables** aligned to business metrics.

---

## 1. gold.dim_customers
**Purpose:**  
Stores customer master data enriched with demographic and geographic attributes for analysis.

### Columns

| Column Name     | Data Type    | Description |
|-----------------|--------------|-------------|
| Customer_Key    | INT          | Surrogate key uniquely identifying each customer record in the dimension table. |
| Customer_Id     | INT          | Business identifier assigned to the customer in the source system. |
| Customer_Number | NVARCHAR(50) | Alphanumeric customer reference used for tracking and reporting. |
| First_Name      | NVARCHAR(50) | Customer’s first name. |
| Last_Name       | NVARCHAR(50) | Customer’s last name or family name. |
| Country         | NVARCHAR(50) | Country of residence (e.g., Australia). |
| Marital_Status  | NVARCHAR(50) | Marital status of the customer (e.g., Married, Single). |
| Gender          | NVARCHAR(50) | Gender of the customer (e.g., Male, Female, n/a). |
| Birthdate       | DATE         | Date of birth in YYYY-MM-DD format. |
| Create_Date     | DATE         | Date when the customer record was created in the system. |

---

## 2. gold.dim_products
**Purpose:**  
Contains product master data with classification and lifecycle attributes.

### Columns

| Column Name           | Data Type    | Description |
|-----------------------|--------------|-------------|
| Product_Key           | INT          | Surrogate key uniquely identifying each product record. |
| Product_Id            | INT          | Business identifier assigned to the product in the source system. |
| Product_Number        | NVARCHAR(50) | Alphanumeric product code used for inventory and categorization. |
| Product_Name          | NVARCHAR(50) | Descriptive product name including key attributes. |
| Category_Id           | NVARCHAR(50) | Identifier representing the product category. |
| Category              | NVARCHAR(50) | High-level product classification (e.g., Bikes, Components). |
| SubCategory           | NVARCHAR(50) | Detailed product classification within the category. |
| Maintenance           | NVARCHAR(50) | Indicates whether the product requires maintenance (Yes/No). |
| Cost                  | INT          | Base cost of the product. |
| Product_Line          | NVARCHAR(50) | Product line or series (e.g., Road, Mountain). |
| Start_Date            | DATE         | Date when the product became available for sale or use. |

---

## 3. gold.fact_sales
**Purpose:**  
Stores transactional sales data at the order-line level for performance and revenue analysis.

### Grain
One row per **product per sales order**.

### Columns

| Column Name     | Data Type    | Description |
|-----------------|--------------|-------------|
| Order_Number    | NVARCHAR(50) | Unique identifier for the sales order (e.g., SO54496). |
| Product_Key     | INT          | Surrogate key referencing gold.dim_products. |
| Customer_Key    | INT          | Surrogate key referencing gold.dim_customers. |
| Order_Date      | DATE         | Date when the order was placed. |
| Shipping_Date   | DATE         | Date when the order was shipped. |
| Due_Date        | DATE         | Date when payment for the order was due. |
| Sales_Amount    | INT          | Total sales value for the line item. |
| Quantity        | INT          | Number of units sold for the line item. |
| Price           | INT          | Unit price of the product at the time of sale. |
