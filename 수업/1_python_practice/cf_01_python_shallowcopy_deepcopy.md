출저 : https://wikidocs.net/16038



# 얕은 복사(shallow copy)와 깊은 복사(deep copy)



## 1. mutable과 immutable 객체

**객체구분표**

|   class   |                  설명                   |   구분    |
| :-------: | :-------------------------------------: | :-------: |
|   list    |    mutable 한 순서가 있는 객체 집합     |  mutable  |
|    set    | mutable 한 순서가 없는 고유한 객체 집합 |  mutable  |
|   dict    |  key와 value가 맵핑된 객체, 순서 없음   |  mutable  |
|   bool    |                 참,거짓                 | immutable |
|    int    |                  정수                   | immutable |
|   float   |                  실수                   | immutable |
|   tuple   |   immutable 한 순서가 있는 객체 집합    | immutable |
|    str    |                 문자열                  | immutable |
| frozenset |             immutable한 set             | immutable |

**예시>**

1. list 내의 객체를 변경해도 list의 id는 변경이 없이 이루어짐. set, dict 또한 마찬가지다.

```python
>>> a = [1, 2, 3]
>>> id(a)
4393788808
>>> a[0] = 5
>>> a
[5, 2, 3]
>>> id(a)
4393788808

>>> x = {1, 2, 3}
>>> x
{1, 2, 3}
>>> id(x)
4396095304
>>> x|={4,5,6}
>>> x
{1, 2, 3, 4, 5, 6}
>>> id(x)
4396095304
```

2. str은 immutable로 s 내의 요소를 index로 변경할 수 없으며, s에 다른 값을 할당하면 변경이 된다.

```python
>>> s= "abc"
>>> s
'abc'
>>> id(s)
4387454680
>>> s[0]
'a'
>>> s[0] = 's'
Traceback (most recent call last):
File "<stdin>", line 1, in <module>
TypeError: 'str' object does not support item assignment
>>> s = 'def'
>>> s
'def'
>>> id(s)
4388970768
```



## 2. 변수 간 대입

### 2-1. mutable한 객체의 변수 간 대입

- list의 얕은 복사의 경우, b에 a를 할당하면 같은 메모리 주소를 바라본다. b를 변경할 경우 a도 같이 바뀌며 set, dict 또한 마찬가지다. 

```python
>>> a = [1, 2, 3]
>>> b = a # shallow copy
>>> b[0]= 5
>>> a
[5, 2, 3]
>>> b
[5, 2, 3]
>>> id(a)
4396179528
>>> id(b)
4396179528
```

### 2-2 immutable한 객체의 변수간 대입

- str의 얕은 복사는 b를 a에 할당하면 같은 메모리 주소를 본다. 하지만 b에 다른 값을 할당하면 메모리 주소가 변경된다.

```python
>>> a = "abc"
>>> b = a
>>> a
'abc'
>>> b
'abc'
>>> id(a)
4387454680
>>> id(b)
4387454680
>>> b = "abcd"
>>> a
'abc'
>>> b
'abcd'
>>> id(a)
4387454680
>>> id(b)
4396456400
```

## 3. deep copy & shallow copy

1. 리스트의 슬라이싱으로 새 값을 할당하면 새로운 id가 부여되며 영향을 받지 않음(깊은복사)

```python
>>> a = [1,2,3]
>>> b = a[:]
>>> id(a)
4396179528
>>> id(b)
4393788808
>>> a == b
True
>>> a is b
False
>>> b[0] = 5
>>> a
[1, 2, 3]
>>> b
[5, 2, 3]
```

2. 리스트 안에 리스트, mutable 객체 안의 mutable 객체의 경우 문제가 되는데, `id(a)`와 `id(b)`는 다르지만 내부 객체 `id(a[0])`와 `id(b[0])`는 같은 주소를 바라본다. 이 경우는 얕은 복사에 해당한다.
   그렇기 때문에 a, b를 재할당 하는 경우는 문제가 없지만(deep copy) 내부 값을 변경하면 a, b 상호간 영향을 미치게 된다(shallow copy).

```python
# assign value by slice method
>>> a = [[1,2], [3,4]]
>>> b = a[:]
>>> id(a)
4395624328
>>> id(b)
4396179592
>>> id(a[0])
4396116040
>>> id(b[0])
4396116040

# change a, b
>>> a[0] = [8,9]
>>> a
[[8, 9], [3, 4]]
>>> b
[[1, 2], [3, 4]]
>>> id(a[0])
4393788808
>>> id(b[0])
4396116040

# change element of a, b
>>> a[1].append(5)
>>> a
[[8, 9], [3, 4, 5]]
>>> b
[[1, 2], [3, 4, 5]]
>>> id(a[1])
4396389896
>>> id(b[1])
4396389896
```

3. 이를 해결하기 위해 copy 라이브러리의 `deepcopy()`를 사용하며 `copy()`의 경우는 얕은 복사에 해당한다.

```python
>>> import copy
# shallow copy
>>> a = [[1,2],[3,4]]
>>> b = copy.copy(a)
>>> a[1].append(5)
>>> a
[[1, 2], [3, 4, 5]]
>>> b
[[1, 2], [3, 4, 5]]

# deep copy
>>> a = [[1,2],[3,4]]
>>> b = copy.deepcopy(a)
>>> a[1].append(5)
>>> a
[[1, 2], [3, 4, 5]]
>>> b
[[1, 2], [3, 4]]
```



