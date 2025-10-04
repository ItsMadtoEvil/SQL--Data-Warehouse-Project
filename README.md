# Data Warehouse and Analytics Project 🚀  

Welcome to the **Data Warehouse and Analytics Project**!  
This project demonstrates how to design and implement a **modern data warehousing and analytics solution** using **SQL Server**, covering everything from raw data ingestion to actionable business insights.  

It is designed as a **portfolio project** to highlight **industry best practices** in **data engineering, data modeling, ETL, and analytics**.  

---

## 🏗️ Data Architecture  

This project follows the **Medallion Architecture** (Bronze, Silver, Gold):  

- **Bronze Layer** → Stores raw data exactly as ingested from source systems (CSV files → SQL Server).  
- **Silver Layer** → Cleansed, standardized, and normalized data ready for transformation.  
- **Gold Layer** → Business-ready data modeled into **star schema** for reporting and analytics.  

![Data Architecture](docs/data_architecture.png)  

---

## 📖 Project Overview  

This project demonstrates:  

- **Data Architecture**: Designing a modern warehouse using Bronze, Silver, and Gold layers.  
- **ETL Pipelines**: Loading, cleaning, and transforming raw data into structured models.  
- **Data Modeling**: Creating fact and dimension tables optimized for analytics.  
- **Analytics & Reporting**: Writing SQL queries to generate key insights.  

---

## 🎯 Skills Demonstrated  

✔️ SQL Development  
✔️ Data Warehousing & ETL  
✔️ Star Schema & Dimensional Modeling  
✔️ Data Integration (ERP + CRM)  
✔️ SQL Analytics & Optimization  
✔️ BI Reporting (SQL queries, Power BI-ready data)  

---

## 🚀 Project Requirements  

### 1. Data Engineering (Warehouse)  
**Objective**: Build a SQL Server Data Warehouse for consolidated sales data.  

- **Sources**: Import ERP + CRM data (CSV files).  
- **Data Quality**: Cleanse duplicates, missing values, and standardize attributes.  
- **Integration**: Merge both sources into a single data model.  
- **Scope**: Focus on latest dataset (no historization).  
- **Documentation**: Provide data catalog, architecture, and model diagrams.  

### 2. Analytics & Reporting  
**Objective**: Use SQL queries to answer business questions on:  

- **Customer Behavior** (spend, loyalty, repeat purchases)  
- **Product Performance** (top sellers, slow movers)  
- **Sales Trends** (growth, seasonality, revenue insights)  

---

## 📊 Example Analytics Queries  

```sql
-- Top 10 Customers by Spend
SELECT c.CustomerName, SUM(f.ExtendedAmount) AS TotalSpend
FROM fact.Sales f
JOIN dim.Customer c ON f.CustomerSK = c.CustomerSK
GROUP BY c.CustomerName
ORDER BY TotalSpend DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Monthly Sales Trends
SELECT YEAR(f.InvoiceDate) AS Yr, MONTH(f.InvoiceDate) AS Mo,
       SUM(f.ExtendedAmount) AS MonthlySales
FROM fact.Sales f
GROUP BY YEAR(f.InvoiceDate), MONTH(f.InvoiceDate)
ORDER BY Yr, Mo;
