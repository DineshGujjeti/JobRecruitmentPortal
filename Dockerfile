# ----------------------------------------------------------------------
# Stage 1: Build & Compile the Java code (using a full JDK environment)
# ----------------------------------------------------------------------
# Use a standard Java 17 base image for compilation
FROM eclipse-temurin:17-jdk-alpine AS builder

# Set the working directory for all subsequent commands
WORKDIR /app

# Copy the entire source code into the container
COPY . /app

# IMPORTANT: Compile the Java source files
# This compiles all .java files into .class files, placing them in the correct directory for Tomcat.
RUN mkdir -p /app/src/main/webapp/WEB-INF/classes && \
    find src/main/java -name "*.java" > sources.txt && \
    javac -cp "src/main/webapp/WEB-INF/lib/*" -d src/main/webapp/WEB-INF/classes @sources.txt

# ----------------------------------------------------------------------
# Stage 2: Packaging (Creating the final WAR file and running it)
# ----------------------------------------------------------------------
# Use a lightweight JRE (Java Runtime Environment) image for the final, smaller container
FROM tomcat:9.0-jre17-temurin-alpine

# Set the working directory
WORKDIR /usr/local/tomcat

# Remove the default Tomcat webapps (including the examples)
RUN rm -rf webapps/ROOT webapps/docs webapps/examples webapps/host-manager webapps/manager

# Copy the webapp folder (which contains JSPs, WEB-INF, and compiled classes)
# We rename it to 'ROOT' so it runs at the base URL (e.g., yourdomain.com/register.jsp)
# If you deployed to /webapp before, you must update your links or rename this to webapps/webapp
COPY --from=builder /app/src/main/webapp webapps/ROOT

# Tomcat runs on port 8080 by default. Render will map this to port 80.
EXPOSE 8080

# Command to start Tomcat
CMD ["catalina.sh", "run"]