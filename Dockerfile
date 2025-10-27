# ------------------------------------
# STAGE 1: BUILD THE WAR FILE (COMPILING JAVA AND PACKAGING)
# ------------------------------------
FROM eclipse-temurin:17-jdk-alpine AS builder

ARG MYSQL_CONNECTOR_VERSION=8.0.30
# Tomcat 8.5 implements Servlet 3.1. We need the actual API JARs for compilation.
ARG SERVLET_API_VERSION=3.1.0 

# Create necessary directories
RUN mkdir -p /app/WEB-INF/classes
RUN mkdir -p /app/WEB-INF/lib
RUN mkdir -p /temp_lib 

# 1. Copy ALL files from the Git root into the builder's working directory /temp.
WORKDIR /temp
COPY . .

# 2. Download essential API JARs needed for COMPILATION
# These files provide the 'javax.servlet.*' classes (Servlet, HttpServletRequest, etc.)
RUN wget -q https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/${SERVLET_API_VERSION}/javax.servlet-api-${SERVLET_API_VERSION}.jar -O /temp_lib/servlet-api.jar
RUN wget -q https://repo1.maven.org/maven2/javax/servlet/jsp/jsp-api/2.2/jsp-api-2.2.jar -O /temp_lib/jsp-api.jar

# 3. Download MySQL Connector/J JAR (for runtime and compilation)
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar -O /app/WEB-INF/lib/mysql-connector.jar

# 4. Define the Full CLASSPATH for compilation (JDBC + API JARs)
# We combine the necessary compilation APIs and the required database driver.
ENV CLASSPATH=/app/WEB-INF/lib/mysql-connector.jar:/temp_lib/servlet-api.jar:/temp_lib/jsp-api.jar

# 5. Compile the Java Source files (.java)
# This compiles all Java files in the root against the defined classpath.
RUN javac -cp ${CLASSPATH} -d /app/WEB-INF/classes *.java

# 6. Move all content (JSP, HTML, CSS) into the final WAR root /app
# Move compiled classes and lib directory (the Java backend)
RUN mv WEB-INF /app/WEB-INF

# Move web content (JSP, HTML, CSS)
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
