# 01. Python Practice - 색인



### 1. Series

- `list`, `ndarray`와 마찬가지로 한개의 index를 입력하면 scalar로 호출되지만, list, bool 등을 입력하면 Series로 반환함.

```python
>>> s1 = pd.Series([1,2,3,4])
>>> s2 = pd.Series([1,2,3,'4'])
>>> s3 = pd.Series([1,2,3,4], index=list('abcd'))

>>> s1[0] 	# 차원축소가 일어남 -> scalar   
1 
>>> s1[0:1] # 차원 축소 x (Series 반환.)
0    1
dtype: int64
```



- `iloc` : positional indexing. index의 번호 순서를 기준으로 호출. 일반적인 파이썬 인덱싱과 같음.
- `loc`  : label indexing. 지정 index 호출. 슬라이스를 지정한 끝지점까지 포함해서 호출.

```python
>>> s1.iloc[0:1]
0    1
dtype: int64

>>> s1.loc[0:1]
0    1
1    2
dtype: int64

>>> s3.loc['a':'b']
a    1
b    2
dtype: int64
```
- `iloc`, `loc` 메서드를 사용하지 않고 인덱스를 호출하는 경우에 `int` 인덱스일 때 `iloc`이, `str` 인덱스일 때 `loc`이 사용되는 것으로 보임. 주의
```python
# iloc 적용
>>> s1[0:1]
0    1
dtype: int64

# loc 적용
>>> s3['a':'b']
a    1
b    2
dtype: int64
```

- 조건문을 입력해 bool 형식의 인덱스도 가능.

```python
>>> s1>2
0    False
1    False
2     True
3     True
dtype: bool

>>> s1[s1>2]
2    3
3    4
dtype: int64
```





### 2. DataFrame

- DataFrame에서도 마찬가지로 iloc, loc이 사용 가능하며 Series에서와 법칙이 동일함.
- Series에서 처럼 한 element를 호출하면 scalar값을 반환하며, 슬라이스 등에서는 Series 혹은 DataFrame을 반환.
- 조건을 걸어 bool 타입의 색인 또한 가능.

```python
>>> d1 = {'name': ['smith', 'will'], 'sal':[900,1800]}

>>> d2 = pd.DataFrame(d1)
    name   sal
0  smith   900
1   will  1800

>>> d3 = pd.DataFrame(np.arange(1,7).reshape(2,-1), columns=['col1','col2','col3'], index=['a','b'])
   col1  col2  col3
a     1     2     3
b     4     5     6

# 컬럼 선택
>>> d3.col1     # d3['col1']
a    1
b    4
Name: col1, dtype: int32

# iloc : 위치 index로 호출
>>> d3.iloc[:,0]
a    1
b    4
Name: col1, dtype: int32
>>> d3.iloc[:,0:3]
   col1  col2  col3
a     1     2     3
b     4     5     6
>>> d3.iloc[:,[0,-1]]
   col1  col3
a     1     3
b     4     6

# loc : index, col의 라벨로 호출
>>> d3.loc[:,['col1','col2']]
   col1  col2
a     1     2
b     4     5
>>> d3.loc[:,:'col2']
   col1  col2
a     1     2
b     4     5
>>> d3.loc[:'b']
   col1  col2  col3
a     1     2     3
b     4     5     6
```

