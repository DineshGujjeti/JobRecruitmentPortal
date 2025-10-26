<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import the classes we need --%>
<%@ page import="com.portal.dao.ProfileDAO" %>
<%@ page import="com.portal.model.JobSeekerProfile" %>

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
    
    // 3. --- Fetch Existing Profile Data ---
    int userId = (int) session.getAttribute("userId");
    ProfileDAO profileDAO = new ProfileDAO();
    
    // Try to get the user's profile
    JobSeekerProfile profile = profileDAO.getProfileByUserId(userId);
    
    // 4. Create placeholder variables
    // If a profile exists, 'profile' will not be null.
    // If it's a new user, 'profile' WILL be null.
    // We handle this to avoid errors on the page.
    String headline = "";
    String skills = "";
    String education = "";
    String experience = "";
    String resumePath = "";
    
    if (profile != null) {
        // If profile exists, fill our variables with its data
        headline = profile.getHeadline() != null ? profile.getHeadline() : "";
        skills = profile.getSkills() != null ? profile.getSkills() : "";
        education = profile.getEducation() != null ? profile.getEducation() : "";
        experience = profile.getExperience() != null ? profile.getExperience() : "";
        resumePath = profile.getResumePath() != null ? profile.getResumePath() : "";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    nav { margin-bottom: 20px; }
    nav a { margin-right: 15px; text-decoration: none; }
    div { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; font-weight: bold; }
    input[type="text"], textarea { width: 600px; padding: 8px; font-size: 1em; }
    textarea { height: 120px; }
    button { padding: 10px 15px; background-color: #007bff; color: white; border: none; cursor: pointer; }
    .resume-info { font-size: 0.9em; color: #333; }
</style>
</head>
<body>

    <nav>
        <a href="jobSeekerDashboard.jsp">Back to Dashboard</a>
        <a href="browseJobs.jsp">Browse Jobs</a>
    </nav>

    <h2>Manage Your Profile</h2>
    <p>Keep your profile up-to-date so recruiters can find you.</p>

    <%-- 
      This form is special.
      1. action="updateProfile" -> Points to our new servlet
      2. method="post" -> Required for file uploads
      3. enctype="multipart/form-data" -> ABSOLUTELY ESSENTIAL for file uploads
    --%>
    <form action="updateProfile" method="post" enctype="multipart/form-data">
    
        <div>
            <label for="headline">Headline:</label>
            <input type="text" id="headline" name="headline" value="<%= headline %>" placeholder="e.g., 3rd Year CSE Student">
        </div>
        
        <div>
            <label for="skills">Skills:</label>
            <textarea id="skills" name="skills" placeholder="e.g., Java, Python, SQL, Servlet/JSP, Git"><%= skills %></textarea>
        </div>
        
        <div>
            <label for="education">Education:</label>
            <textarea id="education" name="education" placeholder="e.g., Vardhaman College of Engineering - B.Tech CSE (Expected 2026)"><%= education %></textarea>
        </div>
        
        <div>
            <label for="experience">Experience:</label>
            <textarea id="experience" name="experience" placeholder="Describe any internships or projects"><%= experience %></textarea>
        </div>
        
        <div>
            <label for="resume">Upload Resume (PDF):</label>
            <input type="file" id="resume" name="resume" accept=".pdf">
            
            <%-- Show the user what resume they have on file --%>
            <% if (!resumePath.isEmpty()) { %>
                <p class="resume-info">Current resume on file: <%= resumePath.substring(resumePath.lastIndexOf("\\") + 1) %><br>
                (Uploading a new file will replace this one)</p>
            <% } %>
        </div>
        
        <div>
            <button type="submit">Save Profile</button>
        </div>
    </form>

</body>
</html>