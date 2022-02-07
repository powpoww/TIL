## 1. Python Practice - 산술연산



### **1.1 Series 연산**

- 판다스는 1차원 자료인 Series를 기본 단위로 하는 2차원 정형데이터(테이블, 표, 데이터프레임)이다. 
- Series에서는 하나의 데이터 타입만 허용함. (object는 다양한 타입의 요소를 가짐.)

- sclar와의 기본 사칙연산 가능. 하지만 **Series간의 연산은 key(index)가 같은 값끼리 연산**되며, **key값이 같지 않을경우 `NaN` 값을 반환**함.
- 이 때, NaN 반환을 방지하기 위해 **메소드와 fill_value 옵션**을 사용하는 것을 권장.

```python
>>> s1 = pd.Series([1,2,3,4])
>>> s2 = pd.Series([1,2,3,'4'])
>>> s3 = pd.Series([1,2,3,4], index=list('abcd'))

# Series + Scalar
>>> s1 + 1
0    2
1    3
2    4
3    5
dtype: int64

>>> s4 = pd.Series([10,20,30,40])
>>> s5 = pd.Series([10,20,30,40], index=list('cdef'))

>>> s1+s4 			# 같은 index끼리 연산.
0    11
1    22
2    33
3    44
dtype: int64

>>> s3+s5           # index가 다르면 모두 NaN 반환.
a     NaN
b     NaN
c    13.0
d    24.0
e     NaN
f     NaN
dtype: float64


# 양쪽 모두 존재하지 않는 index의 경우 
# NaN 반환을 방지하기 위해 fill_value 옵션 사용
>>> s3.add(s5, fill_value=0)
a     1.0
b     2.0
c    13.0
d    24.0
e    30.0
f    40.0
dtype: float64
>>> s3.sub(s5, fill_value=0)
a     1.0
b     2.0
c    -7.0
d   -16.0
e   -30.0
f   -40.0
>>> s3.mul(s5, fill_value=1)
a     1.0
b     2.0
c    30.0
d    80.0
e    30.0
f    40.0
dtype: float64
>>> s3.div(s5, fill_value=1)
a    1.000000
b    2.000000
c    0.300000
d    0.200000
e    0.033333
f    0.025000
dtype: float64
```



### **1.2 DataFrame 연산**

- 연산 또한 key에 관하여 Series에서 적용되던 법칙과 동일. 추가로 column에 대해서도 마찬가지임.
- col, index를 직접 입력해도 되고 dict도 입력가능.
- 기본 메서드
  - `d3.dtypes` : 각 컬럼별 Series의 데이터 타입을 호출.
  - `d3.index` : index 호출
  - `d3.columns` : col 호출
  - `d3.values` : 값 호출 (n-dimention ndarray)


```python
>>> d1 = {'name': ['smith', 'will'], 'sal':[900,1800]}
>>> d2 = pd.DataFrame(d1)
>>> d2
    name   sal
0  smith   900
1   will  1800

# col이 동일, index가 다를 때 동일 인덱스 외에 NaN 반환.
>>> d3 = pd.DataFrame(np.arange(1,7).reshape(2,-1), columns=['col1','col2','col3'], index=['a','b'])
>>> d4 = pd.DataFrame(np.arange(1,7).reshape(2,-1), columns=['col1','col2','col3'], index=['a','c'])
>>> d4 + d3
   col1  col2  col3
a   2.0   4.0   6.0
b   NaN   NaN   NaN
c   NaN   NaN   NaN

# method를 사용해 방지.
>>> d4.add(d3, fill_value=0)
>>> d4.sub(d3, fill_value=0)
>>> d4.mul(d3, fill_value=1)
>>> d4.div(d3, fill_value=1)

# index가 동일, col이 다르면 동일한 col 외에 NaN 반환
d5 = pd.DataFrame(np.arange(1,7).reshape(2,-1), columns=['col1','col2','col4'], index=['a','b'])
d5 + d3
   col1  col2  col3  col4
a     2     4   NaN   NaN
b     8    10   NaN   NaN

# method를 사용해 방지.
>>> d5.add(d3, fill_value=0)
>>> d5.sub(d3, fill_value=0)
>>> d5.mul(d3, fill_value=1)
>>> d5.div(d3, fill_value=1)
```

 

- axis별 연산

```python
>>> df1 = pd.DataFrame(np.arange(1,17).reshape(4,4))
>>> df1
    0   1   2   3
0   1   2   3   4
1   5   6   7   8
2   9  10  11  12
3  13  14  15  16

>>> df1.sum(axis=0)         # axis=0 방향 합
0    28
1    32
2    36
3    40
dtype: int64
>>> df1.sum(axis=1)         # axis=1 방향 합
0    10
1    26
2    42
3    58
dtype: int64

>>> df1.iloc[:,0].sum()     # 0번째 컬럼 합
>>> df1.iloc[:,0].mean()    # 0번째 컬럼 평균

# NaN이 있을 때 연산.
>>> df1.iloc[0,0] = np.nan
>>> df1
#       0   1   2   3
# 0   NaN   2   3   4
# 1   5.0   6   7   8
# 2   9.0  10  11  12
# 3  13.0  14  15  16

>>> df1.iloc[:,0].mean() # skipna = True(default). 자동으로 NaN 무시하고 연산
9.0

df1.iloc[:,0].var()     # 분산
df1.iloc[:,0].std()     # 표준편차
df1.iloc[:,0].min()     # 최소
df1.iloc[:,0].max()     # 최대
df1.iloc[:,0].median()  # 중위수
df1.describe()
```



