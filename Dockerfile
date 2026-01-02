# ---------- Stage 1 : Build ----------
FROM maven:3.8.5-openjdk-8-slim AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src

# IMPORTANT: create executable Spring Boot JAR
RUN mvn clean package spring-boot:repackage -DskipTests


# ---------- Stage 2 : Runtime ----------
FROM eclipse-temurin:8-jdk-alpine

ENV PROJECT_HOME=/opt/app
WORKDIR $PROJECT_HOME

COPY --from=build /app/target/spring-boot-mongo-1.0.jar app.jar

EXPOSE 8080

# IMPORTANT: override default entrypoint
ENTRYPOINT ["java","-jar","/opt/app/app.jar"]
