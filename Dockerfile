# ------------------------------------
# STAGE 1: BUILD THE WAR FILE
# ------------------------------------
FROM eclipse-temurin:17-jdk-alpine AS builder

ARG MYSQL_CONNECTOR_VERSION=8.0.30
ARG SERVLET_API_VERSION=3.1.0 

# Create the final WAR assembly structure
RUN mkdir -p /app/WEB-INF/classes
RUN mkdir -p /app/WEB-INF/lib
RUN mkdir -p /temp_lib 

# 1. Copy ALL files from the Git root into the builder's working directory /temp.
WORKDIR /temp
COPY . .

# 2. Download essential API JARs and MySQL Connector
RUN wget -q https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/${SERVLET_API_VERSION}/javax.servlet-api-${SERVLET_API_VERSION}.jar -O /temp_lib/servlet-api.jar
RUN wget -q https://repo1.maven.org/maven2/javax/servlet/jsp/jsp-api/2.2/jsp-api-2.2.jar -O /temp_lib/jsp-api.jar
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar -O /app/WEB-INF/lib/mysql-connector.jar

# 3. Define the Full CLASSPATH for compilation 
ENV CLASSPATH=/app/WEB-INF/lib/mysql-connector.jar:/temp_lib/servlet-api.jar:/temp_lib/jsp-api.jar

# 4. Compile the Java Source files (.java) 
RUN javac -cp ${CLASSPATH} -d /app/WEB-INF/classes *.java

# 5. ASSEMBLE the final WAR structure in /app:
# --- NEW FIX: Move web.xml from the root (/temp) to the required WEB-INF folder in the WAR structure (/app)
RUN mv web.xml /app/WEB-INF/

# Move web content (JSP, HTML, CSS)
# Now, exclude web.xml from the general move since it's already moved.
RUN find . -maxdepth 1 -type f \
    ! -name "*.java" \
    ! -name "Dockerfile" \
    ! -name "*.git*" \
    ! -name "web.xml" \
    -exec mv {} /app/ \;

# 6. Package the application into the WAR file
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
