<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- We must import the classes we need to use in our Java code --%>
<%@ page import="com.portal.dao.JobDAO" %>
<%@ page import="com.portal.model.Job" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

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
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 3. Get Recruiter Info
    String firstName = (String) session.getAttribute("firstName");
    int recruiterId = (int) session.getAttribute("userId");
    
    // 4. --- Fetch Data from Database ---
    // Create a new DAO instance
    JobDAO jobDAO = new JobDAO();
    
    // Call the DAO method to get this recruiter's jobs
    List<Job> jobList = jobDAO.getJobsByRecruiter(recruiterId);
    
    // At this point, 'jobList' is a Java List containing all their Job objects
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Posted Jobs</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    nav { margin-bottom: 20px; }
    nav a { margin-right: 15px; text-decoration: none; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
    th { background-color: #f4f4f4; }
    tr:nth-child(even) { background-color: #f9f9f9; }
</style>
</head>
<body>

    <nav>
        <a href="recruiterDashboard.jsp">Back to Dashboard</a>
        <a href="postJob.jsp">Post Another Job</a>
    </nav>

    <h2>My Posted Jobs</h2>
    <p>Here are all the jobs you have posted, from newest to oldest.</p>

    <table>
        <thead>
            <tr>
                <th>Job Title</th>
                <th>Location</th>
                <th>Posted Date</th>
                <th>Description (Snippet)</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%-- 5. --- Loop through the jobList and display it --- --%>
            <%
                if (jobList.isEmpty()) {
            %>
                    <tr>
                        <td colspan="5">You have not posted any jobs yet.</td>
                    </tr>
            <%
                } else {
                    for (Job job : jobList) {
                        // Get a short snippet of the description
                        String snippet = job.getJobDescription();
                        if (snippet.length() > 100) {
                            snippet = snippet.substring(0, 100) + "...";
                        }
            %>
                        <tr>
                            <td><%= job.getJobTitle() %></td>
                            <td><%= job.getLocation() %></td>
                            <td><%= job.getPostedDate() %></td>
                            <td><%= snippet %></td>
                            <td><a href="viewApplications.jsp?jobId=<%= job.getJobId() %>">View Applicants</a></td>
                        </tr>
            <%
                    } // End of for-loop
                } // End of else
            %>
        </tbody>
    </table>

</body>
</html>