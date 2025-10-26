package com.portal.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.portal.dao.JobDAO;
import com.portal.model.Job;

@WebServlet("/postJob")
public class PostJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private JobDAO jobDAO;

    public void init() {
        jobDAO = new JobDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // --- Security Check ---
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a recruiter
        if (session == null || session.getAttribute("userId") == null || !"recruiter".equals(session.getAttribute("userRole"))) {
            // If not, send them to the login page
            response.sendRedirect("login.jsp");
            return; // Stop executing
        }

        try {
            // 1. Get all parameters from the form
            String jobTitle = request.getParameter("jobTitle");
            String location = request.getParameter("location");
            String jobDescription = request.getParameter("jobDescription");
            
            // 2. Get the recruiter's ID from the session
            int recruiterId = (int) session.getAttribute("userId");

            // 3. Create a Job object and set its properties
            Job newJob = new Job();
            newJob.setJobTitle(jobTitle);
            newJob.setLocation(location);
            newJob.setJobDescription(jobDescription);
            newJob.setRecruiterId(recruiterId); // Link the job to this recruiter

            // 4. Call the DAO to post the job
            boolean isPosted = jobDAO.postNewJob(newJob);

            if (isPosted) {
                // 5. If successful, redirect to the "My Jobs" page
                response.sendRedirect("myJobs.jsp");
            } else {
                // 6. If it fails, send back to the form
                // (We can add an error message later)
                response.sendRedirect("postJob.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("postJob.jsp");
        }
    }
}