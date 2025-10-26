package com.portal.model;

public class User {
    
    // Fields to match your 'users' table
    private int userId;
    private String email;
    private String passwordHash; // We will just store the plain password for now
    private String firstName;
    private String lastName;
    private String userRole; // 'job_seeker' or 'recruiter'

    // Getters and Setters
    // These allow other classes to safely access and change the fields
    
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPasswordHash() {
        return passwordHash;
    }
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public String getUserRole() {
        return userRole;
    }
    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }
}