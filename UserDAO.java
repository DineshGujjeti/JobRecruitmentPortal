package com.portal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.portal.model.User;
import com.portal.util.DBConnection; // Import your connection class

public class UserDAO {

    /**
     * Registers a new user in the database.
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (first_name, last_name, email, password_hash, user_role) VALUES (?, ?, ?, ?, ?)";
        boolean rowInserted = false;

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPasswordHash()); // Storing plain text for now.
            ps.setString(5, user.getUserRole());

            rowInserted = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowInserted;
    }

    /**
     * Checks if a user exists with the given email and password.
     * Returns the user object if login is successful, otherwise returns null.
     */
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
        User user = null;

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setEmail(rs.getString("email"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setUserRole(rs.getString("user_role"));
                    // We don't load the password into the user object for security
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user; // Will be null if no user was found
    }
}