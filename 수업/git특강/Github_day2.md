**유의사항** : Github내 Repository default branch에서 main -> master 로 변경하여 작업합니다.



### 1. 로컬 저장소(Local Repository)의 사용



![img](https://s3-ap-northeast-2.amazonaws.com/opentutorials-user-file/module/3963/10395.png)

- `Working Directory (= Working Tree)` : 사용자의 일반적인 작업이 일어나는 곳
- `Staging Area (= Index)` : 커밋을 위한 파일 및 폴더가 추가되는 곳
- `Repository` : staging area에 있던 파일 및 폴더의 변경사항(커밋)을 저장하는 곳
- Git은 **Working Directory → Staging Area → Repository** 의 과정으로 버전 관리를 수행합니다.



#### 1.0 Git 초기설정

- **최초 한 번만 설정합니다**. 매번 Git을 사용할 때마다 설정할 필요가 없습니다.

- 누가 커밋 기록을 남겼는지 확인할 수 있도록 이름과 이메일을 설정합니다.

  작성자를 수정하고 싶을 때에는 이름, 메일 주소만 다르게 하여 동일하게 입력합니다.

  ```bash
  $ git config --global user.name "이름"
  $ git config --global user.email "메일 주소"
  ```

- 작성자가 올바르게 설정되었는지 확인 가능합니다.

  ```bash
  $ git config --global -l
  
  또는
  
  $ git config --global --list
  ```



#### 1.1 git init

```bash
$ git init
Initialized empty Git repository in C:/Users/kyle/git-practice/.git/

kyle@KYLE MINGW64 ~/git-practice (master)
```

- 현재 작업 중인 디렉토리를 Git으로 관리한다는 명령어
- `.git` 이라는 숨김 폴더를 생성하고, 터미널에는 `(master)`라고 표기됩니다.
- Mac OS의 경우 `(master)`가 표기되지 않는데, Terminal 업그레이드를 통해 표기할 수 있습니다.



❗ **주의 사항**

1. 이미 Git 저장소인 폴더 내에 또 다른 Git 저장소를 만들지 않습니다. (중첩 금지) 즉, 터미널에 이미 (master)가 있다면, git init을 절대 입력하면 안됩니다.
2. 절대로 홈 디렉토리에서 git init을 하지 않습니다. 터미널의 경로가 `~` 인지 확인합니다.



#### 1.2 git status

```bash
$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

- Working Directory와 Staging Area에 있는 파일의 현재 상태를 알려주는 명령어. (WD-SA 관련은 적색, SA-CM 관련은 녹색으로 line이 표시된다.)

- 어떤 작업을 시행하기 전에 수시로 status를 확인하면 좋습니다.

- 상태

  1. `Untracked` : Git이 관리하지 않는 파일 (한번도 Staging Area에 올라간 적 없는 파일)

  2. `Tracked` : Git이 관리하는 파일
  
     -  `Unmodified` : 최신 상태
  
     -  `Modified` : 수정되었지만 아직 Staging Area에는 반영하지 않은 상태
  
     -  `Staged` : Staging Area에 올라간 상태
  



#### 1.3 git add

- Working Directory에 있는 파일을 Staging Area로 올리는 명령어
- Git이 해당 파일을 추적(관리)할 수 있도록 만듭니다.
- `Untracked, Modified → Staged` 로 상태를 변경합니다.



#### 1.4 git commit

- Staging Area에 올라온 파일의 변경 사항을 하나의 버전(커밋)으로 저장하는 명령어.
- `커밋 메세지`는 현재 변경 사항들을 잘 나타낼 수 있도록 `의미` 있게 작성하는 것을 권장합니다.
- 각각의 커밋은 `SHA-1` 알고리즘에 의해 반환 된 고유의 해시 값을 ID로 가집니다.
- `(root-commit)` 은 해당 커밋이 최초의 커밋 일 때만 표시됩니다. 이후 커밋부터는 사라집니다.



#### 1.5 git log

- 커밋의 내역(`ID, 작성자, 시간, 메세지 등`)을 조회할 수 있는 명령어
- 옵션
  - `--oneline` : 한 줄로 축약해서 보여줍니다.
  - `--graph` : 브랜치와 머지 내역을 그래프로 보여줍니다.
  - `--all` : 현재 브랜치를 포함한 모든 브랜치의 내역을 보여줍니다.
  - `--reverse` : 커밋 내역의 순서를 반대로 보여줍니다. (최신이 가장 아래)
  - `-p` : 파일의 변경 내용도 같이 보여줍니다.
  - `-2` : 원하는 갯수 만큼의 내역을 보여줍니다. (2 말고 임의의 숫자 사용 가능)





### 2. 원격 저장소(Remote Repository)의 사용

- Git의 주요 목적 중 하나인 협업을 위해 다른 로컬 저장소와 원격 저장소를 연동한다.
- Git init으로 git의 관리 하에 있는 폴더에서 수행한다.



#### 2.1 원격 저장소와 로컬 저장소의 연결 관리

- 로컬 저장소에 원격 저장소를 `등록, 조회, 삭제`할 수 있는 명령어

1. **원격 저장소 등록**

   `git remote add <이름> <주소>` 형식으로 작성합니다.

   ```bash
   $ git remote add origin <https://github.com/edukyle/TIL.git>
   
   [풀이]
   git 명령어를 작성할건데, remote(원격 저장소)에 add(추가) 한다.
   origin이라는 이름으로 <https://github.com/edukyle/TIL.git라는> 주소의 원격 저장소를
   ```

2. **원격 저장소 조회**

   `git remote -v` 로 작성합니다.

   ```bash
   $ git remote -v
   origin  <https://github.com/edukyle/TIL.git> (fetch)
   origin  <https://github.com/edukyle/TIL.git> (push)
   
   add를 이용해 추가했던 원격 저장소의 이름과 주소가 출력됩니다.
   ```

3. **원격 저장소 연결 삭제**

   `git remote rm <이름>` 혹은 `git remote remove <이름>` 으로 작성합니다.

   > 로컬과 원격 저장소의 연결을 끊는 것이지, 원격 저장소 자체를 삭제하는 게 아닙니다.

   ```bash
   $ git remote rm origin
   $ git remote remove origin
   
   [풀이]
   git 명령어를 작성할건데, remote(원격 저장소)와의 연결을 rm(remove, 삭제) 한다.
   그 원격 저장소의 이름은 origin이다.
   ```
   
4. **폴더 삭제**

​		`rm -rf [folder]` 를 입력하여 삭제.



#### 2.2 원격 저장소 다운로드 방법 (Clone & Pull)



##### 2.2.1 git clone

- 원격 저장소의 커밋 내역을 모두 가져와서, 로컬 저장소를 생성하는 명령어. (복제)

- clone은 `"복제"`라는 뜻으로, `git clone` 명령어를 사용하면 원격 저장소를 통째로 복제해서 내 컴퓨터에 옮길 수 있습니다.

- `git clone <원격 저장소 주소>`의 형태로 작성합니다.

  ```bash
  $ git clone <https://github.com/edukyle/TIL.git>
  Cloning into 'TIL'...
  remote: Enumerating objects: 3, done.
  remote: Counting objects: 100% (3/3), done.
  remote: Total 3 (delta 0), reused 3 (delta 0), pack-reused 0
  Receiving objects: 100% (3/3), done.
  ```

  위에 작성한 대로 실행하면, `Github의 edukyle이라는 계정의 TIL 원격 저장소를 복제`하여 내 컴퓨터에 TIL이라는 이름의 로컬 저장소를 생성하게 됩니다.

- git clone을 통해 생성된 로컬 저장소는 `git init`과 `git remote add`가 이미 수행되어 있습니다.



##### 2.2.2 git pull

- 원격 저장소의 변경 사항을 가져와서, 로컬 저장소를 업데이트하는 명령어

- 로컬 저장소와 원격 저장소의 내용이 완전 일치하면 git pull을 해도 변화가 일어나지 않습니다.

- `git pull <저장소 이름> <브랜치 이름>`의 형태로 작성합니다.

  ```bash
  $ git pull origin master
  From <https://github.com/edukyle/git-practice>
   * branch            master     -> FETCH_HEAD
  Updating 6570ecb..56809a9
  Fast-forward
   README.md | 1 +
   1 file changed, 1 insertion(+)
  
  [풀이]
  git 명령어를 사용할건데, origin이라는 원격 저장소의 master 브랜치의 내용을 가져온다(pull).
  ```

- 원격 저장소와 로컬 저장소의 commit이 다른 경우, 
  1. 내 컴퓨터와 강의장 컴퓨터에서 서로 다른 파일을 수정한 경우 → 정상적으로 git pull이 됩니다. 
  2. 내 컴퓨터와 강의장 컴퓨터에서 같은 파일을 수정했지만, 수정한 라인이 다른 경우 → 정상적으로 git pull이 됩니다. 
  3. 내 컴퓨터와 강의장 컴퓨터에서 같은 파일의 같은 라인을 수정한 경우 → 충돌(conflict)이 발생합니다. 어느 내용을 반영할지 직접 선택해야 합니다



#### 2.3 로컬 저장소 업로드 방법

- 실습 때 작성했던 TIL 파일을 Github 원격 저장소에 업로드 해보겠습니다.
- **정확히 말하면, 파일을 업로드하는 게 아니라 커밋을 업로드 하는 것입니다!**
- 따라서 먼저 로컬 저장소에서 커밋을 생성해야 원격 저장소에 업로드 할 수 있습니다.



1. **로컬 저장소에서 커밋 생성**

   ```bash
   # 현재 상태 확인
   
   $ git status
   On branch master
   
   No commits yet
   
   Untracked files:
     (use "git add <file>..." to include in what will be committed)
           day1.md
   
   nothing added to commit but untracked files present (use "git add" to track)
   ```

   ```bash
   $ git add day1.md
   ```

   ```bash
   $ git commit -m "Upload TIL Day1"
   [master (root-commit) f3d6d42] Upload TIL Day1
    1 file changed, 0 insertions(+), 0 deletions(-)
    create mode 100644 day1.md
   ```

   ```bash
   # 커밋 확인
   
   $ git log --oneline
   f3d6d42 (HEAD -> master) Upload TIL Day1
   ```



2. **git push**

   - 로컬 저장소의 커밋을 원격 저장소에 업로드하는 명령어
   - `git push <저장소 이름> <브랜치 이름>` 형식으로 작성합니다.
   - `-u` 옵션을 사용하면, 두 번째 커밋부터는 `저장소 이름, 브랜치 이름`을 생략 가능합니다.

   ```bash
   $ git push origin master
   
   [풀이]
   git 명령어를 사용할건데, origin이라는 이름의 원격 저장소의 master 브랜치에 push 한다.
   
   ------------------------------------------------
   
   $ git push -u origin master
   이후에는 $ git push 라고만 작성해도 push가 됩니다.
   
   $ git push -u origin master
   info: please complete authentication in your browser...
   Enumerating objects: 3, done.
   Counting objects: 100% (3/3), done.
   Writing objects: 100% (3/3), 218 bytes | 218.00 KiB/s, done.
   Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
   To https://github.com/edukyle/TIL.git
    * [new branch]      master -> master
   Branch 'master' set up to track remote branch 'master' from 'origin'.
   ```



### 3. .gitignore



#### 3.1 .gitignore에 작성하는 목록

- 민감한 개인 정보가 담긴 파일 (전화번호, 계좌번호, 각종 비밀번호, API KEY 등)
- OS(운영체제)에서 활용되는 파일
- IDE(통합 개발 환경 - pycharm) 혹은 Text editor(vscode) 등에서 활용되는 파일
  - 예) pycharm -> .idea/
- 개발 언어(python) 혹은 프레임워크(django)에서 사용되는 파일
  - 가상 환경 : `venv/`
  - `__pycache__/`



#### 3.2 .gitignore 작성 시 주의 사항

- 반드시 이름을 `.gitignore`로 작성합니다. 앞의 점(.)은 숨김 파일이라는 뜻입니다.

- `.gitignore` 파일은 `.git` 폴더와 동일한 위치에 생성합니다.

- **제외 하고 싶은 파일은 반드시 `git add` 전에 `.gitignore`에 작성합니다.**

   ❗ **왜 git add 전에 .gitignore에 작성해야 할까요?**

  `git add a.txt` 라고 작성하면, 이제 Git은 `a.txt`를 버전 관리의 대상으로 여깁니다. 한 번 버전 관리의 대상이 된 `a.txt`는 이후에 .gitignore에 작성하더라도 무시되지 않고 계속 버전 관리의 대상으로 인식됩니다.

  따라서 제외 하고 싶은 파일은 반드시 git add 전에 .gitignore에 작성해야 합니다!




#### 3.3 .gitignore 패턴 규칙

- 아무것도 없는 라인이나, `#`로 시작하는 라인은 무시합니다.
- `슬래시(/)`로 시작하면 하위 디렉터리에 재귀적으로 적용되지 않습니다.
- 디렉터리는 `슬래시(/)`를 끝에 사용하는 것으로 표현합니다.
- `느낌표(!)`로 시작하는 패턴의 파일은 ignore(무시)하지 않습니다.
- 표준 Glob 패턴을 사용합니다.
   - `*(asterisk, wildcard)`는 문자가 하나도 없거나 하나 이상을 의미합니다.
   - `[abc]`는 중괄호 안에 있는 문자 중 하나를 의미합니다.
   - `물음표(?)`는 문자 하나를 의미합니다.
   - `[0-9]`처럼 중괄호 안에 하이픈(-)이 있는 경우 0에서 9사이의 문자 중 하나를 의미합니다.
   - `**(2개의 asterisk)`는 디렉터리 내부의 디렉터리까지 지정할 수 있습니다. (`a/**/z`라고 작성하면 `a/z`, `a/b/z`, `a/b/c/z` 까지 모두 영향을 끼칩니다.)



##### <패턴 예시>

```bash
# .gitignore

# 확장자가 txt인 파일 무시
*.txt

# 현재 확장자가 txt인 파일이 무시되지만, 느낌표를 사용하여 test.txt는 무시하지 않음
!test.txt

# 현재 디렉터리에 있는 TODO 파일은 무시하고, folder/TODO 처럼 하위 디렉터리에 있는 파일은 무시하지 않음
/TODO

# build/ 디렉터리에 있는 모든 파일은 무시
build/

# folder/notes.txt 파일은 무시하고 folder/child/arch.txt 파일은 무시하지 않음
folder/*.txt

# folder 디렉터리 아래의 모든 .pdf 파일을 무시
folder/**/*.pdf
```
