FROM tomcat:9.0-jdk8
COPY hello-1.0.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
