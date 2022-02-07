### 1. Drop

**DataFrame.drop(labels=None, axis=0, index=None, columns=None, level=None, 								inplace=False, errors='raise')**

- 특정 컬럼, 행을 제거

```python
>>> emp = pd.read_csv('./data/emp.csv') 
   empno  ename  deptno   sal
0      1  smith      10  4000
1      2  allen      10  4500
2      3   ford      20  4300
3      4  grace      10  4200
4      5  scott      30  4100
5      6   king      20  4000

# 조건색인을 통한 특정 row 삭제. (scott 삭제.)
>>> emp['ename'] =='scott'          # bool 타입 Series 호출
0    False
1    False
2    False
3    False
4     True
5    False
Name: ename, dtype: bool

>>> emp.drop(emp.loc[emp['ename']=='scott'].index)  # 인덱스를 기준으로 드랍
   empno  ename  deptno   sal
0      1  smith      10  4000
1      2  allen      10  4500
2      3   ford      20  4300
3      4  grace      10  4200
5      6   king      20  4000

>>> emp.loc[~(emp.ename == 'scott')]                # scott 제외 호출.
   empno  ename  deptno   sal
0      1  smith      10  4000
1      2  allen      10  4500
2      3   ford      20  4300
3      4  grace      10  4200
5      6   king      20  4000

 
# column 삭제
>>> emp.drop(['ename','deptno'], axis=1)
   empno   sal
0      1  4000
1      2  4500
2      3  4300
3      4  4200
4      5  4100
5      6  4000

```

### 2. Shift

**Series.shift(periods=1, freq=None, axis=0, fill_value=None)**

- 행 또는 열을 이동. `axis`와 `periods`를 통해 세부설정 가능. `Dataframe`, `index`에도 해당 메서드가 있음.
- `shift` 후 생기는 공란에 대해서도 설정이 가능하며 기본값은 `None`.

```python
# 예제) 다음 데이터 프레임에서 전일자 대비 증감율 출력
>>> s1 = pd.Series([3000,3500,4200,2800,3600], index=['2021/01/01','2021/01/02','2021/01/03','2021/01/04','2021/01/05'])

>>> (s1 - s1.shift()) / s1.shift() * 100
2021/01/01          NaN
2021/01/02    16.666667
2021/01/03    20.000000
2021/01/04   -33.333333
2021/01/05    28.571429
dtype: float64
```



### 3. rename

**DataFrame.rename(mapper=None, index=None, columns=None, axis=None, 										copy=True, inplace=False, level=None, errors='ignore')**

- 행, 컬럼명을 변경.  index,  Series에서도 해당 메서드를 사용 가능.
- 인덱스와 컬럼, `axis`를 지정할 수 있으며 멀티인덱스의 경우 `level`을 선택해야 한다.
- `mapper`에 메서드 혹은 함수를 입력 가능.

```python
>>> emp.columns = ['empno', 'ename', 'deptno', 'salary']
   empno  ename  deptno  salary
0      1  smith      10    4000
1      2  allen      10    4500
2      3   ford      20    4300
3      4  grace      10    4200
4      5  scott      30    4100
5      6   king      20    4000

>>> emp.rename({'salary':'sal', 'deptno':'dept_no'}, axis=1)
   empno  ename  dept_no   sal
0      1  smith       10  4000
1      2  allen       10  4500
2      3   ford       20  4300
3      4  grace       10  4200
4      5  scott       30  4100
5      6   king       20  4000

# 예제> emp에서 ename을 index로 설정 후 scott을 SCOTT로 변경하시오
>>> emp = pd.read_csv('./data/emp.csv') 
>>> emp.set_index('ename').rename({'scott':'SCOTT'}, inplace=True)
   empno  ename  deptno   sal
0      1  smith      10  4000
1      2  allen      10  4500
2      3   ford      20  4300
3      4  grace      10  4200
4      5  SCOTT      30  4100
5      6   king      20  4000

# 메서드 사용.
>>> df.rename(str.lower, axis='columns')
   a  b
0  1  4
1  2  5
2  3  6
```

