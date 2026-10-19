-- check for duplicates in the table
SELECT
    Complaint_ID,
    COUNT(*)
FROM cfpb
GROUP BY Complaint_ID
HAVING COUNT(*) > 1
-- no duplicates found

-- check for null values in the table
SELECT
    COUNT(*)
FROM cfpb
WHERE
    Date_received IS NULL OR
    Product IS NULL OR Product = 'None' OR
    Sub_product IS NULL OR Sub_product = 'None' OR
    Issue IS NULL OR Issue = 'None' OR
    Sub_issue IS NULL OR Sub_issue = 'None' OR
    Consumer_complaint_narrative IS NULL OR Company_public_response = 'None' OR
    Company_public_response IS NULL OR Company_public_response = 'None' OR
    Company IS NULL OR Company = 'None' OR
    State IS NULL OR State = 'None' OR
    Zip_code IS NULL OR Zip_code = 'None' OR
    Tags IS NULL OR Tags = 'None' OR
    Submitted_via IS NULL OR Submitted_via = 'None' OR
    Date_sent_to_company IS NULL OR 
    Company_response_to_consumer IS NULL OR Company_response_to_consumer = 'None' OR
    Timely_response IS NULL OR
    Complaint_ID IS NULL
-- Total 26295 Null or None values found in the table


-- Create view with nessessary columns for analysis
CREATE OR REPLACE VIEW cfpb_analysis AS
SELECT
    complaint_id,
    date_received,
    product,
    issue,
    company,
    timely_response,
    state
FROM cfpb;

-- checking where null values are located in the table
SELECT
    SUM(CASE WHEN date_received IS NULL THEN 1 ELSE 0 END) AS date_received_nulls,
    SUM(CASE WHEN product IS NULL OR product = 'None' THEN 1 ELSE 0 END) AS product_nulls,
    SUM(CASE WHEN issue IS NULL OR issue = 'None' THEN 1 ELSE 0 END) AS issue_nulls,
    SUM(CASE WHEN company IS NULL OR company = 'None' THEN 1 ELSE 0 END) AS company_nulls,
    SUM(CASE WHEN timely_response IS NULL THEN 1 ELSE 0 END) AS timely_response_nulls,
    SUM(CASE WHEN state IS NULL OR state = 'None' THEN 1 ELSE 0 END) AS state_nulls
FROM cfpb_analysis
-- 1 issue and 273 state null values found in the table



SELECT
    *
FROM cfpb_analysis
LIMIT 10

-- Checking for duplicates complaint_id
SELECT
    complaint_id,
    COUNT(*)
FROM cfpb_analysis
GROUP BY complaint_id
HAVING COUNT(*) > 1

-- Date range for data
SELECT
    MIN(date_received) AS min_date,
    MAX(date_received) AS max_date
FROM cfpb_analysis
-- 2 years of data from 2023-01-01 to 2025-01-01

-- product
SELECT
    product,
    COUNT(*) AS product_count
FROM cfpb_analysis
GROUP BY product
ORDER BY product_count 


-- issue
SELECT
    issue,
    COUNT(*) AS issue_count
FROM cfpb_analysis
GROUP BY issue
ORDER BY issue_count 

-- company
SELECT
    company,
    COUNT(*) AS company_count
FROM cfpb_analysis
GROUP BY company
ORDER BY company_count DESC

-- timely response
SELECT
    timely_response,
    COUNT(*) AS timely_response_count
FROM cfpb_analysis
GROUP BY timely_response


-- state
WITH chad AS(
SELECT
    state,
    CASE WHEN state = 'None' THEN 'Unkown'
    WHEN state IN ('GU', 'PR', 'VI', 'UNITED STATES MINOR OUTLYING ISLANDS') THEN 'US Territories'
    WHEN state IN ('AE','AP') THEN 'US Military'
    ELSE state END AS state_group
FROM cfpb_analysis 
)

SELECT
    COUNT(DISTINCT state_group) AS distinct_states
FROM chad

