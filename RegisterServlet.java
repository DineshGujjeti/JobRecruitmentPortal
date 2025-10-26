package com.portal.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.portal.dao.UserDAO; // Import your DAO
import com.portal.model.User;  // Import your Model

// This annotation maps this Servlet to the URL path "/register"
// This MUST match the 'action' attribute in your register.jsp form
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;

    public void init() {
        // Initialize the DAO once when the servlet is created
        userDAO = new UserDAO(); 
    }

    /**
     * This method handles the POST request from the form
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get all parameters from the form
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userRole = request.getParameter("userRole");

        // 2. Create a User object and set its properties
        User newUser = new User();
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setEmail(email);
        newUser.setPasswordHash(password); // Using plain text for now
        newUser.setUserRole(userRole);

        try {
            // 3. Call the DAO method to register the user
            boolean isRegistered = userDAO.registerUser(newUser);

            if (isRegistered) {
                // 4. If registration is successful, redirect to the login page
                // We'll add a success message later
                response.sendRedirect("login.jsp");
            } else {
                // 5. If it fails (e.g., duplicate email), redirect back to register
                // We'll add an error message later
                response.sendRedirect("register.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Handle potential database errors
            response.sendRedirect("register.jsp");
        }
    }
}