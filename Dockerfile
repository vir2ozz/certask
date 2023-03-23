FROM tomcat:9.0-jdk11

COPY hello-1.0.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
