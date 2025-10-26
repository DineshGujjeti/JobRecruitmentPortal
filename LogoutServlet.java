package com.portal.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the current session (if one exists)
        HttpSession session = request.getSession(false); // 'false' means don't create a new one

        if (session != null) {
            // 2. Invalidate the session (destroy it)
            session.invalidate();
        }

        // 3. Redirect the user back to the login page
        response.sendRedirect("login.jsp");
    }

    // Since a logout can be a simple link (GET request), we use doGet.
    // It's good practice to also add a doPost that just calls doGet.
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}