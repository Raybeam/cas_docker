FROM openjdk:8-jre-alpine as buildwar
MAINTAINER Chris Peck <crpeck@wm.edu>
RUN cd /tmp \
  && apk --no-cache add maven git \
  && git clone -b master --single-branch https://github.com/apereo/cas-overlay-template.git cas-overlay \
  && mkdir -p /tmp/cas-overlay/src/main/webapp
COPY src/main/webapp/ /tmp/cas-overlay/src/main/webapp/
COPY pom.xml /tmp/cas-overlay/
WORKDIR /tmp/cas-overlay
RUN  mvn clean package


FROM openjdk:8-jre-alpine
MAINTAINER Chris Peck <crpeck@wm.edu>
WORKDIR /root
COPY --from=buildwar /tmp/cas-overlay/target/cas.war .
COPY etc/cas /etc/cas
RUN keytool -noprompt -import -file /etc/cas/config/cas.crt -alias cas -storepass changeit -keystore $JAVA_HOME/lib/security/cacerts
EXPOSE 8443
CMD [ "/usr/bin/java", "-jar", "/root/cas.war" ]
