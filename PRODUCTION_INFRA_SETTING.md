# 운영장비 인프라 설치

2020.02.02 written by em180401


## 기본정보 

1. 설치 프로그램 목록 

| PROGRAM | port | 경로 및 계정 |
|-----|-----|-----|
| Tomcat 9.0.41 | 8080 | /TOMCAT/tomcat9  TOMCAT |
| apache 2.4.6 | 80, 443 | /etc/httpd/conf.d/* |
 


## 서버 설치

1. JAVA version 변경 (root 계정으로 진행)
```
1) 현재 java 버전 확인
[root@HKPHQPLMD1 ~]# java -version
openjdk version "1.8.0_131"
OpenJDK Runtime Environment (build 1.8.0_131-b12)
OpenJDK 64-Bit Server VM (build 25.131-b12, mixed mode)
[root@HKPHQPLMD1 ~]#

2) java 위치 확인
[root@HKPHQPLMD1 ~]# which java
/usr/bin/java

3) java link 경로 확인
[root@HKPHQPLMD1 ~]# ls -l /user/bin/java
ls: cannot access /user/bin/java: No such file or directory
[root@HKPHQPLMD1 ~]# ls -l /usr/bin/java
lrwxrwxrwx. 1 root root 22 Jul 16  2020 /usr/bin/java -> /etc/alternatives/java

4-1) yum install java-11-openjdk-devel.x86_64

4-2) 신규 버전 java download (yum 지원 안될경우)
[root@HKPHQPLMD1 ~]# wget 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz' -O ~/apps/OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz


5) 기존 링크 끊고, 해제 확인
[root@HKPHQPLMD1 bin]# unlink /usr/bin/java
which java
/usr/bin/which: no java in (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin)

6) 새로운 java로 재링크
[root@HKPHQPLMD1 bin]# ln -s /usr/openjdk11/bin/java /usr/bin/java
[root@HKPHQPLMD1 bin]# ln -s /usr/openjdk11/bin/javac /usr/bin/javac

7) 변경완료 확인
ls /usr/bin/java
lrwxrwxrwx  1 root root   23 Jan 22 15:00 java -> /usr/openjdk11/bin/java
```

2. TOMCAT 설치
```
1) 다운로드 
[root@HKPHQPLMD1 ~]# wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz

2) 압축해제
[root@HKPHQPLMD1 ~]# tar -zxvf apache-tomcat-9.0.41.tar.gz

3) 권한 변경 (root-> TOMCAT)
[root@HKPHQPLMD1 ~]# chown TOMCAT:wasgrp apache-tomcat-9.0.41

4) 폴더 이동
mv apache-tomcat-9.0.41 /TOMCAT/tomcat9
```

3. 환경변수 추가 
```
1) /etc/profile 편집
[root@HKPHQPLMD1 ~]# vi /etc/profile

export JAVA_HOME=/usr/openjdk11
export CATALINA_HOME=/TOMCAT/tomcat9
export PATH=$JAVA_HOME/bin:$CATALINA_HOME/bin:$PATH

2) 수정내용 적용
[root@HKPHQPLMD1 bin]# source /etc/profile

3) 결과 확인
[root@HKPHQPLMD1 bin]# echo $JAVA_HOME
/usr/openjdk11
```

4. JK Connector 설치하기
```
1) 다운로드 ( 사이트에서 버전 확인 후 최신 버전 설치)
[root@HKPHQPLMD1 ~]# curl -O http://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.48-src.tar.gz

2) 압축 해제
[root@HKPHQPLMD1 ~]# tar zxvf tomcat-connector*

3) 압축 해재 후 native 경로로 이동
cd tomcat-connectors-1.2.48-src/native

4) Makefile을 생성
./configure --with-apxs=/usr/bin/apxs
make
make install

5) mod_jk.so 생성 확인
ls /etc/httpd/modules/mod_jk.so
```

5. apache 설정
```
1) apache httpd 설정 
[root@HKPHQPLMD1 bin]# vi /etc/httpd/conf/httpd.conf
 # Dynamoc Shared Object (DSO)를 찾아 아래 한줄 추가후 저장
LoadModule jk_module modules/mod_jk.so

2) mod_jk.conf 설정
[root@HKPHQPLMD1 bin]# vi /etc/httpd/conf.modules.d/mod_jk.conf

# Load mod_jk module 
LoadModule jk_module modules/mod_jk.so        
# Where to find workers.properties 
JkWorkersFile conf/workers.properties 
# Where to put jk shared memory file 
JkShmFile run/mod_jk.shm 
# Where to put jk logs 
JkLogFile logs/mod_jk.log 
# Set the jk log level [debug/error/info] 
JkLogLevel info 
# Send all requests to worker named ajp13 
JkMount /* tomcat

3) worker 설정
[root@HKPHQPLMD1 bin]# vi /etc/httpd/conf/workers.properties
worker.list=tomcat 
worker.tomcat.port=8009
worker.tomcat.host=localhost
worker.tomcat.type=ajp13 
worker.tomcat.lbfactor=1
```

6. Tomcat 설정
```
1) /TOMCAT/tomcat9/server.xml 수정
   - 추가
    <Connector protocol="AJP/1.3"
               address="0.0.0.0"
               port="8009"
               redirectPort="8443"
               secretRequired="false"
               URIEncoding="UTF-8" /> 
```

 7. Apache 재시작.
```
1) 명령 실행
[root@HKPHQPLMD1 ~]#  systemctl restart httpd
[root@HKPHQPLMD1 ~]#  service httpd restart
[root@HKPHQPLMD1 ~]#  apachectl restart

2) 명령어 참고
  가.  Apache 버전 확인
  [root@HKPHQPLMD1 ~]# httpd -v

  나. Apache 상태 확인
  [root@HKPHQPLMD1 ~]# systemctl status httpd
  [root@HKPHQPLMD1 ~]# service httpd status

 다. Apache 시작
  [root@HKPHQPLMD1 ~]# systemctl start httpd
  [root@HKPHQPLMD1 ~]# service httpd start
  [root@HKPHQPLMD1 ~]# apachectl start

 라. Apache 중지
  [root@HKPHQPLMD1 ~]# systemctl stop httpd
  [root@HKPHQPLMD1 ~]# service httpd stop
  [root@HKPHQPLMD1 ~]# apachectl stop

 마. Apache 재시작
  [root@HKPHQPLMD1 ~]# systemctl restart httpd
  [root@HKPHQPLMD1 ~]# service httpd restart
  [root@HKPHQPLMD1 ~]# apachectl restart
```

8. Tomcat 설정 (org.apache.tomcat.maven build 사용 목적)
```
1) /TOMCAT/tomcat9/conf/tomcat-users.xml 수정
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <user username="admin" password="qwer1234" roles="manager-gui,manager-script"/>
</tomcat-users>

2) /TOMCAT/tomcat9/webapps/manager/META-INF/context.xml  수정 - Valve 주석 처리
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <!--Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" / -->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
```

8. eclipse maven build & deploy
 ```
1) Base directory
${project_loc:ddd}

2) Goals
clean package tomcat7:undeploy tomcat7:deploy-only

3) Profiles
prod
```
