# Data Cleaning Portfolio Project using Nashville Housing Dataset (via SQL Server Management Studio)

# Overview
I carried outn the following activities during the data cleaning phase:
1. Standardized date formats using CAST and CONVERT methods
2. Replaced NULL values with the correct Property Addresses
3. Used the SUBSTRING and CHARINDEX functions to break out PropertyAddress into individual columns like Address, City and State
4. Tried an alternative for the SUBSTRING function using PARSENAME
5. Used CASE statements to standardize Y and N randomly appearing in columns instead of Yes and No
6. Removed duplicates using a CTE and ROW_NUMBER() window function
7. Deleted unused columns in the table using the DROP COLUMN query
