## Datetime

`datetime` 패키지에서는 날짜와 시간을 함께 저장하는 `datetime` 클래스, 날짜만 저장하는 `date` 클래스, 시간만 저장하는 `time` 클래스, 시간 구간 정보를 저장하는 `timedelta` 클래스 등을 제공한다.



### 1. Class : Datetime, Date, Time

1. `Datetime` 패키지 내의 `datetime`, `date`, `time` 세 가지 클래스가 존재. 각 클래스에 `year`, `month` 등 메서드를 사용할 수 있다
```python
>>> import datetime as dt

>>> d1 = dt.datetime.now()
>>> type(d1)
datetime.datetime

>>> d1.year
>>> d1.month
>>> d1.day
>>> d1.hour
>>> d1.minute
>>> d1.second

>>> d1.weekday() # 0-6 : 월-일
>>> d1.date()
datetime.date(2022, 1, 10)
>>> d1.time()
datetime.time(17, 7, 10, 677445)
```



2. strptime, strftime
   - `strptime` : 입력된 문자열을 원하는 포멧의 `datetime` 클래스로 변환.
   - `strftime` : `datetime`클래스를 원하는 포멧의 문자열로 변환.

| 날짜 및 시간 지정 문자열 | 의미                                                   |
| ------------------------ | ------------------------------------------------------ |
| `%Y`                     | 앞의 빈자리를 0으로 채우는 4자리 연도 숫자             |
| `%m`                     | 앞의 빈자리를 0으로 채우는 2자리 월 숫자               |
| `%d`                     | 앞의 빈자리를 0으로 채우는 2자리 일 숫자               |
| `%H`                     | 앞의 빈자리를 0으로 채우는 24시간 형식 2자리 시간 숫자 |
| `%M`                     | 앞의 빈자리를 0으로 채우는 2자리 분 숫자               |
| `%S`                     | 앞의 빈자리를 0으로 채우는 2자리 초 숫자               |
| `%A`                     | 영어로 된 요일 문자열                                  |
| `%B`                     | 영어로 된 월 문자열                                    |

```python
>>> d2 = '2022/01/12'
>>> dt.datetime.strptime(d2, '%Y/%m/%d')
datetime.datetime(2022, 1, 12, 0, 0)

>>> dt.datetime.strptime(d2, '%Y/%m/%d').strftime('%d-%m-%Y')
'12-01-2022'

# Series에서의 벡터연산
# 1) map
>>> s1 = pd.Series(['2022/01/01', '2022/01/02', '2022/01/03'])
>>> s1.map(lambda x : datetime.strptime(x,'%Y/%m/%d'))
0   2022-01-01
1   2022-01-02
2   2022-01-03
dtype: datetime64[ns]
    
# 2) to_datetime
pd.to_datetime(s1, format='%Y/%m/%d')
0   2022-01-01
1   2022-01-02
2   2022-01-03
dtype: datetime64[ns]
```



### 2. Class : Timedelta

- 날짜나 시간의 간격을 구할 때는 두 개의 `datetime` 클래스 객체의 차이를 구한다. 이 결과는 `timedelta` 클래스 객체로 반환되며 다음 메서드를 가진다.

```python
>>> dt1 = dt.datetime(2016, 2, 19, 14)
>>> dt2 = dt.datetime(2016, 1, 2, 13)
# datetime - datetime = timedelta
>>> td = dt1 - dt2
datetime.timedelta(days=48, seconds=3600)
# timedelta + datetime = datetime
>>> dt1 + td
datetime.datetime(2016, 4, 7, 15, 0)

td.days
td.seconds
```

- `timedelta`에 값을 전달해 원하는 기간을 설정할 수 있다.

```python
>>> dt.delta = timedelta(
...        days=50,
...        seconds=27,
...        microseconds=10,
...        milliseconds=29000,
...        minutes=5,
...        hours=8,
...        weeks=2
...    )
datetime.timedelta(days=64, seconds=29156, microseconds=10)
```



### 3. Pandas Class : DateOffset

- `datetime.timedelta`와 비슷한 사용으로 판다스 패키지의 `DateOffset`을 사용할 수 있다. 마찬가지로 `months`, `days`, `years` 등의 인자를 설정해 원하는 기간을 설정할 수 있다. `datetime`과 연산이 가능한데 출력은 판다스의 `timestamps`가 된다.

```python
>>> import pandas as pd
>>> d1 = dt.datetime.now()
>>> stamp = d1 + pd.DateOffset(months=4)
Timestamp('2022-05-10 17:07:10.677445')

>>> stamp.month
>>> stamp.day
>>> stamp.hour
>>> stamp.minute
>>> stamp.second

>>> a.weekday()
>>> a.date()
datetime.date(2022, 5, 10)
>>> a.time()
datetime.time(17, 7, 10, 677445)
```



