# Basic install of couchdb
#
# This will move the couchdb http server to port 8101 so adjust the port for your needs.
#
# Currently installs couchdb 1.3.1

FROM ubuntu
MAINTAINER Benny Thompson

RUN apt-get -y update
RUN apt-get install -y unzip mercurial maven2 ant curl

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get -y upgrade

# automatically accept oracle license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# and install java 7 oracle jdk
RUN apt-get -y install oracle-java7-installer && apt-get clean
RUN update-alternatives --display java
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

RUN cd /tmp/ && \
    curl -LO "http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip" -H 'Cookie: oraclelicense=accept-securebackup-cookie' && \
    unzip UnlimitedJCEPolicyJDK7.zip && \
    rm UnlimitedJCEPolicyJDK7.zip && \
    yes |cp -v /tmp/UnlimitedJCEPolicy/*.jar $JAVA_HOME/jre/lib/security/

RUN cd /opt && \
    wget http://repo2.maven.apache.org/maven2/org/nhind/direct-project-stock/4.0/direct-project-stock-4.0.tar.gz && \
    tar xvfz direct-project-stock-4.0.tar.gz

ENV DIRECT_HOME /opt/direct

EXPOSE 8081

CMD ["/opt/direct/apache-tomcat-7.0.59/bin/catalina.sh", "run"]
