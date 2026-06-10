/*
=============================================================
Create Database and Schemas
=============================================================
*/

--Create Database

Use Master;
Create Database Data_Warehouse;
Use Data_Warehouse;

-- Create schema

Create Schema Bronze;
GO
Create schema Silver;
GO
Create schema Gold;
GO

