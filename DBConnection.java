package com.portal.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection createConnection() {
        Connection con = null;
        
        // Fetch connection details from Render Environment Variables
        // These variables MUST be set in your Render Web Service Dashboard
        String url = System.getenv("DB_URL");
        String username = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");

        try {
            // *** CHANGE 1: Use PostgreSQL Driver ***
            Class.forName("org.postgresql.Driver");
            
            // Check if environment variables were actually set
            if (url == null || username == null) {
                System.err.println("Database Environment Variables (DB_URL, DB_USER) are not set on Render!");
                return null;
            }
            
            // *** CHANGE 2: Use Environment Variables for connection ***
            con = DriverManager.getConnection(url, username, password);
            
            System.out.println("Database connection established!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL driver not found! Ensure the JAR is packaged correctly.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Connection to database failed! Check DB_URL, DB_USER, and DB_PASSWORD.");
            System.err.println("URL Used: " + url);
            e.printStackTrace();
        }
        
        return con;
    }

}
