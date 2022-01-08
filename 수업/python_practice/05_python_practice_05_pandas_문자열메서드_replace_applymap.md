# 01. Python Practice - 문자열 메서드



- 기본 메소드에서는 벡터 연산이 불가능하여 리스트 내 매 원소마다 반복이 불가능하다. 때문에 map을 사용해 벡터연산화 시킨다.
- pandas 메소드 : 벡터화가 내장되어 매 원소마다 반복이 가능하다. 이는 Series, DataFrame 모두 적용이 가능.



#### 1. Series.str

- Series 내의 str에 대하여 메서드를 일괄적으로 적용시키는 방법. 

```python
>>> s1 = pd.Series(l1)
0    abc
1    def
dtype: object
>>> s2 = pd.Series(l2)
0    a/b/c
1    d/e/f
dtype: object

>>> s1.str.upper()
>>> s1.str.lower()
>>> s1.str.title()
>>> s1.str.replace('a','A')
>>> s2.str.split('/')
>>> s1.str.len() # 각 원소의 크기
>>> s1[s1.str.endswith('c')]
>>> s1[s1.str.contains('e')]

# 예제> 천단위 구분기호 처리
>>> s3 = pd.Series(['1,200', '3,000', '4,000'])
>>> s3.str.replace(',','').astype(int).sum()

# count. 포함된 개수
>>> pd.Series(['aabca', 'abcdsa']).str.count('a')

# strip (제거함수 : 공백, 문자)
>>> pd.Series(['      cd   ', '   df   ']).str.strip()
>>> pd.Series(['      cd   ', '   df   ']).str.strip().str.len()

# find : 위치값 반환.
>>> s3 = pd.Series(['abc@abc.com', 'avcddsa@abc.com'])
>>> s3.str[:s3.str.find('@')]

# 예제. 이메일 아이디 추출
# 방법1
>>> s3 = pd.Series(['abc@abc.com', 'avcddsa@abc.com'])
>>> s3.map(lambda x : x[:x.find('@')]).tolist()

# 방법2
>>> vno=s3.str.find('@')
>>> list(map(lambda x,y : x[:y], s3, vno))
```



#### **1.1 str.replce(치환, 삭제)**

- str의 메서드로 오직 문자열 치환만 가능하다. (숫자, NaN 불가)
- 벡터 연산이(각 원소별 반복 처리) 불가능.

```python
# str 적용 (str외 적용 불가)
>>> 'abcd'.replace('a','A')
>>> 'abcd'.replace('a','')

# 리스트 적용
>>> f1 = lambda x : x.replace('a','A')
>>> list(map(f1, ['abcd','abcde','aabb']))

>>> pd.Series(['abcd','abcde','aabb']).map(f1)
>>> pd.Series(['abcd','abcde','aabb', np.nan]).map(f1)
AttributeError: 'float' object has no attribute 'replace'
```

 

#### 1.2 Series.str.replce

- 벡터화 내장된 문자열 메서드로 문자열 element 호출 가능
- 벡터 연산(각 원소별 반복 처리) 가능
- 오직 Series의 dtype이 object, str인 치환만 가능. (float, int 불가능)
- dtype이 object인 Series에서는(str, float, int 등 혼합 Series) float, int 등은 NaN으로 반환
- Series내의 item을 호출해 item 내의 문자에 대해 직접 적용.

```python
# int에 적용 불가
>>> pd.Series([1,2,3,4,np.nan]).str.replace('a','A')
AttributeError: Can only use .str accessor with string values!

# skip NaN value
>>> pd.Series(['abcd','abcde','aabb', np.nan]).str.replace('a','A')
0     Abcd
1    Abcde
2     AAbb
3      NaN
dtype: object

# 타입이 복합된 object Series에서는 문자 외 item을 NaN으로 반환.
>>> pd.Series(['a',2,3,4.1,np.nan]).str.replace('a','A') 
0      A
1    NaN
2    NaN
3    NaN
4    NaN
dtype: object
```

 

#### 1.3 Dataframe.replace

- DataFrame의 Series를 호출해 각 item에 적용해 입력값과 비교하여 동일할 때 치환, 삭제 등 명령 수행. (DataFrame.str은 불가)
- 숫자, NaN 치환 가능하며 동시에 여러 대상 수정 가능

```python
>>> df1 = pd.DataFrame([['1,200','1,300'],['1,400','1,500']])
>>> df1.replace(',','')
       0      1
0  1,200  1,300
1  1,400  1,500

>>> df2 = pd.DataFrame([['1,200',','],['1,400',',']])
>>> df2.replace(',','')
       0 1
0  1,200  
1  1,400  

>>> df3 = pd.DataFrame([['1200','1300'],['1400','.']], columns=['a','b'])
>>> df3.replace(['.', '1400', '?', '!'], np.nan)
      a     b
0  1200  1300
1   NaN   NaN

>>> test = pd.DataFrame([[1,2,'a'], ['b',np.nan,4]])
>>> test.replace([1,'a'],np.nan)
     0  1    2
0  NaN  2  NaN
1    b  N  4.0

# 연습문제. df1에 천단위 구분기호 제거 후 모두 숫자 변경
>>> df1.applymap(lambda x : x.replace(',','')).astype('int')
```

 

### 2. Dataframe.apply / Dataframe.applymap

- apply : DataFrame 내의 각 axis에 따른 Series에 적용
- applymap : Data Frame 내의 각 element에 적용
- Series에는 apply, map 사용가능.

```python
>>> df4 = pd.DataFrame([['a',2,np.nan],[1,'b',np.nan]])
   0  1   2
0  a  2 NaN
1  1  b NaN

>>> df4.apply(lambda x: print(x)) 
각 Seriesd에 적용 (axis 축에 따라. )
0    a
1    1
Name: 0, dtype: object
0    2
1    b
Name: 1, dtype: object
0   NaN
1   NaN
Name: 2, dtype: float64

# 각 axis 축에 따른 Series를 호출, 적용되므로 dtype: float64인 3번째 col에서 error발생.
>>> df4.apply(lambda x: print(x.str.replace('a','A'))) 
0      A
1    NaN
Name: 0, dtype: object
0    NaN
1      b
Name: 1, dtype: object
Traceback (most recent call last):
AttributeError: Can only use .str accessor with string values!

# 각 element에 적용되어 에러.
>>> df4.applymap(lambda x : x.replace(',',''))
AttributeError: 'int' object has no attribute 'replace'
```
