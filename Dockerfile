FROM registry.access.redhat.com/rhel6:latest
#FROM centos:centos7

MAINTAINER Shah_Zobair
RUN yum clean all
#RUN yum-config-manager --disable \*-htb-* \*-rt-* \*-eus* \*-ha-* \*-tus-*
#RUN yum update -y && \ 
RUN yum --disablerepo='*' --disablerepo=rhel-7-server-tus-rpms --enablerepo=rhel-7-server-rpms update -y
#yum-config-manager --disable rhel-7-server-tus-rpms && \
#yum update -y && \
RUN yum repolist
RUN yum install wget tar -y
RUN yum clean all

# Prepare environment 
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts
# Install Oracle Java7
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://iaas-drive.vzwcorp.com/cswr/repo/artifacts/jdk/oracle/jdk1.7.0_72-linux.tar.gz && \
    tar -xvf jdk1.7.0_72-linux.tar.gz && \
    rm jdk*.tar.gz && \
    mv jdk* ${JAVA_HOME}
# Install Tomcat
RUN wget http://www.webhostingjams.com/mirror/apache/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz && \
    tar -xvf apache-tomcat-8.5.5.tar.gz && \
    rm apache-tomcat*.tar.gz && \
    mv apache-tomcat* ${CATALINA_HOME} 
RUN chmod +x ${CATALINA_HOME}/bin/*sh
# Create Tomcat admin user
ADD create_admin_user.sh $CATALINA_HOME/scripts/
ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
RUN chmod +x $CATALINA_HOME/scripts/*.sh

# Create tomcat user
RUN groupadd -r tomcat && \
	useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
	chown -R tomcat:tomcat ${CATALINA_HOME}

WORKDIR /opt/tomcat

EXPOSE 8080
EXPOSE 8009


USER tomcat
CMD ["tomcat.sh"]
