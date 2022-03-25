**강의환경**

| 구분  | Version | Links                                     |
| ----- | ------- | ----------------------------------------- |
| MySQL | 8.xx    | https://goddaehee.tistory.com/277         |
| AWD   | -       | https://sourceforge.net/projects/awmysql/ |
|       |         |                                           |



**AdvantureWorks database**

- MS 공식 예시 데이터베이스. 글로벌 스포츠 용품(자전거) e-commerce 기업 AdventureWork 정보를 담고 있음.
- Full, Lite 버전으로 구분.



# 1. 관계형 데이터베이스는 무엇인가



**(1) 잘 저장되어 있다는 것의 의미**

1. 중복값이 없음.
2. 변경이 됐을 때 시스템 내에서 모두 적용돼야 함.



**(2) Full version Schema**

![AdventureWorks2008 DB Diagram | PDF | Data Management | Information  Technology Management](https://imgv2-1-f.scribdassets.com/img/document/331342453/original/50418b2603/1641526658?v=1)

- 과거에는 담당한 섹터 안에서 분석을 시도하여 인과관계를 도출. (Sales, Purchasing, Person ...)
- 근래에 들어서는 전 분야에 걸쳐 분석을 시도하며 각 섹터간의 영향, 상관관계를 분석함.
- 이러한 시도 때문에 각 섹터를 거대한 Table을 생성하기 시작. 



# 2. MySQL 실행



**(1) 쿼리 실행 순서**

- Select top 10 columnA, clommnB, count(*)
- FROM tableA
- Where orderdate between Startdate and Enddate
- Groupby columnA, columnB
- Having count(*) > 10
- Order by columnA DESC

: From and Join -> Where -> Groupby -> Having -> Select -> Order By -> TOP or Limit



**(2) 데이터 복사**

```mysql
use adventureworks;

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
```



**(3) JOIN 문**

1. Join

- 관계형 데이터베이스는 태생부터 데이터가 파편화됨. 파편화된 데이터를 모아 분석해야 하는 경우가 많고 이 때 사용하는 것이 JOIN.

- join은 from절에서 적용되며 데이터세트를 확장하는 방법.

```mysql
select * from SalesOrderHeader JOIN SalesOrderDetail on SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderid

select SOH.SalesOrderid, SOD.SalesOrderid, SOH.OrderDate, Status, SOD.SalesOrderDetailID ,TotalDue, SOD.productid, P.name, OrderQty ,UnitPrice, lineTotal
FROM SalesOrderHeader SOH INNER JOIN SalesOrderDetail SOD
ON SOH.SalesOrderid = SOD.SalesOrderID
JOIN Product P 
ON SOD.productID = P.ProductID
```



2. Inner join, outer join

- 관계성이 연결된 2개의 테이블 사이에 일반적으로 inner 조인을 하는 경우 null이 없어야 함.

- 하지만 제품 테이블(Product)에는 있지만 주문상세테이블(SalesOrderDetails)에 없는, 즉 한번도 팔리지 않은 제품을 알고 싶을 때 Outerjoin을 사용 가능.

```mysql
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
```



**(4) Union**

- union은 두 데이터세트의 row의 확장임. 
  - union : 두 데이터 세트 내에 중복 row를 하나만 보여줌.
  - union all : 두 데이터 세트 내에 중복 row를 모두 보여줌.
- 만약 두 데이터세트의 컬럼 개수가 다르다면 상위 테이블의 컬럼에 맞춰서 아래 테이블에 없는 컬럼은 dummy colum이라도 넣어야 한다.
- 예시> 온라인 매출 테이블과 오프라인 매출 테이블이 분리되었지만 합쳐서 고객의 매출형태를 분석할 때.

```mysql
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
```





**(5) 조건문 CASE, WHEN**

- 예시> 경영 관련 보고서 등에서 연도를 컬럼으로 표현해서 출력해야 하는 경우

```mysql
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

```



**(6) Text datatype 핸들링**

문자형 데이터 전처리에 주로 많이 사용되는 함수를 학습한다.

1. left(), rigt(), substring(), sibstr(), mid()
2. Ltrin(), Rtrim(), Trim()
3. Coalesce(), ifnull()
4. Concat()
5. Length(), len()



**(7) 날짜 및 시간관련 자료형 핸들링**

1. 하나의 날짜에서 찾을 수 있는 정보들
   - Year(), month(), day(), hour(), minute(), second(), quater()
2. 날짜 더하기, 빼기 함수
   - DATE_ADD(), DATE_SUB()
3. 날짜간 차이 계산 함수
   - timestampdiff(day, start_date, end_date)
4. 쿼리 실행 순간의 시간 함수
   - now()

```mysql
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
```



**(8) Convert()**



**(9) Group by, having 절**

- Group by : 테이블에서 특정 커럶의 그룹핑하는 경우 사용.
- Having : Group by의 where절과 같음.
  - Group by와 함께 등장하는 aggregation 함수
    - Count(*), sum(column_name), min(column_name), max(column_name), avg(column_name)

```mysql
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
```





































