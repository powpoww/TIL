## 1. 결측치, 이상치 처리



### 1.1 결측치 처리

```python
import pandas as pd
import numpy as np

# 숫자형 NA, 문자형 NA
>>> s1 = pd.Series([1,2,3,np.nan])
>>> s2 = pd.Series(['a','b','c',np.nan])
>>> s1.replace(np.nan, 0) # float
# 0    1.0
# 1    2.0
# 2    3.0
# 3    0.0
# dtype: float64
>>> s2.replace(np.nan, 'a') # object
# 0    a
# 1    b
# 2    c
# 3    a
# dtype: object

# null 탐색
>>> s1[s1.isnull()] = 0
# 0    1.0
# 1    2.0
# 2    3.0
# 3    0.0
# dtype: float64

# 2. NA 로의 수정
>>> s3 = pd.Series(['서울','.','대전','.','대구','.','부산'])
>>> s3.replace('.', np.nan)
# 0     서울
# 1    NaN
# 2     대전
# 3    NaN
# 4     대구
# 5    NaN
# 6     부산
# dtype: object

# NA를 이전 값, 이후 값으로 수정
>>> s4 = s3.replace('.', np.nan)
>>> s4.fillna(method='ffill') # NA를 앞의 값으로 치환
>>> s4.ffill()
0    서울
1    대전
2    대전
3    대구
4    대구
5    부산
6    부산
dtype: object
>>> s4.fillna(method='bfill')
>>> s4.bfill()
0    서울
1    대전
2    대전
3    대구
4    대구
5    부산
6    부산
dtype: object

# NA를 갖는 행, 열 제거
>>> df1 = pd.DataFrame(np.arange(1,17).reshape(4,4), columns=list('ABCD'))
>>> df1.iloc[0,0] = np.nan
>>> df1.iloc[1,[0,1]] = np.nan
>>> df1.iloc[2, [0,1,2]] = np.nan
>>> df1.iloc[3,:] = np.nan
>>> df1
#     A    B    C     D
# 0 NaN  2.0  3.0   4.0
# 1 NaN  NaN  7.0   8.0
# 2 NaN  NaN  NaN  12.0
# 3 NaN  NaN  NaN   NaN

>>> df1.dropna()
>>> df1.dropna(how='any') # 1개라도 포함한 row 제거
>>> df1.dropna(how='all') # 모든값이 null인 row 제거

# drop 기준이 되는 Na 값을 설정 가능.
>>> df1.dropna(thresh=2)
#     A    B    C    D
# 0 NaN  2.0  3.0  4.0
# 1 NaN  NaN  7.0  8.0
>>> df1.dropna(thresh=2, axis=1)
#      C     D
# 0  3.0   4.0
# 1  7.0   8.0
# 2  NaN  12.0
# 3  NaN   NaN

# 특정 컬럼을 기준으로 NaN drop.
>>> df1.dropna(subset=['C'])
    A    B    C    D
0 NaN  2.0  3.0  4.0
1 NaN  NaN  7.0  8.0




# 문제> df1의 a컬럼의 결측치를 a컬럼의 최소값으로 대치 후 전체 평균 계산

# check col a's data
>>> df1 = pd.read_csv('./data/file1.txt')
     a   b   c   d
0    1   2   3   4
1    5   6   7   8
2    9  10  11  12
3    .  13  14  15
4   16  17  18  19
5  NaN  20  21  22

>>> df1.a = pd.to_numeric(df1.a, errors='coerce') # value를 int 등 숫자형으로 변경. str은 NaN 치환
>>> df1.loc[df1.a.isna(), 'a'] = df1.a.min()
>>> df1.a.mean()
5.5
```



### 1.2 중복값 처리

```python
s1 = pd.Series([1,1,2,3,4])
# 고유값 출력
s1.unique()
array([1, 2, 3, 4], dtype=int64)

s1.duplicated() # 중복값 확인. bool타입 Series 반환
0    False
1     True
2    False
3    False
4    False
dtype: bool
s1.drop_duplicates() # 중복값 제거
0    1
2    2
3    3
4    4
dtype: int64

df2 = pd.DataFrame({'A':[1,1,3,4], 'B':[10,10,30,40]})
df2.drop_duplicates(keep='last') # 마지막 중복값을 남김
   A   B
1  1  10
2  3  30
3  4  40

# 모든 컬럼값이 일치하는 행 제거
df3 = pd.DataFrame({'A':[1,1,3,4], 'B':[10,10,30,40], 'C':[100,200,300,400]})
df3.drop_duplicates() # 첫 중복값을 남김
   A   B    C
0  1  10  100
1  1  10  200
2  3  30  300
3  4  40  400

# A, B 컬럼값이 동일한 row 제거
df3.drop_duplicates(subset=['A','B'])
   A   B    C
0  1  10  100
2  3  30  300
3  4  40  400
```



### 1.3 이상치(outlier)

- 이상치란 일반적인 범위를 벗어난 데이터를 뜻하며 삭제 또는 대치 처리를 한다.
- 다양한 이상치 탐색기법이 존재하지만 데이터마다 이상치 구간이 정의된 경우가 많음.
- Box plot으로 확인하는게 좋다.

```python
# 문제 > df1의 d 컬럼에서 16 아싱인 경우를 이상치로 판단할 것이다.
# 이상치를 제외한 나머지에 대해 최대값으로 이상치를 대치한 후 평균을 계산하라.
>>> M_ = df1.d[df1.d<16].max()
>>> df1.loc[df1.d>=16, 'd'] = M_
      a   b   c   d
0   1.0   2   3   4
1   5.0   6   7   8
2   9.0  10  11  12
3   1.0  13  14  15
4  16.0  17  18  15
5   1.0  20  21  15
>>> df1.d.mean()
11.5
```







## 2. Scailing

​	표준화(Scailing)은 설명변수의 서로 다른 범위를 동일한 범주 내에서 비교하기 위한 작업이다.  데이터가 가지고 있는 이상치에 덜 민감하게 할 수 있으며 각 설명변수의 중요도를 정확하게 비교하기 위해 요구된다. `KNN`, `clustering`, `PCA`, `SVM`, `NN` 등의 모델에 사용하기 전 필요한 작업. 스케일링은 standard scailing, minmax scailing, robust scailing 등이 있다. 학습, 테스트셋을 나눌 경우 스케일링은 학습데이터를 기준으로 해야 한다.

### 2.1  Standard Scailing

- 평균을 0, 표준편차를 1로 하는 스케일링. 

```python
from sklearn.preprocessing import StandardScaler as standard
from sklearn.preprocessing import MinMaxScaler as minmax
import numpy as np
import pandas as pd

# Loading Iris Data
from sklearn.datasets import load_iris

iris_x = load_iris().data
iris_y = load_iris().target

# 1) standard scailing(표준화) : (x - x.mean) / x.std

ss_x1 = (iris_x - iris_x.mean(axis=0)) / iris_x.std(axis=0)

standardScaler = standard()
standardScaler.fit(iris_x)                    # 데이터정보를 모델에 입력
ss_x2 = standardScaler.transform(iris_x)      # 변환할 데이터 입력

print(ss_x1.min() == ss_x2.min(), ss_x1.max() == ss_x2.max())
```



### 2.2 MinMax Scailing

- 데이터의 범주를 0~1 사이로 조정하는 방법. 

```python
# 2) minmax scailing : (x - x.min) / (x.max - x.min)
ms_x1 = (iris_x - iris_x.min(0)) / (iris_x.max(0)-iris_x.min(0))
minmaxScaler = minmax()
minmaxScaler.fit(iris_x)                # 데이터정보를 모델에 입력
ms_x2 = minmaxScaler.transform(iris_x)  # 변환할 데이터 입력

print(ms_x1.mean() == ms_x2.mean())

# train/test로 분리된 데이터를 표준화.
from sklearn.model_selection import train_test_split

train_x, test_x, train_y, test_y = train_test_split(iris_x, iris_y)

# 1) train_x, test_x 동일 기준으로 스케일링
minmaxScaler = minmax()
minmaxScaler.fit(train_x)

train_mm2 = minmaxScaler.transform(train_x)
test_mm2 = minmaxScaler.transform(test_x)

print(train_mm2.min(0), train_mm2.max(0), test_mm2.min(0), test_mm2.max(0))

# 2) train_x, test_x 다른 기준으로 스케일링
minmaxScaler_train = minmax()
minmaxScaler_test = minmax()
minmaxScaler_train.fit(train_x)
minmaxScaler_test.fit(test_x)

train_mm1 = minmaxScaler_train.transform(train_x)
test_mm1 = minmaxScaler_test.transform(test_x)

print(train_mm2.min(0), train_mm2.max(0), test_mm2.min(0), test_mm2.max(0))
```

**시각화**

```python
# scaling 시각화
# 1) figure, subplot 생성
import matplotlib.pyplot as plt
fig, ax = plt.subplots(1,3)

# 2) 원본 data의 산점도
import mglearn

ax[0].scatter(train_x[:,0], train_x[:,1], c=mglearn.cm2(0), label='train')
ax[0].scatter(test_x[:,0], test_x[:,1], c=mglearn.cm2(1), label='test')
ax[0].legend()
ax[0].set_title('raw data')

# 4) 잘못된 스케일링 data의 산점도(train_mm1, test_mm1)

ax[1].scatter(train_mm1[:,0], train_mm1[:,1], c=mglearn.cm2(0), label='train')
ax[1].scatter(test_mm1[:,0], test_mm1[:,1], c=mglearn.cm2(1), label='test')
ax[1].legend()
ax[1].set_title('bad scaing data')


# 3) 올바른 스케일링 data의 산점도(train_mm2, test_mm2)

ax[2].scatter(train_mm2[:,0], train_mm2[:,1], c=mglearn.cm2(0), label='train')
ax[2].scatter(test_mm2[:,0], test_mm2[:,1], c=mglearn.cm2(1), label='test')
ax[2].legend()
ax[2].set_title('good scaling data')
```

