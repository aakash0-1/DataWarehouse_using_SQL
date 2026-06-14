# Data Warehouse Project – Medallion Architecture using SQL
## Overview
This project demonstrates the implementation of a modern Data Warehouse using the Medallion Architecture (Bronze → Silver → Gold) approach in Microsoft SQL Server.
The solution integrates data from multiple CRM and ERP source systems, applies data cleansing and transformation logic, and delivers a business-ready dimensional model for analytics and reporting.

The project showcases key Data Engineering and Data Warehousing concepts including:

•	ETL Development
•	Data Quality Management
•	Data Cleansing & Standardization
•	Dimensional Modeling (Star Schema)
•	Fact and Dimension Design
•	Medallion Architecture Implementation


## Architecture
                Source Systems
          ┌──────────────────────┐
          │ CRM Data             │
          │ ERP Data             │
          └──────────┬───────────┘
                     │
                     ▼
        ┌─────────────────────────┐
        │ Bronze Layer (Raw Data) │
        └──────────┬──────────────┘
                   │
                   ▼
      ┌─────────────────────────────┐
      │ Silver Layer (Cleaned Data) │
      └──────────┬──────────────────┘
                 │
                 ▼
      ┌─────────────────────────────┐
      │ Gold Layer (Business Model) │
      └──────────┬──────────────────┘
                 │
                 ▼
          Reporting & Analytics

## Technologies Used

•	Microsoft SQL Server
•	T-SQL
•	SQL Server Management Studio (SSMS)
•	Data Warehousing
•	ETL Development
•	Medallion Architecture
•	Dimensional Modeling

