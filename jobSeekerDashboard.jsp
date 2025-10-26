<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- This is a JSP Scriptlet. It's Java code running inside the HTML. --%>
<%
    // 1. Check if the user is logged in
    // We check if the "userId" attribute exists in the session
    if (session.getAttribute("userId") == null) {
        // If it doesn't exist, redirect them to the login page
        response.sendRedirect("login.jsp");
        return; // Stop loading the rest of the page
    }

    // 2. Check if the user has the correct role
    String userRole = (String) session.getAttribute("userRole");
    if (!"job_seeker".equals(userRole)) {
        // If they are not a job_seeker, kick them to the login page
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 3. If they are logged in and have the right role, get their name
    String firstName = (String) session.getAttribute("firstName");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Job Seeker Dashboard</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    nav { margin-bottom: 20px; }
    nav a { margin-right: 15px; text-decoration: none; padding: 8px 12px; background-color: #f0f0f0; border-radius: 4px; }
    nav a.logout { background-color: #f44336; color: white; }
</style>
</head>
<body>

    <%-- 4. Display the personalized welcome message --%>
    <h2>Welcome, <%= firstName %>!</h2>
    <p>This is your job seeker dashboard. From here you can manage your profile and applications.</p>
    
    <nav>
        <a href="browseJobs.jsp">Browse Jobs</a>
        <a href="profile.jsp">My Profile</a>
        <a href="myApplications.jsp">My Applications</a>
        <a href="logout" class="logout">Logout</a> <%-- This will go to a LogoutServlet --%>
    </nav>

    <%-- We will add more content here later --%>

</body>
</html>