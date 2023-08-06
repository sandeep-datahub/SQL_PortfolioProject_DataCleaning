/* 
CLEANING DATA IN SQL
*/

SELECT * FROM NashvilleHousing
------------------------------------------------------

-- STANDARDIZE DATE FORMAT

SELECT SaleDate, CONVERT(date, SaleDate) AS sale_date
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CAST(SaleDate as date)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

------------------------------------------------------------------------------
-- POPULATE PROPERTY ADDRESS DATA

SELECT * 
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

------------------------------------------------------------------------------
-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (Address, City and State)

SELECT PropertyAddress 
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, 
		CHARINDEX(',', PropertyAddress)+2, --+2 to avoid blank space after comma
		LEN(PropertyAddress)) AS City 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+2, LEN(PropertyAddress))

SELECT * FROM NashvilleHousing

SELECT OwnerAddress FROM NashvilleHousing	

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

---------------------------------------------------------------------------------------------
--CHANGE Y and N to YES AND NO in "SoldAsVacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant='Y' THEN 'Yes'
		 WHEN SoldAsVacant='N' THEN 'No'
	ELSE SoldAsVacant
	END AS UpdatedSoldAsVacant
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes'
						WHEN SoldAsVacant='N' THEN 'No'
						ELSE SoldAsVacant
						END

--------------------------------------------------------------------------------------------------------
-- REMOVE DUPLICATES

WITH duplicateCTE AS (
SELECT *, ROW_NUMBER() OVER(
		  PARTITION BY ParcelID, 
					   PropertyAddress, 
					   SaleDate, 
					   SalePrice, 
					   LegalReference 
					   ORDER BY UniqueID
					   ) row_num
FROM NashvilleHousing
)
DELETE FROM duplicateCTE
WHERE row_num > 1


------------------------------------------------------------------------------------------------
--DELETE UNUSED COLUMNS

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate