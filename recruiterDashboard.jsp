<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 1. Check if the user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Check for the correct role
    String userRole = (String) session.getAttribute("userRole");
    if (!"recruiter".equals(userRole)) {
        // If they are not a recruiter, kick them to the login page
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 3. Get their name
    String firstName = (String) session.getAttribute("firstName");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Recruiter Dashboard</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    nav { margin-bottom: 20px; }
    nav a { margin-right: 15px; text-decoration: none; padding: 8px 12px; background-color: #f0f0f0; border-radius: 4px; }
    nav a.logout { background-color: #f44336; color: white; }
</style>
</head>
<body>

    <h2>Welcome, Recruiter <%= firstName %>!</h2>
    <p>This is your recruiter dashboard. From here you can post jobs and manage applicants.</p>
    
    <nav>
        <a href="postJob.jsp">Post a New Job</a>
        <a href="myJobs.jsp">View My Posted Jobs</a>
        <a href="logout" class="logout">Logout</a>
    </nav>

    <%-- We will add more content here later --%>

</body>
</html>