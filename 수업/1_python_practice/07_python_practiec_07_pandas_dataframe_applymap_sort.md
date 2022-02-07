### 1. Applymap



#### 1.1  Series.str.replace와 Dataframe.replace의 차이

- `Series.str.replace`는 `value`의 패턴 혹은 `regex`(정규식)을 바꾸며 `Dataframe.replace`는 조건에 맞는 `value`를 지정 값으로 바꾸는 것이다.

```python
>>> pd.Series(['abcd','abcde','aabb', np.nan]).str.replace('a','A')
0     Abcd
1    Abcde
2     AAbb
3      NaN
dtype: object

# dtype이 int인 Series에는 적용 불가
>>> pd.Series([1,2,3,4,np.nan]).str.replace('a','A')
# AttributeError: Can only use .str accessor with string values!

# dtype이 object인 Series에는 적용 가능. str외 value를 NaN으로 반환.
>>> pd.Series(['a',2,3,4,np.nan]).str.replace('a','A') # int > Nan 반환
0      A
1    NaN
2    NaN
3    NaN
4    NaN


# 일치하는 value가 없기 때문에 작동하지 않음.
>>> df1 = pd.DataFrame([['1,200','1,300'],['1,400','1,500']])
>>> df1.replace(',','')
       0      1
0  1,200  1,300
1  1,400  1,500


>>> df = pd.DataFrame({'A': [0, 1, 2, 3, 4],
>>>                    'B': [5, 6, 7, 8, 9],
>>>                    'C': ['a', 'b', 'c', 'd', 'e']})

# 각 value별로 to_replace 지정 가능
>>> df.replace({0: 10, 1: 100})
        A  B  C
0   10  5  a
1  100  6  b
2    2  7  c
3    3  8  d
4    4  9  e
# 각 column에 해당하는 value를 치환 가능
>>> df.replace({'A': 0, 'B': 5}, 100)
        A    B  C
0  100  100  a
1    1    6  b
2    2    7  c
3    3    8  d
4    4    9  e
# 각 컬럼내에 value마다 to_replace 지정 가능.
>>> df.replace({'A': {0: 100, 4: 400}})
        A  B  C
0  100  5  a
1    1  6  b
2    2  7  c
3    3  8  d
4  400  9  e


# 연습문제. df1에 천단위 구분기호 제거 후 모두 숫자 변경
>>> df1.applymap(lambda x : x.replace(',','')).astype('int')
```

- 그 외에 정규식을 넣어 치환도 가능.

```python
# 알파벳 문자열 뒤집어 출력.
>>> repl = lambda m: m.group(0)[::-1]
>>> ser = pd.Series(['foo 123', 'bar baz', np.nan])
>>> ser.str.replace(r'[a-z]+', repl, regex=True)
0    oof 123
1    rab zab
2        NaN
dtype: object
    
# ba가 들어간 value 치환.
>>> df = pd.DataFrame({'A': ['bat', 'foo', 'bait'],
>>>                    'B': ['abc', 'bar', 'xyz']})
>>> df.replace(to_replace=r'^ba.$', value='new', regex=True)
     A    B
0   new  abc
1   foo  new
2  bait  xyz
```



#### 1.2 map, apply, applymap의 차이

- `Series`는 `map`, `apply` 사용 가능하며 `Dataframe`는 `apply`, `applymap` 사용 가능
  - `map` : `Series` 내의 `value`에 `func` 등을 적용하는 것. `na_action`으로 `Nan`에 적용 제외 가능.
  - `apply` : `axis`별 축에 `func`을 적용하는 것.
  - `applymap` : `dataframe`의 `value`마다 `func` 등을 적용하는 것. `na_action`으로 `Nan`에 적용 제외 가능.

```python
>>> s = pd.Series(['cat', 'dog', np.nan, 'rabbit'])
0      cat
1      dog
2      NaN
3   rabbit
dtype: object
>>> s.map('I am a {}'.format)
0       I am a cat
1       I am a dog
2       I am a nan
3    I am a rabbit
dtype: object
    
    
>>> df = pd.DataFrame([[4, 9]] * 3, columns=['A', 'B'])
   A  B
0  4  9
1  4  9
2  4  9
>>> df.apply(np.sum, axis=1)
0    13
1    13
2    13
dtype: int64
    
>>> df = pd.DataFrame([[1, 2.12], [3.356, 4.567]])
0  1.000  2.120
1  3.356  4.567
>>> df.applymap(lambda x: len(str(x)))
   0  1
0  3  4
1  5  5
```



### 2. Sort

- **DataFrame.sort_index(axis=0, level=None, ascending=True, inplace=False, kind='quicksort', na_position='last', sort_remaining=True, ignore_index=False, key=None)**
  `index`를 오름차순 혹은 내림차순 정렬하는 것. `ascending`이 `True`일 때 오름차순, `False`일 때 내림차순 정렬한다. `level`별로 지정할 수 있다.

- **DataFrame.sort_values(by, axis=0, ascending=True, inplace=False, kind='quicksort', na_position='last', ignore_index=False, key=None)**
  `sort_index`와 유시하다. `by`로 정렬할 `column`을 설정할 수 있음.

```python
>>> emp = pd.read_csv('./data/emp.csv')
   empno  ename  deptno   sal
0      1  smith      10  4000
1      2  allen      10  4500
2      3   ford      20  4300
3      4  grace      10  4200
4      5  scott      30  4100
5      6   king      20  4000

>>> emp.set_index('ename', inplace=True)
       empno  deptno   sal
ename                     
smith      1      10  4000
allen      2      10  4500
ford       3      20  4300
grace      4      10  4200
scott      5      30  4100
king       6      20  4000

>>> emp.sort_index(ascending=True)  # default : True. False : 내림차순
       empno  deptno   sal
ename                     
allen      2      10  4500
ford       3      20  4300
grace      4      10  4200
king       6      20  4000
scott      5      30  4100
smith      1      10  4000

>>> emp.sort_index(axis=1)          # 0: index기준, 1: col기준 오름차순 정렬
       deptno  empno   sal
ename                     
smith      10      1  4000
allen      10      2  4500
ford       20      3  4300
grace      10      4  4200
scott      30      5  4100
king       20      6  4000


# col의 value 기준으로 정렬.
>>> emp.sort_values(by='sal', ascending=False)  
       empno  deptno   sal
ename                     
smith      1      10  4000
king       6      20  4000
scott      5      30  4100
grace      4      10  4200
ford       3      20  4300
allen      2      10  4500

# 복수 col로 정렬 가능.
>>> emp.sort_values(by=['deptno','sal'], ascending=[True, False]) 
       empno  deptno   sal
ename                     
smith      1      10  4000
grace      4      10  4200
allen      2      10  4500
king       6      20  4000
ford       3      20  4300
scott      5      30  4100
```



