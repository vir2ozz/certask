# Использовать официальный образ Tomcat с поддержкой Java 11
FROM tomcat:9-jdk11

# Удалить стандартные приложения Tomcat, чтобы предотвратить их запуск
RUN rm -rf /usr/local/tomcat/webapps/*

# Копировать файл с приложением WAR в папку webapps Tomcat
COPY target/hello-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Открыть порт 8080 для прослушивания
EXPOSE 8080

# Запустить Tomcat
CMD ["catalina.sh", "run"]
