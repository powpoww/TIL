# Linux_Hadup_Spark_MongoDB



**1. 가상환경 구성**

**2. 쥬피터 노트북 연결_GPU 연결**

**3. 리눅스 환경에서 깃허브 연결**

**4. 리눅스 명령어**



## 1. 가상환경 구성



### 1.1 가상환경 개념 정리

https://m.blog.naver.com/ilikebigmac/222009981745

개인 - ubuntu , 기업 -CentOS (hadup,spark와 연결)



### 1.2 가상환경 구축 및 리눅스 설치



#### 1.2.1 VirtualBox, CentOS 설치

- Virtual Box : https://www.virtualbox.org/wiki/Downloads
- CentOS : http://mirror.anigil.com/CentOS/7.9.2009/isos/x86_64/



#### 1.2.2 가상환경에 리눅스 설치하기

- 가상환경 생성 : virtual box실행 및 새로만들기
  - 이름 : linux 
  - 머신폴더 : default
  - 버전 : red hat(64bit)
  - 메모리 : 2048mb
  - 파일 크기 : 10GB / 30GB
  - 하드디스크 파일 종류 : VDI(디스크 이미지)
  - 물리적 하드 드라이브 지정 : 동적할당

- Linux 설치

  - 시동디스크 선택 후 CentOS 실행
  - install CentOS 선택 (enter키)
  - 설치요약 창
    - 파티션 설정 : 설치대상 > 자동파티션 클릭 > 완료
    - 소프트웨어 설정 : 소프트웨어 선택 > GNOME 데스크탑 옵션 선택 > 모든 옵션 선택 > 완료


  - 사용자 설정
    - Root 암호 : 1234
    - 사용자 생성 : id: ygw, pw: 1234
    - 완료 후 재부팅
  - Lisence 동의 > 네트워크 및 호스트 : 이더넷 on > 동의 > 설정완료

    - 네트워크 생략시 : 프로그램 > 보조프로그램 > 설정 > 네트워크에서 유선 on > 설정(톱니)에서 자동으로 연결 적용.

  - root 로그인 후, 장치 > 게스트 확장cd 삽입 > 바로 실행하겠습니까? > 실행 > 재부팅
  - 바탕화면에 생성된 vbox_GAs 실행 > 설치관련 팝업 실행해 설치 프로그램 실행 > 재부팅
 - 기타 팁
   - 화면크기조정 : 보기 > 가상화면1 > 크기조정
   - 마우스 통합 해제 : ctrl+alt+delete
   - copy / paste (ctrl+shift+c,v) : 장치 > 클립보드 공유 > 양방향



#### 1.2.2 원격 설정

- linux 연결 설정
  - linux 터미널 > ~/etc 폴더 내 hosts.allow 폴더 열기(vi hosts.allow)
  - sshd: 192. 168. 56. 1 입력 후 저장. (연결 ip 입력)
    - 호스트 IP : window > cmd > 프롬프트 창에 ipconfig 입력 > VirtualBox IPv4 확인 (Default : 192. 168. 56. 1)
  - ifconfig 에서 enp0s3의 inet 확인 (linux ip 확인)
  - Oracle VirtualBox > 가상환경(명명:linux)의 설정 > 네트워크 > 고급 > 포트포워딩 > 연결 ip와 linux ip, 포트 입력
- Putty 설정
  - https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html 에서 설치
  - IP address 입력
  - 글자크기, 윈도우 색상 설정 : Window > Apperance , Colors
  - UserID, PW 입력하고 접속.



