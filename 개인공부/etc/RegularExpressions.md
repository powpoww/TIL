**참조 : https://wikidocs.net/1669**



## 1. 정규 표현식 살펴보기

- 정규 표현식(Regular Expression, 정규식)은 복잡한 문자열을 처리할 때 사용하는 기법



**정규식 사용 예시>**

```
주민등록번호를 포함하고 있는 텍스트가 있다. 이 텍스트에 포함된 모든 주민등록번호의 뒷자리를 * 문자로 변경해 보자.
```

우선 정규식을 전혀 모르면 다음과 같은 순서로 프로그램을 작성해야 할 것이다.

1. 전체 텍스트를 공백 문자로 나눈다(split).
2. 나뉜 단어가 주민등록번호 형식인지 조사한다.
3. 단어가 주민등록번호 형식이라면 뒷자리를 `*`로 변환한다.
4. 나뉜 단어를 다시 조립한다.

```python
data = """
park 800905-1049118
kim  700905-1059119
"""

result = []
for line in data.split("\n"):
    word_result = []
    for word in line.split(" "):
        if len(word) == 14 and word[:6].isdigit() and word[7:].isdigit():
            word = word[:6] + "-" + "*******"
        word_result.append(word)
    result.append(" ".join(word_result))
print("\n".join(result))
```

반면 정규식을 사용하면 간편하고 직관적으로 코드를 작성할 수 있다.

```python
import re 

data = """
park 800905-1049118
kim  700905-1059119
"""

pat = re.compile("(\d{6})[-]\d{7}")
print(pat.sub("\g<1>-*******", data))
```



## 2. 정규 표현식 시작



### 2.1 정규 표현식의 기초 메타 문자

- 메타 문자란 원래 그 문자가 가진 뜻이 아닌 특별한 용도로 사용하는 문자. : `. ^ $ * + ? { } [ ] \ | ( )`



#### 2.1.1 문자 클래스 [ ]

1. 문자 클래스를 만드는 메타 문자인 [ ] 사이에는 어떤 문자도 들어갈 수 있다. 즉 정규 표현식이 [abc]라면 이 표현식의 의미는 "a, b, c 중 한 개의 문자와 매치"를 뜻함.

   **예시>  "a", "before", "dude"가 정규식 [abc]와 어떻게 매치되는가?**

   - "a"는 정규식과 일치하는 문자인 "a"가 있으므로 매치
   - "before"는 정규식과 일치하는 문자인 "b"가 있으므로 매치
   - "dude"는 정규식과 일치하는 문자인 a, b, c 중 어느 하나도 포함하고 있지 않으므로 매치되지 않음
     

2.  [ ] 안의 두 문자 사이에 하이픈(-)을 사용하면 두 문자 사이의 범위(From - To)를 의미

   - [a-zA-Z] : 알파벳 모두
   - [0-9] : 숫자

3.  문자 클래스 안에 `^` 메타 문자를 사용할 경우에는 반대(not)라는 의미를 갖음.

   -  `[^0-9]`라는 정규 표현식은 숫자가 아닌 문자만 매치



**[자주 사용하는 문자 클래스]**

[0-9] 또는 [a-zA-Z] 등은 무척 자주 사용하는 정규 표현식이다. 이렇게 자주 사용하는 정규식은 별도의 표기법으로 표현할 수 있다. 다음을 기억해 두자.

- `\d` - 숫자와 매치, [0-9]와 동일한 표현식이다.
- `\D` - 숫자가 아닌 것과 매치, `[^0-9]`와 동일한 표현식이다.
- `\s` - whitespace 문자와 매치, `[ \t\n\r\f\v]`와 동일한 표현식이다. 맨 앞의 빈 칸은 공백문자(space)를 의미한다.
- `\S` - whitespace 문자가 아닌 것과 매치, `[^ \t\n\r\f\v]`와 동일한 표현식이다.
- `\w` - 문자+숫자(alphanumeric)와 매치, `[a-zA-Z0-9_]`와 동일한 표현식이다.
- `\W` - 문자+숫자(alphanumeric)가 아닌 문자와 매치, `[^a-zA-Z0-9_]`와 동일한 표현식이다.



#### 2.1.2 Dot(.)

- 줄바꿈 문자인 `\n`을 제외한 모든 문자와 매치됨을 의미. `a.b` 는 a와 b 사이 모든 문자를 포함해 매치한다는 뜻임.

  **예시>  "aab", "a0b", "abc"가 정규식 `a.b`와 어떻게 매치되는가?** 

  - "aab"는 가운데 문자 "a"가 모든 문자를 의미하는 `.`과 일치하므로 정규식과 매치된다.
  - "a0b"는 가운데 문자 "0"가 모든 문자를 의미하는 `.`과 일치하므로 정규식과 매치된다.
  - "abc"는 "a"문자와 "b"문자 사이에 어떤 문자라도 하나는있어야 하는 이 정규식과 일치하지 않으므로 매치되지 않는다.
    

#### 2.1.2 반복(*)

- `ca*t`는 `*` 바로 앞 문자인 a가 몇번이든 반복될 수 있다는 뜻임.

| 정규식 | 문자열 | Match 여부 | 설명                                    |
| :----- | :----- | :--------- | :-------------------------------------- |
| `ca*t` | ct     | Yes        | "a"가 0번 반복되어 매치                 |
| `ca*t` | cat    | Yes        | "a"가 0번 이상 반복되어 매치 (1번 반복) |
| `ca*t` | caaat  | Yes        | "a"가 0번 이상 반복되어 매치 (3번 반복) |



#### 2.1.2 반복(+)

- `ca+t`는 앞의 문자 a가 최소 1번 이상 반복될 때 사용 가능하다.

| 정규식 | 문자열 | Match 여부 | 설명                                    |
| :----- | :----- | :--------- | :-------------------------------------- |
| `ca+t` | ct     | No         | "a"가 0번 반복되어 매치되지 않음        |
| `ca+t` | cat    | Yes        | "a"가 1번 이상 반복되어 매치 (1번 반복) |
| `ca+t` | caaat  | Yes        | "a"가 1번 이상 반복되어 매치 (3번 반복) |



#### 2.1.2 반복({m,n}, ?)

- 반복 횟수를 m, n 사이의 수로 고정한다는 의미이다. `{1,}`은 `+`와 동일하고, `{0,}`은 `*`와 동일하다. 한 숫자만 입력되면 그 반복 회수로 정하는 것이다.

| 정규식     | 문자열  | Match 여부 | 설명                               |
| :--------- | :------ | :--------- | :--------------------------------- |
| `ca{2,5}t` | cat     | No         | "a"가 1번만 반복되어 매치되지 않음 |
| `ca{2,5}t` | caat    | Yes        | "a"가 2번 반복되어 매치            |
| `ca{2,5}t` | caaaaat | Yes        | "a"가 5번 반복되어 매치            |

- 반복은 아니지만 유사 개념으로 `?`이 있다. 뜻은 `{0,1}` 으로 있어도 되고 없어도 된다는 의미이다.

| 정규식 | 문자열 | Match 여부 | 설명                    |
| :----- | :----- | :--------- | :---------------------- |
| `ab?c` | abc    | Yes        | "b"가 1번 사용되어 매치 |
| `ab?c` | ac     | Yes        | "b"가 0번 사용되어 매치 |



### 2.2 Pyhton의 re 모듈



#### 2.2.1 re 모듈

| Method     | 목적                                                         |
| :--------- | :----------------------------------------------------------- |
| match()    | 문자열의 처음부터 정규식과 매치되는지 조사한다.              |
| search()   | 문자열 전체를 검색하여 정규식과 매치되는지 조사한다.         |
| findall()  | 정규식과 매치되는 모든 문자열(substring)을 리스트로 돌려준다. |
| finditer() | 정규식과 매치되는 모든 문자열(substring)을 반복 가능한 객체로 돌려준다. |



**예시>**

```python
>>> import re
>>> p = re.compile('[a-z]+')

# match
>>> m = p.match("python")
>>> print(m)
<re.Match object; span=(0, 6), match='python'>

>>> m = p.match("3 python")
>>> print(m)
None


# search
>>> m = p.search("python")
>>> print(m)
<re.Match object; span=(0, 6), match='python'>

>>> m = p.search("3 python")
>>> print(m)
<re.Match object; span=(2, 8), match='python'>


# findall
>>> result = p.findall("life is too short")
>>> print(result)
['life', 'is', 'too', 'short']


# finditer
>>> result = p.finditer("life is too short")
>>> print(result)
<callable_iterator object at 0x01F5E390>
>>> for r in result: print(r)
...
<re.Match object; span=(0, 4), match='life'>
<re.Match object; span=(5, 7), match='is'>
<re.Match object; span=(8, 11), match='too'>
<re.Match object; span=(12, 17), match='short'>
```



### 2.3 컴파일 옵션

1. DOTALL(S) : `.`이 줄바꿈 문자를 포함해 모든 문자와 매치될 수 있도록 함.
2. IGNORECASE(I) : 대소문자 관계없이 매치할 수 있도록 함.
3. MULTILINE(M) : 여러줄과 매치할 수 있도록 한다. (메타문자와 연계)
4. VERBOSE(X) : verbose모드를 사용할 수 있도록 함. 줄단위 구분 및 주석달기 가능.

```python
# DOTALL
>>> import re
>>> p = re.compile('a.b')
>>> m = p.match('a\nb')
>>> print(m)
None

>>> p = re.compile('a.b', re.DOTALL)
>>> m = p.match('a\nb')
>>> print(m)
<re.Match object; span=(0, 3), match='a\nb'>

# IGNORECASE
>>> p = re.compile('[a-z]+', re.I)
>>> p.match('python')
<re.Match object; span=(0, 6), match='python'>
>>> p.match('Python')
<re.Match object; span=(0, 6), match='Python'>
>>> p.match('PYTHON')
<re.Match object; span=(0, 6), match='PYTHON'>

# MULTILINE
>>> p = re.compile("^python\s\w+")
>>> p2 = re.compile("^python\s\w+", re.M)
>>> data = """python one
>>> life is too short
>>> python two
>>> you need python
>>> python three"""

>>> print(p.findall(data))
['python one']
>>> print(p2.findall(data))
['python one', 'python two', 'python three']

# VERBOSE
charref = re.compile(r"""
 &[#]                # Start of a numeric entity reference
 (
     0[0-7]+         # Octal form
   | [0-9]+          # Decimal form
   | x[0-9a-fA-F]+   # Hexadecimal form
 )
 ;                   # Trailing semicolon
""", re.VERBOSE)
```



### 2.4 백슬래시 문제

- `"\section"` 문자열을 찾기 위한 정규식을 만든다고 가정하면 `\\section`와 같이 입력을 해야함.  `"\\section"`을 위해서는 `\\\\section`을 입력해야하는 수고가 생김.
- 이를 위해 Raw String 규칙을 적용해 정규식이 Raw String임을 알려주는 파이썬 문법을 만들게 되었음.

```python
>>> p = re.compile(r'\\section')
```



# 3. 강력한 정규 표현식



### 3.1 메타문자

 `+`, `*`, `[]`, `{}` 등의 메타문자는 매치가 진행될 때 현재 매치되고 있는 문자열의 위치가 변경된다(보통 소비된다고 표현한다). 하지만 이와 달리 문자열을 소비시키지 않는 메타 문자도 있다(zerowidth assertions).

1. `|` 메타 문자는 or과 동일한 의미로 사용된다. `A|B`라는 정규식이 있다면 A 또는 B라는 의미가 된다.

   ```python
   >>> p = re.compile('Crow|Servo')
   >>> m = p.match('CrowHello')
   >>> print(m)
   <re.Match object; span=(0, 4), match='Crow'>
   ```

2. `^` 메타 문자는 문자열의 맨 처음과 일치함을 의미한다. 앞에서 살펴본 컴파일 옵션 `re.MULTILINE`을 사용할 경우에는 여러 줄의 문자열일 때 각 줄의 처음과 일치하게 된다.

   ```python
   >>> print(re.search('^Life', 'Life is too short'))
   <re.Match object; span=(0, 4), match='Life'>
   >>> print(re.search('^Life', 'My Life'))
   None
   ```

3. `$` 메타 문자는 `^` 메타 문자와 반대의 경우이다. 즉 `$`는 문자열의 끝과 매치함을 의미한다.

   ```python
   >>> print(re.search('short$', 'Life is too short'))
   <re.Match object; span=(12, 17), match='short'>
   >>> print(re.search('short$', 'Life is too short, you need python'))
   None
   ```

4. `\A`는 문자열의 처음과 매치됨을 의미한다. `^` 메타 문자와 동일한 의미이지만 `re.MULTILINE` 옵션을 사용할 경우에는 다르게 해석된다. `re.MULTILINE` 옵션을 사용할 경우 `^`은 각 줄의 문자열의 처음과 매치되지만 `\A`는 줄과 상관없이 전체 문자열의 처음하고만 매치된다.

5. `\Z`는 문자열의 끝과 매치됨을 의미한다. 이것 역시 `\A`와 동일하게 `re.MULTILINE` 옵션을 사용할 경우 `$` 메타 문자와는 달리 전체 문자열의 끝과 매치된다.

6. `\b`는 단어 구분자(Word boundary)이다. 보통 단어는 whitespace에 의해 구분된다.

   ```python
   >>> p = re.compile(r'\bclass\b')
   >>> print(p.search('no class at all'))  
   <re.Match object; span=(3, 8), match='class'>
   
   >>> print(p.search('the declassified algorithm'))
   None
   ```

7. `\B` 메타 문자는 `\b` 메타 문자와 반대의 경우이다. 즉 whitespace로 구분된 단어가 아닌 경우에만 매치된다.

   ```python
   >>> p = re.compile(r'\Bclass\B')
   >>> print(p.search('no class at all'))  
   None
   >>> print(p.search('the declassified algorithm'))
   <re.Match object; span=(6, 11), match='class'>
   >>> print(p.search('one subclass is'))
   None
   ```

   

### 3.2 그루핑

- 특정 문자가 계속해서 반복되는지 조사하기 위해서는 그루핑을 사용해야 한다. 그룹을 만들어주는 메타문자는 `( )`이다.

```python
>>> p = re.compile('(ABC)+')
>>> m = p.search('ABCABCABC OK?')
>>> print(m)
<re.Match object; span=(0, 9), match='ABCABCABC'>
>>> print(m.group())
ABCABCABC
```

- `\w+\s+\d+[-]\d+[-]\d+`은 `이름 + " " + 전화번호` 형태의 문자열을 찾는 정규식이다. 그런데 이렇게 매치된 문자열 중에서 이름만 뽑아내고 싶을 때는 그루핑을 사용한다.

| group(인덱스) | 설명                           |
| :------------ | :----------------------------- |
| group(0)      | 매치된 전체 문자열             |
| group(1)      | 첫 번째 그룹에 해당되는 문자열 |
| group(2)      | 두 번째 그룹에 해당되는 문자열 |
| group(n)      | n 번째 그룹에 해당되는 문자열  |


```python
>>> p = re.compile(r"\w+\s+\d+[-]\d+[-]\d+")
>>> m = p.search("park 010-1234-1234")

>>> p = re.compile(r"(\w+)\s+\d+[-]\d+[-]\d+")
>>> m = p.search("park 010-1234-1234")
>>> print(m.group(1))
park

# 중첩사용
>>> p = re.compile(r"(\w+)\s+((\d+)[-]\d+[-]\d+)")
>>> m = p.search("park 010-1234-1234")
>>> print(m.group(3))
010
```

- 그루핑 문자열에 이름 또한 할당할 수 있다.

```python
>>> p = re.compile(r"(?P<name>\w+)\s+((\d+)[-]\d+[-]\d+)")
>>> m = p.search("park 010-1234-1234")
>>> print(m.group("name"))
park
```



### 3.3 전방탐색

- 전방탐색에는 긍정(Positive)와 부정(Negative)의 두 종류가 있다.
  - 긍정형 전방 탐색(`(?=...)`) : `...` 에 해당되는 정규식과 매치되어야 하며 조건이 통과되어도 문자열이 소비되지 않는다.
  - 부정형 전방 탐색(`(?!...)`) : `...`에 해당되는 정규식과 매치되지 않아야 하며 조건이 통과되어도 문자열이 소비되지 않는다.



**예시> http:라는 검색 결과에서 :을 제외하고 출력하려면 어떻게 해야 할까?  **

```python
>>> p = re.compile(".+:")
>>> m = p.search("http://google.com")
>>> print(m.group())
http:
```

**긍정형 전방탐색**

- 기존 정규식과 검색에서는 동일한 효과를 발휘하지만 `:` 에 해당하는 문자열이 정규식 엔진에 의해 소비되지 않아(검색에는 포함되지만 검색 결과에는 제외됨) 검색 결과에서는 `:`이 제거된 후 돌려주는 효과가 있다.

```python
>>> p = re.compile(".+(?=:)")
>>> m = p.search("http://google.com")
>>> print(m.group())
http
```

**부정형 전방탐색**

- 확장자가 bat가 아닌 경우에만 통과된다는 의미이다. bat 문자열이 있는지 조사하는 과정에서 문자열이 소비되지 않으므로 bat가 아니라고 판단되면 그 이후 정규식 매치가 진행된다.

```python
>>> p = re.compile(".*[.](?!bat$).*$")
>>> m = p.search("autoexec.bat")
>>> print(m)
None

# 다중 입력
>>> p = re.compile(".*[.](?!bat$|exe$).*$")
```



### 3.4 문자열 바꾸기

- sub 메서드를 활용한 문자 바꾸기(replace). 횟수를 제어하려면 count 매개변수를 넣으면 된다.

```python
>>> p = re.compile('(blue|white|red)')
>>> p.sub('colour', 'blue socks and red shoes')
'colour socks and colour shoes'

>>> p.sub('colour', 'blue socks and red shoes', count=1)
'colour socks and red shoes'
```



### 3.5 Greedy vs Non-Greedy

- 그루핑을 통해 다음과 같이 모든 문자열을 소비할 수 있지만 non-greedy 문자인 `?`로 최소한의 반복을 수행하도록 한다. `?`는 `*?`, `+?`, `??`, `{m,n}?`와 같이 사용할 수 있다.

```python
>>> s = '<html><head><title>Title</title>'
>>> len(s)
32
>>> print(re.match('<.*>', s).span())
(0, 32)
>>> print(re.match('<.*>', s).group())
<html><head><title>Title</title>

>>> print(re.match('<.*?>', s).group())
<html>
```

