# ------------------------------------
# STAGE 1: BUILD THE WAR FILE (COMPILING JAVA AND PACKAGING)
# ------------------------------------
FROM eclipse-temurin:17-jdk-alpine AS builder

ARG MYSQL_CONNECTOR_VERSION=8.0.30
# Define the Tomcat version for API download
ARG TOMCAT_VERSION=8.5.99 

# Create necessary directories
RUN mkdir -p /app/WEB-INF/classes
RUN mkdir -p /app/WEB-INF/lib
RUN mkdir -p /temp_lib 

# 1. Copy ALL files from the Git root into the builder's working directory /temp.
WORKDIR /temp
COPY . .

# 2. Download essential JARs needed for COMPILATION (Servlet & JSP APIs)
# We need these to compile any code that uses 'import javax.servlet.*'
# These files are placed in a temporary library folder for compilation only.
RUN wget -q https://repo1.maven.org/maven2/org/apache/tomcat/tomcat-servlet-api/${TOMCAT_VERSION}/tomcat-servlet-api-${TOMCAT_VERSION}.jar -O /temp_lib/servlet-api.jar
RUN wget -q https://repo1.maven.org/maven2/org/apache/tomcat/tomcat-jsp-api/${TOMCAT_VERSION}/tomcat-jsp-api-${TOMCAT_VERSION}.jar -O /temp_lib/jsp-api.jar

# 3. Download MySQL Connector/J JAR. This file MUST go into WEB-INF/lib for runtime.
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar -O /app/WEB-INF/lib/mysql-connector.jar

# 4. Define the Full CLASSPATH for compilation (JDBC + API JARs)
ENV CLASSPATH=/app/WEB-INF/lib/mysql-connector.jar:/temp_lib/servlet-api.jar:/temp_lib/jsp-api.jar

# 5. Compile the Java Source files (.java) and put the output (.class) into WEB-INF/classes.
# This compiles ALL *.java files found directly in the /temp root.
RUN javac -cp ${CLASSPATH} -d /app/WEB-INF/classes *.java

# 6. Move all content (JSP, HTML, CSS) into the final WAR root /app
# Move compiled classes and lib directory (the Java backend)
RUN mv WEB-INF /app/WEB-INF

# Move web content (JSP, HTML, CSS)
# This finds all files that are NOT Java source code or the Dockerfile and moves them.
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
FROM tomcat:8.5-jre17-temurin

WORKDIR /usr/local/tomcat/webapps
RUN rm -rf ROOT
COPY --from=builder /app/jobportal.war ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
