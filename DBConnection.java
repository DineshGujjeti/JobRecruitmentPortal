package com.portal.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection createConnection() {
        Connection con = null;
        
        // XAMPP default settings:
        String url = "jdbc:mysql://localhost:3306/job_portal"; 
        String username = "root";    // XAMPP default username
        String password = "";       // XAMPP default password is blank

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, username, password);
            
            System.out.println("Database connection established!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Connection to database failed!");
            e.printStackTrace();
        }
        
        return con;
    }
}