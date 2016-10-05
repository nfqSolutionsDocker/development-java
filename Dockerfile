FROM nfqsolutions/centos:7

MAINTAINER solutions@nfq.com

# Instalacion previa
RUN sudo yum install -y wget

# Variables de entorno
ENV JAVA_HOME=/solutions/app/java \
	JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8 \
	CATALINA_HOME=/solutions/app/tomcat \
	JAVA_VERSION=8u92 \
	TOMCAT_VERSION=7.0.70 \
        M2_HOME=/solutions/app/maven \
        M2_VERSION=3.3.9 \
	ECLIPSE_HOME=/solutions/app/eclipse
ENV PATH=$PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$M2_HOME/bin:$ECLIPSE_HOME

# Modificacion para solutions
COPY index.html /solutions/
COPY solutions.png /solutions/
COPY setenv.sh /solutions/
RUN chmod 777 /solutions/setenv.sh && \
	chmod a+x /solutions/setenv.sh && \
	sed -i -e 's/\r$//' /solutions/setenv.sh

# Script de arranque
COPY development.sh /solutions/
RUN chmod 777 /solutions/development.sh && \
	chmod a+x /solutions/development.sh && \
	sed -i -e 's/\r$//' /solutions/development.sh

# Volumenes para el tomcat
VOLUME /solutions/app

# Puerto de salida del tomcat
EXPOSE 8080 22

# Configuracion supervisor
COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]
