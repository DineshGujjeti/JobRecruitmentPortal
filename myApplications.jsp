<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import the classes we need --%>
<%@ page import="com.portal.dao.ApplicationDAO" %>
<%@ page import="com.portal.model.Job" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%-- Security Check: Ensure user is a logged-in job_seeker --%>
<%
    // 1. Check if the user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Check for the correct role
    String userRole = (String) session.getAttribute("userRole");
    if (!"job_seeker".equals(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 3. Get Seeker Info
    int jobSeekerId = (int) session.getAttribute("userId");
    
    // 4. --- Fetch Data from Database ---
    // Create a new DAO instance
    ApplicationDAO appDAO = new ApplicationDAO();
    
    // Call the DAO method to get this seeker's applied jobs
    List<Job> appliedJobs = appDAO.getApplicationsBySeeker(jobSeekerId);
    
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Applications</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    nav { margin-bottom: 20px; }
    nav a { margin-right: 15px; text-decoration: none; }
    .job-listing { border: 1px solid #ccc; border-radius: 5px; padding: 15px; margin-bottom: 15px; }
    .job-listing h3 { margin-top: 0; }
    .job-listing .location { font-style: italic; color: #555; }
    .status { font-weight: bold; color: #28a745; }
</style>
</head>
<body>

    <nav>
        <a href="jobSeekerDashboard.jsp">Back to Dashboard</a>
        <a href="browseJobs.jsp">Browse More Jobs</a>
        <a href="profile.jsp">My Profile</a>
    </nav>

    <h2>My Job Applications</h2>

    <%-- 5. --- Loop through the appliedJobs list and display them --- --%>
    <%
        if (appliedJobs.isEmpty()) {
    %>
            <p>You have not applied for any jobs yet.</p>
    <%
        } else {
            for (Job job : appliedJobs) {
    %>
                <div class="job-listing">
                    <h3><%= job.getJobTitle() %></h3>
                    <div class="location">Location: <%= job.getLocation() %></div>
                    <p class="status">Status: Applied</p>
                    <%-- We could add more details from the 'applications' table here --%>
                </div>
    <%
            } // End of for-loop
        } // End of else
    %>

</body>
</html>