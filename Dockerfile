# ------------------------------------
# STAGE 1: BUILD THE WAR FILE (COMPILING JAVA AND PACKAGING)
# ------------------------------------
# Use a full JDK image to compile the Java code and run 'jar'.
FROM eclipse-temurin:17-jdk-alpine AS builder

# Set an argument for the MySQL Connector version
ARG MYSQL_CONNECTOR_VERSION=8.0.30

# Create the standard WAR directory structure in a temporary location /app
# /app will be the root of the WAR file.
RUN mkdir -p /app/WEB-INF/classes
RUN mkdir -p /app/WEB-INF/lib

# 1. Copy ALL files from the Git root into the builder's working directory /temp.
# We will sort them out from here.
WORKDIR /temp
COPY . .

# 2. Download the MySQL Connector/J JAR file directly into the /app/WEB-INF/lib directory. 
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar -O /app/WEB-INF/lib/mysql-connector.jar

# 3. Compile the Java Source files (.java) and put the output (.class) into WEB-INF/classes.
# This uses the flat list of *.java files in the /temp root.
RUN javac -cp /app/WEB-INF/lib/mysql-connector.jar -d /app/WEB-INF/classes *.java

# 4. Move all non-Java/non-config files to the WAR root (/app)
# This includes all your .jsp, .css, .sql, etc. files.
# We exclude the .java files and .git folder which are not needed in the WAR.
RUN find . -maxdepth 1 -type f \
    ! -name "*.java" \
    ! -name "*.git*" \
    -exec mv {} /app/ \;

# 5. Package the application into the WAR file
# Run the jar command from the WAR root folder /app
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
