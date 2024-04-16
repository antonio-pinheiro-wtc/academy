FROM maven:3.9.6-amazoncorretto-17-debian-bookworm

WORKDIR /app

COPY pom.xml pom.xml

RUN mvn dependency:go-offline

COPY . .

RUN mvn clean package -Dquarkus.profile=docker -Dmaven.test.skip

#RUN mvn clean package -Dmaven.test.skip


FROM amazoncorretto:17.0.10

WORKDIR deployments

COPY --from=0 /app/target/quarkus-app/lib/ lib/
COPY --from=0 /app/target/quarkus-app/app/ app/
COPY --from=0 /app/target/quarkus-app/quarkus/ quarkus/
COPY --from=0 /app/target/quarkus-app/*.jar .

CMD java -jar /deployments/quarkus-run.jar