package com.portal.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // We need this for sessions

import com.portal.dao.UserDAO;
import com.portal.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get email and password from the login form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // 2. Call the DAO method to check the user
            User user = userDAO.loginUser(email, password);

            if (user != null) {
                // 3. LOGIN SUCCESSFUL: Create a session
                
                // Get the current session or create a new one
                HttpSession session = request.getSession(); 
                
                // Store user's information in the session
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userRole", user.getUserRole());
                session.setAttribute("firstName", user.getFirstName());
                
                // 4. Redirect based on user's role
                if ("recruiter".equals(user.getUserRole())) {
                    response.sendRedirect("recruiterDashboard.jsp");
                } else { // "job_seeker"
                    response.sendRedirect("jobSeekerDashboard.jsp");
                }
                
            } else {
                // 5. LOGIN FAILED: Redirect back to login page
                // We'll add an error message later
                response.sendRedirect("login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        }
    }
}