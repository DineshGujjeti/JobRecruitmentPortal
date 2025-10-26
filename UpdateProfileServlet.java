package com.portal.controller;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.portal.dao.ProfileDAO;
import com.portal.model.JobSeekerProfile;

@WebServlet("/updateProfile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProfileDAO profileDAO;

    // Define a path on your server to store resumes
    // !!! IMPORTANT: You MUST create this folder on your computer! (e.g., C:\job_portal\resumes)
    private static final String SAVE_DIR = "C:\\job_portal\\resumes";

    public void init() {
        profileDAO = new ProfileDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // --- Security Check ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"job_seeker".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. Get user ID from session
            int userId = (int) session.getAttribute("userId");

            // 2. Get all text fields from the form
            String headline = request.getParameter("headline");
            String skills = request.getParameter("skills");
            String education = request.getParameter("education");
            String experience = request.getParameter("experience");
            
            String newResumePath = null; // This will hold the path to the NEW uploaded file

            // 3. --- Handle the File Upload ---
            Part filePart = request.getPart("resume"); // "resume" is the 'name' from the <input>
            String originalFileName = filePart.getSubmittedFileName();

            // Check if a file was actually uploaded
            if (originalFileName != null && !originalFileName.isEmpty()) {
                // Create a unique filename to prevent overwrites (e.g., "12_JohnDoe_Resume.pdf")
                String uniqueFileName = userId + "_" + originalFileName;

                // Create the full path to save the file
                newResumePath = SAVE_DIR + File.separator + uniqueFileName;
                
                // Ensure the save directory exists
                File fileSaveDir = new File(SAVE_DIR);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs(); // Create the directory if it doesn't exist
                }

                // Write the file to the server's hard drive
                filePart.write(newResumePath);
            }

            // 4. Create Profile object and set properties
            JobSeekerProfile profile = new JobSeekerProfile();
            profile.setUserId(userId);
            profile.setHeadline(headline);
            profile.setSkills(skills);
            profile.setEducation(education);
            profile.setExperience(experience);
            
            // Only set the resume path if a new file was uploaded
            // If newResumePath is null, the DAO logic will keep the old path
            if (newResumePath != null) {
                profile.setResumePath(newResumePath);
            }

            // 5. Call DAO to save or update the profile
            profileDAO.saveOrUpdateProfile(profile);

            // 6. Redirect back to the profile page
            // (We'll add a success message later)
            response.sendRedirect("profile.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // Send back to profile page with an error
            response.sendRedirect("profile.jsp"); 
        }
    }
}