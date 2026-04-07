FROM eclipse-temurin:17-jdk
COPY target/devopsdemo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]