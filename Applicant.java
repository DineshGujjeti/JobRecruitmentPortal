package com.portal.model;

// This is a "ViewModel" or "DTO" (Data Transfer Object).
// It's a custom class to hold data joined from multiple tables.
public class Applicant {

    // From the 'users' table
    private int userId;
    private String firstName;
    private String lastName;
    private String email;
    
    // From the 'job_seeker_profiles' table
    private String headline;
    private String skills;
    private String resumePath;
    
    // --- Getters and Setters ---

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
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
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getHeadline() {
        return headline;
    }
    public void setHeadline(String headline) {
        this.headline = headline;
    }
    public String getSkills() {
        return skills;
    }
    public void setSkills(String skills) {
        this.skills = skills;
    }
    public String getResumePath() {
        return resumePath;
    }
    public void setResumePath(String resumePath) {
        this.resumePath = resumePath;
    }
}