<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Security Check: Ensure user is a logged-in recruiter --%>
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
    
    String firstName = (String) session.getAttribute("firstName");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Post a New Job</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    nav { margin-bottom: 20px; }
    nav a { margin-right: 15px; text-decoration: none; }
    div { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; font-weight: bold; }
    input[type="text"], textarea { width: 500px; padding: 8px; font-size: 1em; }
    textarea { height: 150px; }
    button { padding: 10px 15px; background-color: #28a745; color: white; border: none; cursor: pointer; }
</style>
</head>
<body>

    <nav>
        <a href="recruiterDashboard.jsp">Back to Dashboard</a>
        <a href="myJobs.jsp">View My Posted Jobs</a>
    </nav>

    <h2>Post a New Job Opening</h2>
    <p>Fill out the form below to post a new job.</p>

    <form action="postJob" method="post">
        <div>
            <label for="jobTitle">Job Title:</label>
            <input type="text" id="jobTitle" name="jobTitle" required>
        </div>
        <div>
            <label for="location">Location:</label>
            <input type="text" id="location" name="location" placeholder="e.g., Hyderabad, India or Remote">
        </div>
        <div>
            <label for="jobDescription">Job Description:</label>
            <textarea id="jobDescription" name="jobDescription" required></textarea>
        </div>
        <div>
            <button type="submit">Post Job</button>
        </div>
    </form>

</body>
</html>