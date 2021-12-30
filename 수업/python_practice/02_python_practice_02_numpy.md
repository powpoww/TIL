# 02. Python Practice - Numpy

넘파이(Numpy)는 Python에서 벡터, 행렬 등 수치 연산을 수행하는 선형대수(Linear algebra) 라이브러리입니다. 선형대수 관련 수치 연산을 지원하고 내부적으로는 C로 구현되어 있어 연산이 빠른 속도로 수행됩니다.

 

- ndarray.ndim : 축의 개수
- ndarray.shape : 배열의 차원 및 크기를 튜플 형태로 표현.
- ndarray.size : 배열의 총 개수 (shape : 3x2, size : 6)
- ndarray.dtype : 배열의 유형. (numpy.int32, numpy.float64 등)
- ndarray.itemsize : 배열의 각 요소(element)의 크기.

 

**# 메서드**

- ndarray.any() : true가 하나라도 있으면 true 반환.
- ndarray.all() : 모든 element가 true면 true 반환.
- ndarray.swapaxes(axis) : 두 축을 전달받아 두 축을 서로 전치. (순서상관없음)
- ndarray.transpose(axis) : 원본의 차원에 맞는 축번호를 인수에 차례로 받고 전치. (순서상관있음)

 

**# 함수**

- .ix_() : 서로 다른 shape를 가진 배열들을 묶어서 처리하는 함수.

```
a = np.arange(10).reshape(2, 5)
#array([[0, 1, 2, 3, 4],
#       [5, 6, 7, 8, 9]])

ixgrid = np.ix_([0, 1], [2, 4])
#(array([[0],
#       [1]]), array([[2, 4]]))

ixgrid[0].shape, ixgrid[1].shape
#((2, 1), (1, 2))

a[ixgrid]
#array([[2, 4],
#       [7, 9]])
```

 

#### **1. 배열 조작**

- np.zeros(shape) : 입력된 차원으로 된 0으로 이루어진 행렬 생성
- np.ones(shape) : 입력된 차원으로 된 1으로 이루어진 행렬 생성
- np.empty(shape)  : 입력된 차원으로 된 무작위 값으로 이루어진 행렬 생성
- ndarray.reshape(shape) : 입력된 차원으로 데이터 shape를 변경. axis가 큰 순서부터 요소가 할당됨.
- ndarray.flatten() : arr을 1차원으로 축소. aixs가 큰 순서부터 요소가 할당됨. (copy)
- ndarray.ravel() : arr을 1차원으로 축소. aixs가 큰 순서부터 요소가 할당됨. (non copy)



<img src="https://blog.kakaocdn.net/dn/GdGOe/btrnXZMuuPL/fRQkpHr6caPW1UR4YHFYZ1/img.png" alt="img" style="zoom: 50%;" />



#### **2. 배열 연산**

 

**## 2차원 행렬**

- \* : 대응하는 element간 곱셈 연산
- @ : 행렬 곱셈(matrix product)
- .dot() : 행렬 내적 (dot product)

**## 모든 차원**

- .argmax() / .argmin() : 요구 조건에 해당하는 요소의 인덱스
- .cumsum() : 모든 요소의 누적합

**## Broadcasting**



<img src="https://blog.kakaocdn.net/dn/pKIop/btrn6G438MY/iGgXwhZkpAiFTl3kwjiNX0/img.jpg" alt="img" style="zoom:50%;" />



 

 

#### **3. 인덱스 및 슬라이스**

- **정수 인덱스** : 차원 축소가 발생. ex) 2차원 -> 1차원

```
a1 = np.arange(1,26)
a2 = np.arange(1,10).reshape(3,3)
a2
# array([[1, 2, 3],
#        [4, 5, 6],
#        [7, 8, 9]])

# 정수 인덱스 : 차원 축소 발생
a2[1,:]
a2[:,1]
#array([2, 5, 8]) : 2차원->1차원
```

 

 

- **슬라이스** : 차원 축소 발생하지 않음. v[x:y]가 리스트를 반환하기 때문.
- 같은 의미로 ndarray의 인덱스, 슬라이스에는 lst, array, tuple 입력하여 색인 가능

```
a2[:,1:2]
# array([[2],
#        [5],
#        [8]])

a2[[0,2],:] 		# 동일 : a2[0:3:2,:]
#array([[1, 2, 3],
#       [7, 8, 9]])
```

 

- **포인트 인덱싱** : 지정한 지점 사이의 elment를 반환

```
a2[np.ix_([1,2],[1,2])]
# array([[5, 6],
#        [8, 9]])

a2[1:3, 1:3]
# array([[5, 6],
#        [8, 9]])
```

 

- **조건 색인** : ndarray에 조건을 걸었을 때, 각 element가 조건에 부합하는지 같은 shape의 bool타입 결과를 반환.
- ndarray에 bool타입의 동일 array를 입력했을 때, True에 해당하는 값을 반환함.
- 마찬가지로 각 행열에 bool 타입의 list를 넣어도 인덱싱이 가능.

```
a2
#array([[1, 2, 3],
#       [4, 5, 6],
#       [7, 8, 9]])
       
a2>5 # a2와 동일한 arr로 True False 결과 출력
# array([[False, False, False],
#        [False, False,  True],
#        [ True,  True,  True]])

a2[a2>5] # True 값만 출력
# array([6, 7, 8, 9])

# 첫 col 중 5보다 큰 row만 선택
a2[a2[:,0] > 5 ]
#array([[7, 8, 9]])

----------------------------------------------------------------

# bool indexing
a = np.arange(12).reshape(3, 4)
b1 = np.array([False, True, True])         # first dim selection
b2 = np.array([True, False, True, False])  # second dim selection

a[b1, :]                                   # selecting rows
#array([[ 4,  5,  6,  7],
#       [ 8,  9, 10, 11]])

a[b1]                                      # same thing
#array([[ 4,  5,  6,  7],
#       [ 8,  9, 10, 11]])

a[:, b2]                                   # selecting columns
#array([[ 0,  2],
#       [ 4,  6],
#       [ 8, 10]])

a[b1, b2]                       # a weird thing to do
array([ 4, 10])                 # 연속형이 아니면 각 point의 element만 반환함.
```

 

#### **4. np.where **

- if문의 축약형. sql 문 기본 형태 : select * from db where ---
- np.where(조건, 참인 값 반환, 거짓인 값 반환). 조건만 있으면 인덱스를 반환함.

```
np.where(a2>5,'A','B')
# array([['B', 'B', 'B'],
#        ['B', 'B', 'A'],
#        ['A', 'A', 'A']], dtype='<U1')

np.where(a2>5)  # index 반환
# (array([1, 2, 2, 2], dtype=int64), array([2, 0, 1, 2], dtype=int64))
```
