### 1. Python Practice - 내장함수



- `F9` : 라인단위 실행
- `ctrl+1` : 주석처리. (jupyter, pycharm : `ctrl+/`)





####  **1.1 변수생성**

- 변수란 값을 저장하기 위한 객채(object)로 명명 규칙은 다음과 같다.
  - 대소문자 구분이나 숫자로 시작이 불가.
  - 특수기호 삽입이 불가한 대신 언더바 사용 가능. (_str, _float 등)
  - 예약어 : 함수명, 함수 내 인자, 패키지 이름, if, for 등을 일컫는다.



#### 1.2 모듈(module)

모듈을 호출해 하위 함수를 사용해본다.

```python
import math
import math as ma # as (alias : 별칭)

# math 함수 사용
>>> ma.trunc(1.5)
1

# 산술연산
>>> 9//2    # 몫
4
>>> 9%2     # 나머지
1
>>> 3**2    # 거듭제곱
9
>>> math.pow(3,2) # 3의 제곱
9
```



### 2. 파이썬 기본 구조

#### 2.1 리스트(list)

- `index`는 `scalar`를 반환(non-dimension) `slice`는 `list`를 반환한다.

```python
# indexing
>>> l1 = [1,2,3,4]
>>> l1[-1] # reverse indexing
4

# multi-index 삽입 불가
>>> l1[0,2]
TypeError: list indices must be integers or slices, not tuple
>>> l1[[0,2]]
TypeError: list indices must be integers or slices, not tuple
    
# slicing
>>> l1[0:2]
[1, 2]

# modify an item in list
>>> l1[0] = 10
>>> l1
[10, 2, 3, 4]

# extend list 
>>> l1 + [5]
[10, 2, 3, 4, 5]
>>> l1.append(6) # inplace 된다.
>>> l1
[10, 2, 3, 4, 6]

# delete an item in list
>>> del(l1[0]) # 첫 번째 원소 삭제. inplace 된다.
>>> l1
[2, 3, 4, 6]
```



#### 2.2 함수(function)와 메서드(method)

- 함수 : 인수의 전달이 모두 괄호 안에서 진행
- 메서드 : 함수의 일부로 인수의 전달 방식이 다르다. 객체(object)에서 호출 가능한 형태의 함수.

```python
# 함수 
>>> sum([1,2,3])
6

# 메서드
>>> import numpy as np
>>> a1 = np.array([1,2,3])
>>> a1.sum()
6
```



#### 2.3 문자열 메서드

- `str.upper()` : 알파벳 대문자 치환.
- `str.lower()` : 알파벳 소문자 치환.
- `str.title()` : 첫 글자만 대문자 치환. (camel 표기법)
- `str.startswith(prefix, start, end)` : 문자열의 시작 값을 확인. prefix에 확인할 문자를, start, end로 수색 지점을 설정.
- `str.endswith(prefix, start, end)` : 문자열의 끝 값을 확인. prefix에 확인할 문자를, start, end로 수색 지점을 설정.
- `str.strip()` : 앞 뒤 공백 또는 문자 제거.
- `str.replace(old, new)` :  old의 문자를 new로 치환.
- `str.split(sep)` : sep 기호로 str을 분리.
- `str.find(sub, start, end)` : sub을 start부터 end index까지 찾고 index 반환.
- `str.count(sub)` : 문자열 내의 sub 개수 반환.
- `str.isalpha()` : 한글, 영문자 등 문자 확인.
- `str.isnumeric()` : 숫자여부 확인.
- `str.isupper()`, `str.islower()` : 대소문자 확인







