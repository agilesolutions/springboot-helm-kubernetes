FROM fabric8/java-alpine-openjdk8-jre
VOLUME /tmp
ARG version
ADD target/demo.jar myapp.jar
RUN sh -c 'touch /myapp.jar'
ENV JAVA_OPTS="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8787,suspend=n"
ENV SPRING_PROFILES_ACTIVE "docker"
EXPOSE 8080 8787
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -jar /myapp.jar" ]