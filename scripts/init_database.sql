/*
=============================================================
Create Database and Schemas
=============================================================
/*

Use Master;

-- Create the 'DataWarehouse' database

Create Database Data_Warehouse;

Use Data_Warehouse;

-- Create the schemas
Create Schema Bronze;
GO
Create schema Silver;
GO
Create schema Gold;
GO

