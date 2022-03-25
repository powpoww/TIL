**(10) Over**

```mysql
## Over
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
```



**(11) row_number(), ntile(), rank(), dense_rank()**

- 조회된 데이터세트는 특정 정렬에 따라 순위와 같은 번호를 넣어주면 시각화나 기타 데이터 분석에 도움이 됨. 즉 엑셀 등에 붙여넣기 등으로 순서를 확인할 필요가 없음.

  - row_number() : 번호를 매김.

  - ntile() : row를 정확히 N개의 그룹으로 나누어 그룹별로 번호를 할당.

  - rank()  : 순위에 따라 번호를 매김.

  - dense_rank() : rank로 부터 중복이 발생하는 경우 번호를 부여하는 방법에 관여



**(12) CTE(Command Table Expression)**

- 쿼리 실행 중에 메모리에 존재하는 테이블로 저장없이 쿼리 내에 임시저장 하여 쿼리문 내에서 모든 것을 일괄처리할 수 있음.

```mysql
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
SalesYear;
```



**(13) View 정의 및 용도**

- View 정의 : 가상의 테이블을 의미. 쿼리를 단순하게 만드는 용도. 쿼리문의 alias라고 할 수 있음.
  1. 보안
     - 테이블의 구조를 오픈하고 싶지 않을 때.
     - Data Mart를 만드는 경우 사용자에게 최대한 정보를 공개하는 것이 좋지만 모두 공개하지는 않는다. 직원테이블의 vacationhours 등 개인정보와 연관될 수 있고 제품테이블(product), 제품재고테이블(productinventory) 등 영업 비밀로 두어야 할 것이 있음.
     - select (보여줄 컬럼 목록) from product 테이블로 조회를 해야 하지만 사용자 입장에서 컬럼을 추정하거나, select * from product 식으로 조회를 하면 모든 컬럼이 노출되게 되어 view를 구성해 방지한다.
  2. 편리성
     - 2개 이상의 테이블을 조인을 이용해 만드는 경우 sql문이 매우 복잡해짐.
     - 네트워크의 패킷도 더 많이 차지하게 되어 view로 문제를 해결한다.

```mysql
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
```



**(14) 윈도우 프레임(Window Frame) 지정하기**

```mysql
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
```


