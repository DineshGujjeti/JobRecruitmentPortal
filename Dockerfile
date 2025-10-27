# ------------------------------------
# STAGE 1: BUILD THE WAR FILE
# ------------------------------------
# We use a full JDK image to compile the Java code and run 'jar'.
FROM eclipse-temurin:17-jdk-alpine AS builder

# Set an argument for the MySQL Connector version (Tomcat 8.5/JRE 17 is compatible with 8.0.x)
ARG MYSQL_CONNECTOR_VERSION=8.0.30

# Create the standard WAR directory structure in a temporary location /app
RUN mkdir -p /app/WEB-INF/classes
RUN mkdir -p /app/WEB-INF/lib

# Download the MySQL Connector/J JAR file. 
# This is crucial for compilation and runtime database access.
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar -O /app/WEB-INF/lib/mysql-connector.jar

# 1. Copy the Java Source files (from the 'src/' folder)
# We copy these so they can be compiled.
COPY src/ /app/src/

# 2. Copy the Web Content (JSP, HTML, CSS) from the root to the WAR root /app
# This moves your JSP pages to the correct top-level location in the WAR.
COPY *.jsp *.html *.css /app/
# You may need to add more extensions here (e.g., *.js, *.png) if they are in the root.

# Define the CLASSPATH for compilation (must include the JDBC driver)
ENV CLASSPATH=/app/WEB-INF/lib/mysql-connector.jar

# Compile the Java source code
# The compiled .class files go into /app/WEB-INF/classes
RUN javac -cp ${CLASSPATH} -d /app/WEB-INF/classes /app/src/**/*.java

# Package the application into the WAR file
# The jar command runs from /app and packages everything inside it.
WORKDIR /app
RUN jar -cvf jobportal.war .


# ------------------------------------
# STAGE 2: DEPLOY THE APPLICATION
# ------------------------------------
# Use a lighter Tomcat 8.5 JRE-only image for the final deployment.
FROM tomcat:8.5-jre17-temurin

# Set the deploy directory as the working directory
WORKDIR /usr/local/tomcat/webapps

# Remove the default Tomcat application
RUN rm -rf ROOT

# Copy the built WAR file from the 'builder' stage into the Tomcat webapps directory.
COPY --from=builder /app/jobportal.war ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Command to start the Tomcat server
CMD ["catalina.sh", "run"]
