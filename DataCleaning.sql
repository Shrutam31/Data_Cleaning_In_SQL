select Top 100 *
from nashvile





--- populating Adress Data

select PropertyAddress
from nashvile
where PropertyAddress is null

-- we can populate property address based on parcel id
-- we can se that where two parcel ids are same has same property address



select *
from nashvile
--where PropertyAddress is null
order by ParcelID


select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from nashvile as a 
Join nashvile as b
	on a.ParcelID = b.ParcelID
	--here parcel id can be same but unique is id not
	And a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


--- using ISnull function to populate the address in a


select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
from nashvile as a 
Join nashvile as b
	on a.ParcelID = b.ParcelID
	--here parcel id can be same but unique is id not
	And a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

-- updating

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
from nashvile as a 
Join nashvile as b
	on a.ParcelID = b.ParcelID
	--here parcel id can be same but unique is id not
	And a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


--- Breaking out address into columns (address, city, State)


select PropertyAddress
from nashvile 

--- there is just one comma used in every single address


select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Address
from nashvile

-- removing the comma by 1 space back (-1)

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from nashvile


-- Updating the changes

ALTER table nashvile
Add PropertySplitAddress Nvarchar(255)

Update nashvile
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER table nashvile
Add PropertySplitCity Nvarchar(255)

Update nashvile
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 


select PropertySplitAddress, PropertySplitCity
from nashvile


--- doing similar thing for ownerAddress but with different approach


Select
PARSENAME(Replace(OwnerAddress,',','.'),1),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),3)
from nashvile


-- updating it in the database

ALTER table nashvile
Add OwnerSplitState Nvarchar(255)

Update nashvile
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER table nashvile
Add OwnerSplitCity Nvarchar(255)

Update nashvile
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER table nashvile
Add OwnerSplitAddress Nvarchar(255)

Update nashvile
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),1)



--- changed names for OwenerSplitsState And OwnerSplitAddress due to typo

Select OwnerSplitStates, OwnerSplitCity,OwnerSplitAddress
from nashvile

--- change Y and N to yes and no in SoldAsVacant column

select Distinct(SoldAsVacant)
from nashvile	
group by SoldAsVacant


-- we dont need to as while importing data it already converted it to 0 adn 1 
-- where 0 is no and 1 is yes



---Removing Duplicates

With RowNumCTE as(
select *,
	ROW_NUMBER()Over(
	Partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
	Order by UniqueID
	)row_num



from nashvile
--order by ParcelID

)
Delete
from RowNumCTE
Where row_num >1
--order by PropertyAddress

select *
from nashvile


--- checking if there are any duplicates

With RowNumCTE as(
select *,
	ROW_NUMBER()Over(
	Partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
	Order by UniqueID
	)row_num



from nashvile
--order by ParcelID

)
select *
from RowNumCTE
Where row_num >1
--order by PropertyAddress




--- Deleting Unused Columns

select *
from nashvile

Alter Table nashvile
Drop Column OwnerAddress, TaxDistrict, PropertyAddress