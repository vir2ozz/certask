FROM tomcat:9-jdk11-openjdk-slim

COPY hello-1.0.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
