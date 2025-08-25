# Dockerfile (multi-stage Maven build for a Spring Boot service)
# Stage 1: build
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src
COPY ../../pom.xml ./pom.xml
# copy only needed module; adjust path if module name differs
COPY . .
# Build with SpringCloud profile
RUN mvn -B -DskipTests clean package -Pdev,SpringCloud

# Stage 2: runtime
FROM eclipse-temurin:17-jre
ENV TZ=${TZ:-UTC}
WORKDIR /app
# find the fat jar (adjust artifact if your module names differ)
COPY --from=build /src/target/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
