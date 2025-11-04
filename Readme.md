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

## Output:
* **Registration page:** 
<img width="564" height="318" alt="image" src="https://github.com/user-attachments/assets/747706e7-3e44-41f3-8ec1-2901d13ee207" />

* **Login page:** 
<img width="601" height="338" alt="image" src="https://github.com/user-attachments/assets/ab82d2d2-5683-43ab-8cf8-539c58b69048" />

* **Create an account:** 
<img width="601" height="338" alt="image" src="https://github.com/user-attachments/assets/96502dd0-f1b3-4fab-b392-0c60b5bb5a6f" />

* **Job Application:** 
<img width="577" height="324" alt="image" src="https://github.com/user-attachments/assets/6afafe61-2a0e-4d1e-a452-4c4534dc6ad6" />

* **Manage your profile :** 
<img width="577" height="324" alt="image" src="https://github.com/user-attachments/assets/84f8b8d7-7f04-468f-abc8-0506fa2944fc" />

* **Available Job opening:** 
<img width="585" height="329" alt="image" src="https://github.com/user-attachments/assets/f4f1c8f1-9a8d-41ab-80f9-e5ecee975761" />

* **Welcome page:** 
<img width="558" height="314" alt="image" src="https://github.com/user-attachments/assets/10f5d0c5-1ec9-4c98-b463-5527f2ea04f5" />

* **Posted job page:** 
<img width="541" height="304" alt="image" src="https://github.com/user-attachments/assets/ac11eb11-e445-4fd8-9ac5-a3a36e77498d" />

* **Job opening page:** 
<img width="535" height="301" alt="image" src="https://github.com/user-attachments/assets/e97412e0-6357-4970-996e-8d03b42f94f4" />

* **Posted job page:** 
<img width="576" height="324" alt="image" src="https://github.com/user-attachments/assets/96b1e5ae-b82d-48c1-a301-4961c8e8b732" />





