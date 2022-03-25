use adventureworks;

# ---------------------------------------------------------------------

## 중복레코드가 있는경우? 찾는법. 
select * from product;
drop table product_cp;

CREATE table Product_CP
select productid, name from product;

select * from Product_CP;
show columns from product_cp;



select * from Product_CP;
show columns from product_cp;

insert into Product_CP values(4, 'Headset Ball Bearings');
insert into Product_CP values(370, 'Thin-Jam Hex Nut 14');



select productid, count(*)
from product_cp
group by ProductID
having count(*)>1;

# ---------------------------------------------------------------------

## Over
-- 찾을 수 있지만 지울 수 없음.
select salespersonid
, sum(totaldue) 
from salesorderheader
group by salespersonid;

select salespersonid
, sum(totaldue) over()
from salesorderheader;

-- 이 문장 하나면 over 설명 가능.
select SalesPersonID, CustomerID, year(orderdate) as year_-- , SubTotal
	,count(*) as row_
	,sum(subtotal) as sub_total
	,sum(subtotal) over() as sub_total_avg_over # 전체합계
                 ,sum(subtotal) over(partition by year(orderdate) ) as sub_total_by_year # 연도별
	,sum(subtotal) over(Partition by SalesPersonid) as sub_total_avg_by_salesPersonid # 영업사원별
	,sum(subtotal) over(Partition by SalesPersonid, customerid) as sub_total_avg_by_salesPersonid2 # 영업사원별, 고객별
	,sum(subtotal) over(Partition by SalesPersonid, year(orderdate) ) as sub_total_avg_by_salesPersonid3 # 영업사원별, 연도별
    ,sum(subtotal) over(Partition by SalesPersonid) / sum(subtotal) over() *100 as '전체대비 영업사원 실적' # 영업사원별 실적 백분율
    ,sum(subtotal) over(Partition by SalesPersonid, year(orderdate) ) /sum(subtotal) over(partition by year(orderdate) ) * 100 as '연도별 영업사원실적' # 연도별 영업사원 실적 백분율
	from   SalesOrderHeader
where SalesPersonID is not null
group by SalesPersonID, CustomerID-- , SubTotal;
order by salesPersonId, year(orderdate), customerid;

# ---------------------------------------------------------------------

## row_number
select productid, name, reorderpoint , listprice
, row_number() over() as rows_       
 ## , row_number() over (partition by reorderpoint ) as rows_
from product
order by listprice desc, reorderpoint;

## row_number + over partition
select productid, name, reorderpoint , listprice
## , row_number() over() as rows_       
, row_number() over (partition by reorderpoint ) as rows_
from product;

## ntile
select 
productid, name as product_name, safetystocklevel, reorderpoint 
, row_number() over()
, ntile(10) over()
from product;

## ntile + over partition
select 
productid, name as product_name, safetystocklevel, reorderpoint 
, row_number() over()
, ntile(5) over (partition by safetystocklevel)
from product;

## rank
-- 재고 수량을 기준으로 지정한 인벤토리 위치의 제품에 순위를 부여하는 sql문
select a.*
from (
	SELECT i.ProductID, p.Name, i.LocationID, i.Quantity  
		,RANK() OVER   
		(PARTITION BY i.LocationID ORDER BY i.Quantity DESC) AS Rank_ # DESC : 역순
		,DENSE_RANK() OVER   
		(PARTITION BY i.LocationID ORDER BY i.Quantity DESC) AS DRank_ # DESC : 역순
	FROM  ProductInventory AS i   
	INNER JOIN Product AS p   
		ON i.ProductID = p.ProductID  
	WHERE i.LocationID BETWEEN 3 AND 4 
	ORDER BY i.LocationID
    ) a
    
    
where a.rank_ <=3;

## Lag, Lead
select 
ProductID
,ReorderPoint
,row_number()			over (Order by reorderpoint desc ) as row_number_
,rank() 				over (Order by reorderpoint desc ) as rank_
,Dense_rank()			over (Order by reorderpoint desc ) as dense_rank_
,Lag(productid)			over (Order by reorderpoint desc ) as Lag1
,Lag(productid,2)		over (Order by reorderpoint desc ) as Lag2
,Lead(productid)		over (Order by reorderpoint desc ) as Lead1
,Lead(productid,2)		over (Order by reorderpoint desc ) as Lead2
,ProductID - Lead(productid,2)		over (Order by reorderpoint desc )
from  Product
order by rank_ ;

# ---------------------------------------------------------------------

## CTE
WITH Sales_CTE (SalesPersonID, NumberOfOrders)  
AS  
(  
    SELECT SalesPersonID, COUNT(*)  
    FROM SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
    GROUP BY SalesPersonID  
)  
SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"  
FROM Sales_CTE;

-- 위와 동일
SELECT AVG(aaa.NumberOfOrders) AS "Average Sales Per Person"  
FROM 
(  
    SELECT SalesPersonID, COUNT(*)  as NumberOfOrders
    FROM SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
    GROUP BY SalesPersonID  
)  aaa;

-- 여러개의 CTE를 생성하여 사용하는 방법.
WITH Sales_CTE (SalesPersonID, TotalSales, SalesYear)  
AS  
-- Define the first CTE query.  
(  
    SELECT SalesPersonID, SUM(TotalDue) AS TotalSales, YEAR(OrderDate) AS SalesYear  
    FROM SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
       GROUP BY SalesPersonID, YEAR(OrderDate)  
)  
,   -- Use a comma to separate multiple CTE definitions.  : CTE를 하나 구성하고 새로운 CTE를 구성할때 comma를 접속사로 사용한다.
  
-- Define the second CTE query, which returns sales quota data by year for each sales person.  
Sales_Quota_CTE (SalesPersonID, SalesQuota, SalesQuotaYear)  
AS  
(  
       SELECT SalesPersonID, SUM(SalesQuota)AS SalesQuota, YEAR(QuotaDate) AS SalesQuotaYear  
       FROM SalesPersonQuotaHistory  
       GROUP BY SalesPersonID, YEAR(QuotaDate)  
)
-- Define the outer query by referencing columns from both CTEs.  
SELECT Sales_CTE.SalesPersonID  
  , SalesYear  
  , TotalSales  
  , SalesQuotaYear  
  , SalesQuota  
  , TotalSales -SalesQuota AS Amt_Above_or_Below_Quota  
  , convert(TotalSales - SalesQuota, decimal(10,2)) AS Amt_Above_or_Below_Quota2
FROM Sales_CTE  
JOIN Sales_Quota_CTE 
ON 	Sales_Quota_CTE.SalesPersonID = Sales_CTE.SalesPersonID  
	AND Sales_CTE.SalesYear = Sales_Quota_CTE.SalesQuotaYear  
ORDER BY SalesPersonID, SalesYear;



# ---------------------------------------------------------------------


## View
create view vw_001 as 
    (
	SELECT SOH.SalesOrderid, SOH.OrderDate
	, Status, SOD.SalesOrderDetailID ,TotalDue, SOD.productid, P.name
	, OrderQty ,UnitPrice, lineTotal
	FROM SalesOrderHeader SOH INNER JOIN SalesOrderDetail SOD
	ON SOH.SalesOrderid = SOD.SalesOrderID
	JOIN Product P
	ON SOD.productID = P.ProductID
	where P.color is null  
    )
    
SELECT * FROM vw_001


# ---------------------------------------------------------------------

## WindowFame

select orderdate
, sum(subtotal) as dailytotal
-- 최근 최대 7일동안의 평균 계산하기
, avg(sum(subtotal)) over(order by orderdate rows between 6 preceding and current row) as 7day_avg
-- 최근 최대 7일동안의 평균 확실하게 계산히기 (즉 7개가 모여야만 출력)
, case
	when 7=count(*) over (order by orderdate rows between 6 preceding and current row) 
    then 
    avg(sum(subtotal)) over (order by orderdate rows between 6 preceding and current row) 
    end 
    as 7day_avg_strict
From SalesOrderHeader
group by orderdate
order by orderdate

# ---------------------------------------------------------------------

## Create new table

CREATE TABLE IF NOT EXISTS `PurchaseOrderHeader2001` 
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader
where year(orderdate) = 2001;  -- 11개의 컬럼

CREATE TABLE IF NOT EXISTS `PurchaseOrderHeader2002` 
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from PurchaseOrderHeader
where year(orderdate) = 2002;  -- 11개의 컬럼

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


# ---------------------------------------------------------------------

## 실시간 업데이트 적용 과정 쿼리문

ALTER VIEW Vw_purchaseOrderHeader 
AS
(
	select purchaseOrderID, RevisionNumber, status, employeeID
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from PurchaseOrderHeader2001    --  8rows
	UNION 							--  280 rows
	select purchaseOrderID, RevisionNumber, status, employeeID 
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from PurchaseOrderHeader2002
    UNION
	select purchaseOrderID, 0			  , status, employeeID 
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from PurchaseOrderHeader2003
)
;   --  272 rows

select * from Vw_purchaseOrderHeader


ALTER VIEW Vw_purchaseOrderHeader 
AS
(
	select purchaseOrderID, RevisionNumber, status, employeeID
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from PurchaseOrderHeader2001    --  8rows
	UNION 							--  280 rows
	select purchaseOrderID, RevisionNumber, status, employeeID 
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from PurchaseOrderHeader2002
    UNION
	select purchaseOrderID, 0			  , status, employeeID 
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from PurchaseOrderHeader2003
    UNION
	select purchaseOrderID, 0			  , status, employeeID 
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from PurchaseOrderHeader2004
)


