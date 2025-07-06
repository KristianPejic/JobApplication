FROM maven:3.9-openjdk-21 AS build

# Set working directory
WORKDIR /home/app

# Copy pom.xml first (for better caching)
COPY pom.xml .

# Download dependencies (this will be cached if pom.xml doesn't change)
RUN mvn dependency:resolve

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests -Dmaven.test.skip=true

# Runtime stage
FROM openjdk:21-jdk-slim

# Create app directory
WORKDIR /app

# Copy the built JAR file
COPY --from=build /home/app/target/spring-boot-rest-0.0.1-SNAPSHOT.jar /app/spring-boot-rest.jar

# Create uploads directory
RUN mkdir -p /app/uploads

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/spring-boot-rest.jar"]