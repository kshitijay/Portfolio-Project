
--Observing the dataset Nashville Housing
select * from [Data cleaning].dbo.NashvilleHousing;


-- Standarising the date format

select  SaleDateConverted
from [Data cleaning].dbo.NashvilleHousing;

update [Data cleaning].dbo.NashvilleHousing
set SaleDateConverted= CONVERT(DATE,SaleDate);        -- Tried updating the existing column SaleDate with the date portion logc but didnt't work. So created another column for that logic.

ALTER TABLE [Data cleaning].dbo.NashvilleHousing
ADD SaleDateConverted DATE;


---Populate Property Address data

select PropertyAddress
from [Data cleaning].dbo.NashvilleHousing;


select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Data cleaning].dbo.NashvilleHousing a
join [Data cleaning].dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Data cleaning].dbo.NashvilleHousing a
join [Data cleaning].dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


--- Breaking out Address into Address, City, State

select PropertyAddress
from [Data cleaning].dbo.NashvilleHousing;


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,       -- used the charindex() to specific the ending point position as the starting pos is place 1. Mentioned -1 so as to not include the last letter which was a comma.

SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress)) as Address   --- splitted the next half portion of address
from [Data cleaning].dbo.NashvilleHousing;

-- Creating 2 new columns 

ALTER TABLE [Data cleaning].dbo.NashvilleHousing
ADD PropertySplittedAddress Nvarchar(255);


ALTER TABLE [Data cleaning].dbo.NashvilleHousing
ADD PropertySplittedCity Nvarchar (255);



-- updating the 2 colmsn with the substring vals

update [Data cleaning].dbo.NashvilleHousing
set PropertySplittedAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1);



update [Data cleaning].dbo.NashvilleHousing
set PropertySplittedCity =
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress))


-- Trying to use parsename()

select
PARSENAME(replace(OwnerAddress,',','.'),1),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),3)
from [Data cleaning].dbo.NashvilleHousing

select OwnerAddress from [Data cleaning].dbo.NashvilleHousing

-- Add the 3 cols for Owner split address using parsename

ALTER TABLE [Data cleaning].dbo.NashvilleHousing
ADD OwnerSplittedAddress Nvarchar(255);


ALTER TABLE [Data cleaning].dbo.NashvilleHousing
ADD OwnerSplittedCity Nvarchar (255);

ALTER TABLE [Data cleaning].dbo.NashvilleHousing
ADD OwnerSplittedState Nvarchar (255);



-- updating the 2 colmsn with the parsename vals

update [Data cleaning].dbo.NashvilleHousing
set OwnerSplittedAddress  = PARSENAME(replace(OwnerAddress,',','.'),3);



update [Data cleaning].dbo.NashvilleHousing
set OwnerSplittedCity =
PARSENAME(replace(OwnerAddress,',','.'),2)


update [Data cleaning].dbo.NashvilleHousing
set OwnerSplittedState =
PARSENAME(replace(OwnerAddress,',','.'),1)


--Standarizing the yes and no in Soldasvacant field

select distinct(SoldAsVacant),count(*)
from  [Data cleaning].dbo.NashvilleHousing
group by SoldAsVacant

-- Using the CASE statement to standarize

select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' then 'Yes'
     WHEN SoldAsVacant ='N'  then 'No'
ELSE SoldAsVacant
END
from  [Data cleaning].dbo.NashvilleHousing


Update [Data cleaning].dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
     WHEN SoldAsVacant ='N'  then 'No'
ELSE SoldAsVacant
END

--- Removing duplicates



WITH RowNumCTE AS(
select *,
ROW_NUMBER()
OVER(PARTITION BY ParcelId,
			   SalePrice,                              ---removed propertyaddress & saledate as it it dropped
			   LegalReference
			   ORDER BY UniqueId)row_num


from  [Data cleaning].dbo.NashvilleHousing)
                                                           ---deleted the dups and then ran the select query again so 0 records
select * from RowNumCTE
where row_num>1 


--- Delete unused columns

ALTER TABLE  [Data cleaning].dbo.NashvilleHousing
DROP COLUMN OwnerAddress,PropertyAddress,SaleDate

select * from [Data cleaning].dbo.NashvilleHousing

