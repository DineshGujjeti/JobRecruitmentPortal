# ------------------------------------
# STAGE 1: BUILD THE WAR FILE (COMPILING JAVA AND PACKAGING)
# ------------------------------------
# Use a full JDK 17 Temurin image for compilation and the 'jar' utility.
FROM eclipse-temurin:17-jdk-alpine AS builder

# Set version arguments for dependencies
ARG MYSQL_CONNECTOR_VERSION=8.0.30
ARG SERVLET_API_VERSION=3.1.0 

# Create necessary directories for the final WAR structure
# /app will be the root directory when packaging the WAR.
RUN mkdir -p /app/WEB-INF/classes
RUN mkdir -p /app/WEB-INF/lib
RUN mkdir -p /temp_lib 

# 1. Copy ALL files from the Git root into the builder's working directory /temp.
# This makes all your .java, .jsp, and static files available for the build.
WORKDIR /temp
COPY . .

# 2. Download essential JARs needed for COMPILATION (Servlet API)
# The Servlet API is required to compile HttpServlet, HttpServletRequest, etc. (javax.servlet.*)
RUN wget -q https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/${SERVLET_API_VERSION}/javax.servlet-api-${SERVLET_API_VERSION}.jar -O /temp_lib/servlet-api.jar
RUN wget -q https://repo1.maven.org/maven2/javax/servlet/jsp/jsp-api/2.2/jsp-api-2.2.jar -O /temp_lib/jsp-api.jar

# 3. Download MySQL Connector/J JAR (for runtime database access)
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar -O /app/WEB-INF/lib/mysql-connector.jar

# 4. Define the Full CLASSPATH for compilation 
ENV CLASSPATH=/app/WEB-INF/lib/mysql-connector.jar:/temp_lib/servlet-api.jar:/temp_lib/jsp-api.jar

# 5. Compile the Java Source files (.java) 
# This compiles all Java files in the current directory against the full classpath.
RUN javac -cp ${CLASSPATH} -d /app/WEB-INF/classes *.java

# 6. ASSEMBLE the final WAR structure in /app:
# Move web content (JSP, HTML, CSS, etc.) from /temp to the WAR root /app.
# This excludes Java source files, Docker files, and Git files.
RUN find . -maxdepth 1 -type f \
    ! -name "*.java" \
    ! -name "Dockerfile" \
    ! -name "*.git*" \
    -exec mv {} /app/ \;

# 7. Package the application into the WAR file
WORKDIR /app
RUN jar -cvf jobportal.war .


# ------------------------------------
# STAGE 2: DEPLOY THE APPLICATION
# ------------------------------------
# Use the correct Tomcat 8.5 JRE-only image for deployment.
FROM tomcat:8.5-jre17-temurin

WORKDIR /usr/local/tomcat/webapps
# Remove the default Tomcat application
RUN rm -rf ROOT

# Copy the built WAR file from the 'builder' stage into the Tomcat webapps directory.
COPY --from=builder /app/jobportal.war ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Command to start the Tomcat server
CMD ["catalina.sh", "run"]
