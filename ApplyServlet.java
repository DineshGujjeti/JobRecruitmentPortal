package com.portal.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.portal.dao.ApplicationDAO;

@WebServlet("/apply")
public class ApplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ApplicationDAO applicationDAO;

    public void init() {
        applicationDAO = new ApplicationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // --- Security Check ---
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in AND is a "job_seeker"
        if (session == null || session.getAttribute("userId") == null || !"job_seeker".equals(session.getAttribute("userRole"))) {
            // If not, send them to the login page
            response.sendRedirect("login.jsp");
            return; // Stop executing
        }

        try {
            // 1. Get the 'jobId' from the URL parameter
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            
            // 2. Get the 'jobSeekerId' from the session
            int jobSeekerId = (int) session.getAttribute("userId");

            // 3. Call the DAO to apply for the job
            applicationDAO.applyForJob(jobId, jobSeekerId);

            // 4. Redirect the user to "My Applications" page
            // This gives them immediate feedback that the application was successful
            response.sendRedirect("myApplications.jsp");

        } catch (NumberFormatException e) {
            // This happens if the 'jobId' in the URL is not a valid number
            e.printStackTrace();
            response.sendRedirect("browseJobs.jsp"); // Send them back
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("browseJobs.jsp"); // Send them back
        }
    }
}