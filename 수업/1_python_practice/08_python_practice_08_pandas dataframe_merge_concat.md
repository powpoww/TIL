### 1. Concat

**pandas.concat(objs, axis=0, join='outer', ignore_index=False, keys=None, levels=None, names=None, verify_integrity=False, sort=False, copy=True)**

- 두 데이터 프레임을 하나로 합치는 작업. `axis`로 column, row 방향의 병합을 설정할 수 있음.
- `ignore_index`: 병합 후 인댁스를 재설정.
- `join`: `outer`은 모두 합치며 공통되지 않은 곳은 `NaN`을 반환하며  `inner` 는 공통되지 않은 곳은 삭제처리를 한다.
- `key`: 데이터프레임별 키를 지정하면 상위 레벨의 인덱스로 병합이 된다.

```python
>>> df1 = pd.DataFrame(np.arange(1,7).reshape(2,3), columns=list('ABC'))
>>> df2 = pd.DataFrame(np.arange(10,61,10).reshape(2,3), columns=list('ABC'))
>>> pd.concat([df1, df2])           # axis=0 방향 결합. index는 원본 df 유지.
    A   B   C
0   1   2   3
1   4   5   6
0  10  20  30
1  40  50  60
>>> pd.concat([df1, df2], axis=1)   # aixs=1 방향 결합. col은 원본 df 유지.
   A  B  C   A   B   C
0  1  2  3  10  20  30
1  4  5  6  40  50  60
>>> pd.concat([df1, df2], ignore_index=True) # 원본 index를 초기화 하고 정렬순으로 재할당.
    A   B   C
0   1   2   3
1   4   5   6
2  10  20  30
3  40  50  60

# key를 할당해 multiindex 생성가능
>>> pd.concat([df1, df2], keys=['df1','df2'])
        A   B   C
df1 0   1   2   3
    1   4   5   6
df2 0  10  20  30
    1  40  50  60

# column 방향 병합일 때 index별로 병합 시도. 
# join = outer : 일치하지 않으면 NaN값 반환.
# join = inner : 일치하지 않으면 삭제
>>> df1.index=[1,2]
>>> pd.concat([df1, df2], axis=1)
     A    B    C     A     B     C
0  NaN  NaN  NaN  10.0  20.0  30.0
1  1.0  2.0  3.0  40.0  50.0  60.0
2  4.0  5.0  6.0   NaN   NaN   NaN

>>> pd.concat([df1, df2], axis=1, join='inner')
   A  B  C   A   B   C
1  1  2  3  40  50  60
```



### 2. Merge

**pandas.merge(left, right, how='inner', on=None, left_on=None, right_on=None, left_index=False, right_index=False, sort=False, suffixes=('_x', '_y'), copy=True, indicator=False, validate=None)**

- 두 데이터프레임 참조조건 활용해 하나의 객체로 합치거나 데이터를 처리하는 행위. 등가 조건만을 사용하여 조인이 가능.
- `left`, `right` :첫번째, 두번째 데이터 프레임
- `how` : 조인 방법. `inner`, `outer`등이 있다. `concat`의 방식과 같음.
- `on` : 조인하는 컬럼명 (컬럼명이 같을 때)
- `left_on`, `right`: 첫번째  혹은 두번째 데이터 프레임명에 조인 (컬럼명이 다를 때)

```python
>>> df_dept_new = pd.DataFrame({'deptno':[10,20], 'dname':['인사총무부','IT분석팀']})
>>> emp = pd.read_csv('./data/emp.csv')
   empno  ename  deptno   sal
0      1  smith      10  4000
1      2  allen      10  4500
2      3   ford      20  4300
3      4  grace      10  4200
4      5  scott      30  4100
5      6   king      20  4000

>>> pd.merge(emp, df_dept_new, on='deptno')
   empno  ename  deptno   sal  dname
0      1  smith      10  4000  인사총무부
1      2  allen      10  4500  인사총무부
2      4  grace      10  4200  인사총무부
3      3   ford      20  4300  IT분석팀
4      6   king      20  4000  IT분석팀

>>> pd.merge(emp, df_dept_new, on='deptno', how='outer')
   empno  ename  deptno   sal  dname
0      1  smith      10  4000  인사총무부
1      2  allen      10  4500  인사총무부
2      4  grace      10  4200  인사총무부
3      3   ford      20  4300  IT분석팀
4      6   king      20  4000  IT분석팀
5      5  scott      30  4100    NaN

```

