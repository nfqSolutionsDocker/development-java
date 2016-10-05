#!/bin/bash

/solutions/install_packages.sh

echo Instalando java jdk1.8.0_92...
if [ ! -f /solutions/app/java/bin/java ]; then
	wget -P /solutions/app/ --no-cookies --no-check-certificate --header \
    	"Cookie: oraclelicense=accept-securebackup-cookie" \
    	"http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-b14/jdk-${JAVA_VERSION}-linux-x64.tar.gz"
	tar -xvzf /solutions/app/jdk-${JAVA_VERSION}-linux-x64.tar.gz -C /solutions/app/
	chmod -R 777 $(ls -d /solutions/app/jdk*/)
	mv $(ls -d /solutions/app/jdk*/) /solutions/app/java
fi

#echo Instalando java jdk1.6.0.45
#if [ ! -f /solutions/app/jdk1.6.0_45/bin/java ]; then
#	wget -P /solutions/app/ --no-cookies --no-check-certificate --header \
#        "Cookie: oraclelicense=accept-securebackup-cookie" \
#        "http://download.oracle.com/otn-pub/java/jdk/6u45-b15/jdk-6u45-linux-x64.tar.gz"
#        tar -xvzf /solutions/app/jdk-6u45-linux-x64.tar.gz -C /solutions/app/
#        chmod -R 777 $(ls -d /solutions/app/jdk1.6.0_45/)
#fi

echo Instalando java jdk1.7.0_80
if [ ! -f /solutions/app/jdk1.7.0_80/bin/java ]; then
	wget -P /solutions/app/ --no-cookies --no-check-certificate --header \
        "Cookie: oraclelicense=accept-securebackup-cookie" \
        "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz"
        tar -xvzf /solutions/app/jdk-7u80-linux-x64.tar.gz -C /solutions/app/
        chmod -R 777 $(ls -d /solutions/app/jdk1.7.0_80/)
fi

echo Instalando maven 3.3.9 ...
if [ ! -f /solutions/app/maven/bin/mvn ]; then
        wget -P /solutions/app/ "http://apache.rediris.es/maven/maven-3/${M2_VERSION}/binaries/apache-maven-${M2_VERSION}-bin.tar.gz"
        tar -xvzf /solutions/app/apache-maven-${M2_VERSION}-bin.tar.gz -C /solutions/app/
        chmod -R 777 $(ls -d /solutions/app/apache-maven*/)
        mv $(ls -d /solutions/app/apache-maven*/) /solutions/app/maven
fi

echo Instalando maven 3.2.5 ...
if [ ! -f /solutions/app/apache-maven-3.2.5/bin/mvn ]; then
	wget -P /solutions/app/ "http://apache.rediris.es/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz"
	tar -xvzf /solutions/app/apache-maven-3.2.5-bin.tar.gz -C /solutions/app/
	chmod -R 777 $(ls -d /solutions/app/apache-maven-3.2.5/)
fi

echo Instalando tomcat 7.0.70...
if [ ! -f /solutions/app/tomcat/bin/catalina.sh ]; then
	wget -P /solutions/app/ "http://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
	tar -xvzf /solutions/app/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /solutions/app/
	chmod -R 777 $(ls -d /solutions/app/apache-tomcat*/)
	mv $(ls -d /solutions/app/apache-tomcat*/) /solutions/app/tomcat
	chmod a+x /solutions/app/tomcat/bin/catalina.sh
	cp /solutions/index.html /solutions/app/tomcat/webapps/ROOT/
    	cp /solutions/solutions.png /solutions/app/tomcat/webapps/ROOT/
   	mv /solutions/app/tomcat/webapps/ROOT/index.jsp /solutions/app/tomcat/webapps/ROOT/index.jsp.bak
fi

echo Configurando tomcat ...
if [ ! -f /solutions/app/tomcat/bin/setenv.sh ]; then
	cp /solutions/setenv.sh /solutions/app/tomcat/bin/
	MEMORY=$(free -m | awk '/^Mem:/{print $2}')
	let MIN=${MEMORY}/64
	let MAX=${MEMORY}/4
	echo "export CATALINA_OPTS=\"\$CATALINA_OPTS -Xms${MIN}m -Xmx${MAX}m -XX:+AggressiveOpts -XX:-UseGCOverheadLimit -XX:MaxPermSize=512m\"" >> /solutions/app/tomcat/bin/setenv.sh
fi

echo Instalando eclipse Neon ...
if [ ! -f /solutions/app/eclipse/eclipse ]; then
	yum -y install hg
	wget -P /solutions/app/ "http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/neon/1/eclipse-jee-neon-1-linux-gtk-x86_64.tar.gz"
	tar -xvzf /solutions/app/eclipse-jee-neon-1-linux-gtk-x86_64.tar.gz -C /solutions/app/
	chmod -R 777 $(ls -d /solutions/app/eclipse/)
	mkdir /solutions/app/workspace
	sed -i "s/osgi.instance.area.default=@user.home\/workspace/osgi.instance.area.default=\/solutions\/app\/workspace/g" /solutions/app/eclipse/configuration/config.ini
fi

echo Instalando servidor ssh ...
if [ ! -f /usr/sbin/sshd ]; then
	yum -y update
	yum -y install openssh-server
	yum -y install xorg-x11-xauth
	yum -y install xorg-x11-utils
	yum -y install xorg-x11-fonts-*
	yum -y install xorg-x11-server-utils
	yum -y groups install "GNOME Desktop"
	yum clean all
	mkdir /var/run/sshd
	ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
	sed -i "s/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g" /etc/ssh/sshd_config
	sed -i "s/HostKey \/etc\/ssh\/ssh_host_ed25519_key/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/g" /etc/ssh/sshd_config
fi

echo Ejecutando sshd ...
/usr/sbin/sshd -D
