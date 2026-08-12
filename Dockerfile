FROM tomcat:9-jre11-temurin

LABEL org.opencontainers.image.source="https://github.com/vir2ozz/certask" \
      org.opencontainers.image.description="Sample Java war deployed on Tomcat" \
      org.opencontainers.image.licenses="Apache-2.0"

# Ship the war as the root application so it answers on / rather than /hello-1.0
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY hello-1.0.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

HEALTHCHECK --interval=15s --timeout=3s --start-period=30s --retries=4 \
    CMD curl --fail --silent http://localhost:8080/ || exit 1

CMD ["catalina.sh", "run"]
