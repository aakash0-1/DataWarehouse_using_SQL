-----------------------------------------------------------------------------------
If OBJECT_ID ('bronze.crm_cust_info', 'U') is not null 
	drop table bronze.crm_cust_info;
Create table bronze.crm_cust_info (
	cdt_id				int,
	cst_key				varchar(50),
	cst_firstname		varchar(50),
	cst_lastname		varchar(50),
	cst_marital_status	varchar(50),
	cst_gndr			varchar(50),
	cst_create_date		Date );

If OBJECT_ID ('bronze.crm_prd_info', 'U') is not null 
	drop table bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);


If OBJECT_ID ('bronze.crm_sales_details', 'U') is not null 
	drop table bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

If OBJECT_ID ('bronze.erp_loc_a101', 'U') is not null
	drop table bronze.erp_loc_a101
CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50)
);

If OBJECT_ID ('bronze.erp_cust_az12', 'U') is not null
	drop table bronze.erp_cust_az12
CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50)
);


If OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') is not null
	drop table bronze.erp_px_cat_g1v2
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);

--------------------------------------------------------------------------------

Create or Alter Procedure bronze.load_bronze AS
begin

	Truncate Table bronze.crm_cust_info;
	Bulk insert bronze.crm_cust_info
	FROM 'C:\Users\Aakash\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	With (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);


	Truncate Table bronze.crm_prd_info;
	Bulk insert bronze.crm_prd_info
	FROM 'C:\Users\Aakash\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	With (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

	Truncate Table bronze.crm_sales_details;
	Bulk insert bronze.crm_sales_details
	FROM 'C:\Users\Aakash\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	With (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);


	Truncate Table bronze.erp_cust_az12;
	Bulk insert bronze.erp_cust_az12
	FROM 'C:\Users\Aakash\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	With (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

	Truncate Table bronze.erp_loc_a101;
	Bulk insert bronze.erp_loc_a101
	FROM 'C:\Users\Aakash\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	With (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

	Truncate Table bronze.erp_px_cat_g1v2;
	Bulk insert bronze.erp_px_cat_g1v2
	FROM 'C:\Users\Aakash\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	With (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
End

Exec bronze.load_bronze

Exec bronze.load_bronze
