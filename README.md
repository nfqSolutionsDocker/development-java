### development-java

This container has the following characteristics:
- Container nfqsolutions/centos:7.
- Install java jdk1.6.0_45
- Install java jdk1.7.0_80
- Install java jdk1.8.0_92 (default)
- Install maven 3.2.5
- Install maven 3.3.9 (default)
- Install tomcat 7.0.70 (default)
- Install eclipse NEON (default)
- The default java directory is /solutions/app/java.
- The default maven directory in /solutions/app/maven.
- The defautl tomcat directory is /solutions/app/tomcat.
- The default eclipse directory is /solutions/app/eclipse.
- The default workspace directory is /solutions/app/worspace.
- There is a Installations Script. This script copy directories to volumen. This script is executing in the next containers or in the docker compose.

For example, docker-compose.yml:
```
app:
 image: nfqsolutions/development-java:latest
 restart: always
 ports:
  - "<PORT_A>:8080"
  - "<PORT_B>:22"
 environment:
  - PACKAGES=
 volumes:
  - <mydirectory>:/solutions/app
```

For execute eclipse:
ssh -X root@<MACHINE_IP> -p<PORT_B> /solutions/app/eclipse/eclipse