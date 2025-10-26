<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all the classes we need --%>
<%@ page import="com.portal.dao.ApplicationDAO" %>
<%@ page import="com.portal.model.Applicant" %>
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
    
    // 3. --- Get the Job ID from the URL ---
    int jobId = 0;
    try {
        jobId = Integer.parseInt(request.getParameter("jobId"));
    } catch (NumberFormatException e) {
        // If no valid jobId is provided, send back to their dashboard
        response.sendRedirect("recruiterDashboard.jsp");
        return;
    }
    
    // 4. --- Fetch Data from Database ---
    ApplicationDAO appDAO = new ApplicationDAO();
    List<Applicant> applicantList = appDAO.getApplicantsByJobId(jobId);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Applicants</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    nav { margin-bottom: 20px; }
    nav a { margin-right: 15px; text-decoration: none; }
    .applicant-card { border: 1px solid #ccc; border-radius: 5px; padding: 15px; margin-bottom: 15px; }
    .applicant-card h3 { margin-top: 0; }
    .applicant-card p { margin: 5px 0; }
    .applicant-card .skills { font-style: italic; color: #333; }
    .resume-info { font-weight: bold; color: #007bff; }
</style>
</head>
<body>

    <nav>
        <a href="recruiterDashboard.jsp">Dashboard</a>
        <a href="myJobs.jsp">Back to My Jobs</a>
    </nav>

    <h2>Applicants for Job #<%= jobId %></h2>

    <%-- 5. --- Loop through the applicantList and display them --- --%>
    <%
        if (applicantList.isEmpty()) {
    %>
            <p>There are no applicants for this job yet.</p>
    <%
        } else {
            for (Applicant app : applicantList) {
                // Get just the filename from the full resume path
                String resumeFileName = "No resume on file";
                if (app.getResumePath() != null && !app.getResumePath().isEmpty()) {
                    resumeFileName = app.getResumePath().substring(app.getResumePath().lastIndexOf(java.io.File.separator) + 1);
                }
    %>
                <div class="applicant-card">
                    <h3><%= app.getFirstName() %> <%= app.getLastName() %></h3>
                    <p><strong>Email:</strong> <%= app.getEmail() %></p>
                    <p><strong>Headline:</strong> <%= (app.getHeadline() != null) ? app.getHeadline() : "N/A" %></p>
                    <p class="skills">
                        <strong>Skills:</strong> <%= (app.getSkills() != null) ? app.getSkills() : "N/A" %>
                    </p>
                    <p class="resume-info">
                        <strong>Resume:</strong> <%= resumeFileName %>
                    </p>
                    <%-- In a future step, you could make the resume a download link --%>
                </div>
    <%
            } // End of for-loop
        } // End of else
    %>

</body>
</html>