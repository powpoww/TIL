use adventureworks;

# ---------------------------------------------------------------------

### DATA COPY
create table if not exists product_cp like product;
select * from product_cp; 
show columns from product_cp;

create table address_cp 
select * from address;

select * from address_cp;
show columns from address_cp;

insert into product_cp
select * from product
where productid>100 ;

show create table product;

select * from product_cp;

update product_cp
set safetystocklevel = safetystocklevel +10
where productID >=100;

drop table address_cp;

delete from product_cp;
select * from product_cp;
truncate table product_cp;

# ---------------------------------------------------------------------

### JOIN
select * from SalesOrderHeader JOIN SalesOrderDetail on SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderid

# Inner Join
select SOH.SalesOrderid, SOD.SalesOrderid, SOH.OrderDate, Status, SOD.SalesOrderDetailID ,TotalDue, SOD.productid, P.name, OrderQty ,UnitPrice, lineTotal
FROM SalesOrderHeader SOH INNER JOIN SalesOrderDetail SOD
ON SOH.SalesOrderid = SOD.SalesOrderID
JOIN Product P 
ON SOD.productID = P.ProductID;

# Outer Join - show null value
select p.productid, sod.productid, P.name, color, SafetyStockLevel, ReorderPoint
from product P left outer join salesOrderdetail sod
on p.productid = sod.productid where sod.productid is null;

# ---------------------------------------------------------------------

### Union
select * from purchaseorderheader;
select min(OrderDate), max(OrderDate) from purchaseorderheader;

CREATE TABLE IF NOT EXISTS `PurchaseOrderHeader2001` 
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader
where year(orderdate) = 2001;  -- 11개의 컬럼

select * from `PurchaseOrderHeader2001`;


CREATE TABLE IF NOT EXISTS `PurchaseOrderHeader2002` 
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader
where year(orderdate) = 2002;  -- 11개의 컬럼

select * from `PurchaseOrderHeader2002`;

--  컬럼을 일부로 누락한 테이블 RevisionNumber 컬럼을 제거
CREATE TABLE IF NOT EXISTS `PurchaseOrderHeader2003` 
select purchaseOrderID, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue   -- 10개의 컬럼
from PurchaseOrderHeader
where year(orderdate) = 2003;

--  뒷 부분 컬럼을 추가한 테이블 
CREATE TABLE IF NOT EXISTS `PurchaseOrderHeader2004` 
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue , 'dummy'    -- 12개의 컬럼
from PurchaseOrderHeader
where year(orderdate) = 2004;

-- 앞 단계에서 나눈 데이터세트를 row를 확장하는 방향으로 데이터세트를 만들면 다음과 같음.
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader2001    --  8rows
UNION 						--  280 rows
select purchaseOrderID, RevisionNumber, status, employeeID 
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader2002;   --  272 rows

select status, employeeID
from PurchaseOrderHeader2001    --  8rows
UNION ALL						--  union 13 rows , union all 280 rows
select status, employeeID 
from PurchaseOrderHeader2002;   --  272 rows

-- ?????????????????
-- POH2001에는 RevisionNumber가 있지만 POH2003에는 해당 컬럼이 없음 : 더미컬럼 추가해 Union 수행.
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader2001    --  8rows
UNION 							--  280 rows
select purchaseOrderID, 0,				status, employeeID 
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader2003;   --  1032 rows

-- ?????????????????????
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader2001    --  8rows
UNION 							--  280 rows
select purchaseOrderID, RevisionNumber, status, employeeID 
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader2002   --  272 rows
UNION ALL						--  280 rows, union과 union all을 모두 섞어서 사용할 수 있다. 
select purchaseOrderID, 0,				status, employeeID 
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader2003;	-- 1000 row

# ---------------------------------------------------------------------
### CASE
select color, 
	( CASE color 
		when 'red' then '적색' 
        when 'yellow' then '황색'
        when 'black' then '흑색'
        when 'Silver' then '은색'
        when 'white' then '백색'
        when 'Blue' then '청색'
        when 'Multi' then '복합'
        when 'Grey' then '회색'
        when 'Silver/Black' then '은색/흑색' 
        when null then '----'
        else 'oooooo'
	end ) as '색깔'
	from product;  --  null 이 제대로 걸러지지 않음; 
    
--  조건 부분의 수정, null 표현을 위해서 아래와 같이 사용하는 것이 좋겠다. 
select color, 
	( CASE  
		when color = 'red' then N'적색' 
        when color = 'yellow' then N'황색'
        when color = 'black' then N'흑색'
        when color = 'Silver' then N'은색'
        when color = 'white' then N'백색'
        when color = 'Blue' then N'청색'
        when color = 'Multi' then N'복합'
        when color = 'Grey' then N'회색'
        when color = 'Silver/Black' then N'은색/흑색' 
        when color is null then '----'
        else 'oooooo'
        end ) as '색깔'
        from product;

select Employeeid
		, SUM( CASE year(orderDate) when '2001' then TotalDue end) as TotalDue2001
		, SUM( CASE year(orderDate) when '2002' then TotalDue end) as TotalDue2002
		, SUM( CASE year(orderDate) when '2003' then TotalDue end) as TotalDue2003
		, SUM( CASE year(orderDate) when '2004' then TotalDue end) as TotalDue2004
FROM purchaseorderheader
group by employeeid
order by Employeeid;


# ---------------------------------------------------------------------
### 날짜 차이 가져오기
select now();

select now(), year( now() ), month( now() ) , day( now())
, hour(now()), minute(now()), second(now()) 
, week(now()), quarter(now());

select now()
, date_add(now(), interval 1 year)
, date_add(now(), interval 1 month)
, date_add(now(), interval 1 minute)
, date_add(now(), interval 1 second)
, date_sub(now(), interval 1 year)
, date_sub(now(), interval 1 month)
, date_sub(now(), interval 1 minute)
, date_sub(now(), interval 1 second);

select * from salesOrderheader;
select orderdate, duedate, shipdate
, timestampdiff (day, orderdate, duedate) 
, timestampdiff (day, orderdate, shipdate) 
from salesorderheader;
select * from salesOrderheader;
select timestampdiff (day, '1984-03-01', now());

select now(), convert(year(now()) + month(now()), date) ;

# ---------------------------------------------------------------------
### Group by
Select salesPersonID, count(*) as 수주건수 , sum(TotalDue) as 매출총액
from salesOrderHeader
group by salesPersonID
order by salespersonID;

Select salesPersonID, TerritoryID, sum(Totaldue) as 매출총액 from salesOrderHeader
group by salesPersonID, TerritoryID
order by salespersonID;

Select salesPersonID,  TerritoryID, shipmethodID, customerID, count(*) as 수주건수 , sum(TotalDue) as 매출총액
from salesOrderHeader
group by salesPersonID,  TerritoryID, shipmethodID, customerID
order by salespersonID;
