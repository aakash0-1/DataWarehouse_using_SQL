	If OBJECT_ID (' silver.crm_cust_info', 'U') is not null 
		drop table  silver.crm_cust_info;
	Create table  silver.crm_cust_info (
		cdt_id				int,
		cst_key				varchar(50),
		cst_firstname		varchar(50),
		cst_lastname		varchar(50),
		cst_marital_status	varchar(50),
		cst_gndr			varchar(50),
		cst_create_date		Date,
		dwh_created_date Datetime2 default getdate());

	If OBJECT_ID (' silver.crm_prd_info', 'U') is not null 
		drop table  silver.crm_prd_info;
	CREATE TABLE  silver.crm_prd_info (
		prd_id       INT,
		cat_id       NVARCHAR(50),
		prd_key      NVARCHAR(50),
		prd_nm       NVARCHAR(50),
		prd_cost     INT,
		prd_line     NVARCHAR(50),
		prd_start_dt DATETIME,
		prd_end_dt   DATETIME,
		dwh_created_date Datetime2 default getdate()
);


	If OBJECT_ID (' silver.crm_sales_details', 'U') is not null 
		drop table  silver.crm_sales_details;
	CREATE TABLE  silver.crm_sales_details (
		sls_ord_num  NVARCHAR(50),
		sls_prd_key  NVARCHAR(50),
		sls_cust_id  INT,
		sls_order_dt DATE,
		sls_ship_dt  DATE,
		sls_due_dt   DATE,
		sls_sales    INT,
		sls_quantity INT,
		sls_price    INT,
		dwh_created_date Datetime2 default getdate()
		);

	If OBJECT_ID (' silver.erp_loc_a101', 'U') is not null
		drop table  silver.erp_loc_a101
	CREATE TABLE  silver.erp_loc_a101 (
		cid    NVARCHAR(50),
		cntry  NVARCHAR(50),
		dwh_created_date Datetime2 default getdate()
	);

	If OBJECT_ID (' silver.erp_cust_az12', 'U') is not null
		drop table  silver.erp_cust_az12
	CREATE TABLE  silver.erp_cust_az12 (
		cid    NVARCHAR(50),
		bdate  DATE,
		gen    NVARCHAR(50),
		dwh_created_date Datetime2 default getdate()
	);


	If OBJECT_ID (' silver.erp_px_cat_g1v2', 'U') is not null
		drop table  silver.erp_px_cat_g1v2
	CREATE TABLE  silver.erp_px_cat_g1v2 (
		id           NVARCHAR(50),
		cat          NVARCHAR(50),
		subcat       NVARCHAR(50),
		maintenance  NVARCHAR(50),
		dwh_created_date Datetime2 default getdate()
	);

----------------------------------------------------------------------------------------------------------------------------

-- Cleaning the bronze level cust info and uploading into silver layer 

CREATE OR ALTER PROCEDURE silver.load_silver AS
begin

	TRUNCATE TABLE silver.crm_cust_info;
	Insert into Silver.crm_cust_info (
			cdt_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date )

	Select  cdt_id,
			cst_key,
			Trim(cst_firstname) as cst_firstname,
			Trim(cst_lastname) as cst_lastname,
			Case when Upper(Trim(cst_marital_status)) = 'S' Then 'Single'
				 when upper(Trim(cst_marital_status)) = 'M' then 'Married'
				 Else 'N/A'
			END cst_marital_status,
			Case when upper(Trim(cst_gndr)) = 'M' Then 'Male'
				 when upper(Trim(cst_gndr)) ='F' Then 'Female'
				 Else 'N/A'
			End cst_gndr,
			cst_create_date
	from (
		Select * ,
		ROW_NUMBER() OVER(
		PARTITION BY cdt_id ORDER BY cst_create_date DESC) as flag
		from Bronze.crm_cust_info
		where cdt_id is not null
		) as t 
	where flag = 1


	Select * from Silver.crm_cust_info

	----------------------------------------------------------------------------------------

	-- Cleaning the bronze level product info and uploading into silver layer 

	TRUNCATE TABLE silver.crm_prd_info;
	INSERT INTO silver.crm_prd_info (
				prd_id,
				cat_id,
				prd_key,
				prd_nm,
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt
			)

	Select  prd_id,
			Replace(SUBSTRING( prd_key, 1 , 5), '-', '_') as cat_id,
			Replace(SUBSTRING( prd_key, 7 , Len(prd_key)), '-', '_') as prd_key,
			prd_nm,
			ISNULL(prd_cost, 0) as prd_cost,
			CASE 
					WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
					WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
					WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
					WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
					ELSE 'n/a'
				END AS prd_line,
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(
				LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE
				) AS prd_end_dt
	from Bronze.crm_prd_info

	----------------------------------------------------------------------------------------------------

	-- Cleaning the bronze level sales details and uploading into silver layer

	TRUNCATE TABLE silver.crm_sales_details;
	INSERT INTO silver.crm_sales_details (
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price
			)

			SELECT 
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				CASE 
					WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
				END AS sls_order_dt,
				CASE 
					WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
				END AS sls_ship_dt,
				CASE 
					WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
				END AS sls_due_dt,
				CASE 
					WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
						THEN sls_quantity * ABS(sls_price)
					ELSE sls_sales
				END AS sls_sales, 
				sls_quantity,
				CASE 
					WHEN sls_price IS NULL OR sls_price <= 0 
						THEN sls_sales / NULLIF(sls_quantity, 0)
					ELSE sls_price  
				END AS sls_price
			FROM bronze.crm_sales_details;

	----------------------------------------------------------------------------------------------------

	-- Cleaning the bronze level erp cust info and uploading into silver layer
	TRUNCATE TABLE silver.erp_cust_az12;
	INSERT INTO silver.erp_cust_az12 (
				cid,
				bdate,
				gen
			)

			SELECT
				CASE
					WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
					ELSE cid
				END AS cid, 
				CASE
					WHEN bdate > GETDATE() THEN NULL
					ELSE bdate
				END AS bdate, -- Set future birthdates to NULL
				CASE
					WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
					WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
					ELSE 'n/a'
				END AS gen 
			FROM bronze.erp_cust_az12;

	----------------------------------------------------------------------------------------------------

	-- Cleaning the bronze level erp cust loc info and uploading into silver layer

	TRUNCATE TABLE silver.erp_loc_a101;
	INSERT INTO silver.erp_loc_a101 (
				cid,
				cntry
			)

			SELECT
				REPLACE(cid, '-', '') AS cid, 
				CASE
					WHEN TRIM(cntry) = 'DE' THEN 'Germany'
					WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
					WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
					ELSE TRIM(cntry)
				END AS cntry 
			FROM bronze.erp_loc_a101;

	----------------------------------------------------------------------------------------------------

	-- Cleaning the bronze level erp prod info and uploading into silver layer

	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	INSERT INTO silver.erp_px_cat_g1v2 (
				id,
				cat,
				subcat,
				maintenance
			)

			SELECT
				id,
				cat,
				subcat,
				maintenance
			FROM bronze.erp_px_cat_g1v2;
End

Exec Silver.load_silver
