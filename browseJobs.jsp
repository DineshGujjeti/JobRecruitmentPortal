<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import the classes we need --%>
<%@ page import="com.portal.dao.JobDAO" %>
<%@ page import="com.portal.model.Job" %>
<%@ page import="java.util.List" %>

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
        // If they are not a job seeker (e.g., a recruiter), kick them out
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 3. --- Fetch Data from Database ---
    JobDAO jobDAO = new JobDAO();
    
    // Call the NEW method to get ALL jobs
    List<Job> allJobs = jobDAO.getAllJobs();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Browse Jobs</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    nav { margin-bottom: 20px; }
    nav a { margin-right: 15px; text-decoration: none; }
    .job-listing { border: 1px solid #ccc; border-radius: 5px; padding: 15px; margin-bottom: 15px; }
    .job-listing h3 { margin-top: 0; }
    .job-listing .location { font-style: italic; color: #555; }
    .job-listing .apply-button { 
        display: inline-block;
        padding: 8px 12px;
        background-color: #007bff;
        color: white;
        text-decoration: none;
        border-radius: 4px;
        margin-top: 10px;
    }
</style>
</head>
<body>

    <nav>
        <a href="jobSeekerDashboard.jsp">Back to Dashboard</a>
        <a href="profile.jsp">My Profile</a>
    </nav>

    <h2>Available Job Openings</h2>

    <%-- 4. --- Loop through the allJobs list and display them --- --%>
    <%
        if (allJobs.isEmpty()) {
    %>
            <p>Sorry, there are no job openings at this time. Please check back later.</p>
    <%
        } else {
            for (Job job : allJobs) {
    %>
                <div class="job-listing">
                    <h3><%= job.getJobTitle() %></h3>
                    <div class="location">Location: <%= job.getLocation() %></div>
                    <p><%= job.getJobDescription() %></p>
                    
                    <%-- This link will go to an "ApplyServlet" --%>
                    <a href="apply?jobId=<%= job.getJobId() %>" class="apply-button">Apply Now</a>
                </div>
    <%
            } // End of for-loop
        } // End of else
    %>

</body>
</html>