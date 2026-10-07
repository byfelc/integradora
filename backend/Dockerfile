# Script de construcción de la imagen del backend.
# Etapa 1 compila con Maven; etapa 2 solo lleva el JAR y un JRE (imagen pequeña).
# En el pipeline la imagen se construye UNA vez por commit y se promueve
# (sha → staging → vX.Y.Z → producción) sin recompilar.

FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY config ./config
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q package -DskipTests -Dcheckstyle.skip

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN addgroup -S app && adduser -S app -G app
COPY --from=build /app/target/tdimp-backend.jar app.jar
USER app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75", "-jar", "app.jar"]
