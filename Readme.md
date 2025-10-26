# Java Job Recruitment Portal

This is a complete, full-stack job recruitment portal built using **Java Servlets, JSP (JavaServer Pages), and MySQL**. This project demonstrates the Model-View-Controller (MVC) architectural pattern in a traditional Java web environment.

## Features
* **User Roles:** Separate registration and dashboards for **Job Seekers** and **Recruiters**.
* **Job Posting:** Recruiters can post new job openings to the database.
* **Application System:** Job Seekers can browse all available jobs and apply for them.
* **Profile Management:** Job Seekers can update their skills, education, experience, and upload a **PDF resume** (using `multipart/form-data`).
* **Recruiter View:** Recruiters can view all applicants for a specific job, including their profile details.
* **Security:** All major pages are protected by session management to ensure role-based access.

## Tech Stack
* **Backend Logic:** Java Servlets
* **Frontend (View):** JSP (JavaServer Pages), HTML, CSS
* **Database:** MySQL
* **Server:** Apache Tomcat
* **Data Access:** JDBC (Java Database Connectivity)

## How to Set Up and Run Locally
1.  **Prerequisites:** Ensure you have the Java JDK, Apache Tomcat, and XAMPP installed.
2.  **Database Setup:**
    * Start **Apache** and **MySQL** in your XAMPP Control Panel.
    * Go to `http://localhost/phpmyadmin` and run the queries in the **`database_setup.sql`** file to create the `job_portal` database.
3.  **Project Configuration:**
    * In `com/portal/util/DBConnection.java`, verify the connection settings (`username="root"`, `password=""` for XAMPP).
    * In `com/portal/controller/UpdateProfileServlet.java`, update the `SAVE_DIR` path to a local folder (e.g., `C:\my_resumes`).
4.  **Deployment:** Deploy the **`src/main/webapp`** folder to your Tomcat server (as the context path `webapp`).
5.  **Access:** Open your browser and navigate to: `http://localhost:8080/webapp/register.jsp`