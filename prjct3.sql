--Data Cleaning Project (Housing/Property Sales Project)


SELECT *
FROM..DataCleaningprjct

--1.Standardizing the date format

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM..DataCleaningprjct

UPDATE DataCleaningprjct
SET SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE DataCleaningprjct
ADD SaleDateConverted Date;

UPDATE DataCleaningprjct
SET SaleDateConverted= CONVERT(Date,SaleDate)

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM..DataCleaningprjct

--

--Populate property address data

SELECT *
FROM..DataCleaningprjct
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress,b.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM..DataCleaningprjct a
JOIN..DataCleaningprjct b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM..DataCleaningprjct a
JOIN..DataCleaningprjct b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

--Breaking the Address Column into Individual Columns ( Address, City)
--Using Substrings

SELECT PropertyAddress
FROM..DataCleaningprjct
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM..DataCleaningprjct



ALTER TABLE DataCleaningprjct
ADD PropertySplitAddress Nvarchar(255);

UPDATE DataCleaningprjct
SET PropertySplitAddress= SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 


ALTER TABLE DataCleaningprjct
ADD PropertySplitCity Nvarchar(255);

UPDATE DataCleaningprjct
SET PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM..DataCleaningprjct


--For owner address
--Using PARSENAME

SELECT OwnerAddress
FROM..DataCleaningprjct

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
FROM..DataCleaningprjct



ALTER TABLE DataCleaningprjct
ADD OwnerSplitAddress Nvarchar(255);

UPDATE DataCleaningprjct
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress,',','.') ,3)

ALTER TABLE DataCleaningprjct
ADD OwnerSplitCity Nvarchar(255);

UPDATE DataCleaningprjct
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE DataCleaningprjct
ADD OwnerSplitState Nvarchar(255);

UPDATE DataCleaningprjct
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

SELECT *
FROM..DataCleaningprjct

--In the data in the SoldAsVacant column there is' Yes', 'No','Y', 'N'
--So need to convert Y and N to Yes and No

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM..DataCleaningprjct
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
     WHEN SoldAsVacant= 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM..DataCleaningprjct

UPDATE..DataCleaningprjct
SET SoldAsVacant= CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
     WHEN SoldAsVacant= 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

--Removing duplicates

WITH RowNumCTE AS(
SELECT *,

  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY
			   UniqueID
			   ) row_num

FROM..DataCleaningprjct
--ORDER BY ParcelID
)
DELETE
FROM RowNUMCTE
WHERE row_num>1
--ORDER BY PropertyAddress

--Deleting unused columns
SELECT *
FROM..DataCleaningprjct

ALTER TABLE..DataCleaningprjct
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE..DataCleaningprjct
DROP COLUMN SaleDate
