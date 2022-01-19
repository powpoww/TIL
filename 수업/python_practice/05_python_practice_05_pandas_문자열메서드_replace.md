### 1. 문자열 메서드



- 기본 메소드에서는 벡터 연산이 불가능하여 리스트 내 매 원소마다 반복이 불가능하다. 때문에 map을 사용해 벡터연산화 시킨다.
- pandas 메소드 : 벡터화가 내장되어 매 원소마다 반복이 가능하다. 이는 `Series`, `DataFrame` 모두 적용이 가능.



#### 1.1 Series.str

- `Series` 내의 `str`에 대하여 메서드를 일괄적으로 적용시키는 방법. 

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



#### **1.2 str.replce(치환, 삭제)**

- `str`의 메서드로 오직 문자열 치환만 가능하다. (`int`, `NaN` 불가)
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

 

#### 1.3 Series.str.replce

- 벡터화 내장된 문자열 메서드로 문자열 element 호출 가능
- 벡터 연산(각 원소별 반복 처리) 가능
- 오직 `Series`의 `dtype`이 `object`, `str`인 치환만 가능. (`float`, `int` 불가능)
- `dtype`이 `object`인 `Series`에서는(`str`, `float`, `int` 등 혼합 `Series`) `float`, `int` 등은 `NaN`으로 반환
- `Series`내의 item을 호출해 item 내의 문자에 대해 직접 적용.

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

 

#### 1.4 Dataframe.replace

- `DataFrame`의 `Series`를 호출해 각 item에 적용해 입력값과 비교하여 동일할 때 치환, 삭제 등 명령 수행. (`DataFrame.str`은 불가)
- `int`, `NaN` 치환 가능하며 동시에 여러 대상 수정 가능

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

