#
# SonarScan build
#
FROM ubuntu:22.04
LABEL version="1.0.0"
LABEL description="LHUB DevOps SonarScan"
LABEL author_name="Fernando Karnagi"
LABEL author_email="fernando.karnagi@ncs.com.sg"

ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

ENV SONAR_VER=sonar-scanner-cli-4.7.0.2747-linux
ENV SONAR_HOME=/app/sonarcli
RUN apt-get update  
RUN apt -y install openjdk-17-jdk
RUN apt-get install -y wget; \
    apt-get install -y unzip; \
    apt-get install -y zip; \
    apt install curl -y; 
# install maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

 # Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

RUN mkdir -p /app/sonarcli
WORKDIR /app/sonarcli
# update
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_VER}.zip; \
    unzip ${SONAR_VER}.zip ; \
    mv sonar-scanner-*-linux $SONAR_HOME; \
    chmod -R 775 $SONAR_HOME; \
    echo Build started on `date`; \
    export PATH=${PATH}:${SONAR_HOME}/bin

# Install tzdata
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Singapore /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata


# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
RUN apt install locales -y
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8a
ENV TZ="Asia/Singapore"