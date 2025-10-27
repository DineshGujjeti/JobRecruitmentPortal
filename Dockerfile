# Stage 1: Define the base image. 
# We use the official Apache Tomcat 8.5 with JRE 17 (a stable, modern Java version).
FROM tomcat:8.5-jre17-temurin

# Stage 2: Set the working directory to Tomcat's webapps folder.
WORKDIR /usr/local/tomcat/webapps

# Stage 3: (Optional but recommended) Remove the default application.
# This ensures your app is the main one accessible at the root URL.
RUN rm -rf ROOT

# Stage 4: Copy your WAR file into the webapps directory.
# Rename the WAR to 'ROOT.war'. Tomcat automatically deploys any WAR placed here,
# and naming it ROOT.war makes your application the main content for the domain (e.g., mysite.onrender.com/).
# IMPORTANT: Ensure the filename 'JobPortal.war' matches the file in your Git repo.
COPY JobPortal.war ROOT.war

# Stage 5: Expose the port. 
# Render needs to know which port to map to the internet. Tomcat's default is 8080.
EXPOSE 8080

# Stage 6: Command to start the server. 
# The base Tomcat image usually has a default entry point to start the server,
# but explicitly running 'catalina.sh run' ensures it stays running in the container.
CMD ["catalina.sh", "run"]
