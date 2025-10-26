package com.portal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.portal.model.Applicant;
import com.portal.model.Job; // We need this for the 'getApplicationsBySeeker' method
import com.portal.util.DBConnection;

public class ApplicationDAO {

    /**
     * Creates a new entry in the 'applications' table, linking a seeker to a job.
     */
    public boolean applyForJob(int jobId, int jobSeekerId) {
        String sql = "INSERT INTO applications (job_id, job_seeker_id) VALUES (?, ?)";
        boolean rowInserted = false;

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, jobSeekerId);

            rowInserted = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            // e.printStackTrace(); 
            // We can ignore the error for now (e.g., if they apply twice)
            // A "UNIQUE" constraint in the DB will prevent duplicates
            System.err.println("Error applying for job: " + e.getMessage());
        }
        return rowInserted;
    }

    /**
     * Retrieves all JOBS that a specific seeker has applied for.
     * This will be used for the "myApplications.jsp" page.
     */
    public List<Job> getApplicationsBySeeker(int jobSeekerId) {
        List<Job> appliedJobs = new ArrayList<>();
        
        // SQL query to get job details by joining 'jobs' and 'applications'
        String sql = "SELECT j.* FROM jobs j " +
                     "JOIN applications a ON j.job_id = a.job_id " +
                     "WHERE a.job_seeker_id = ?";

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobSeekerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Job job = new Job();
                    job.setJobId(rs.getInt("job_id"));
                    job.setJobTitle(rs.getString("job_title"));
                    job.setLocation(rs.getString("location"));
                    job.setJobDescription(rs.getString("job_description"));
                    job.setPostedDate(rs.getTimestamp("posted_date"));
                    
                    appliedJobs.add(job);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appliedJobs;
    }
    // You will need to import the new Applicant model
    // Add this import at the top of your file:
    // import com.portal.model.Applicant;

    /**
     * Retrieves all applicants for a specific job.
     * This query joins applications, users, and profiles to get applicant details.
     */
    public List<Applicant> getApplicantsByJobId(int jobId) {
        List<Applicant> applicantList = new ArrayList<>();
        
        // This query joins 3 tables
        String sql = "SELECT u.user_id, u.first_name, u.last_name, u.email, " +
                     "p.headline, p.skills, p.resume_path " +
                     "FROM applications a " +
                     "JOIN users u ON a.job_seeker_id = u.user_id " +
                     "LEFT JOIN job_seeker_profiles p ON u.user_id = p.user_id " +
                     "WHERE a.job_id = ?";

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Applicant app = new Applicant();
                    app.setUserId(rs.getInt("user_id"));
                    app.setFirstName(rs.getString("first_name"));
                    app.setLastName(rs.getString("last_name"));
                    app.setEmail(rs.getString("email"));
                    app.setHeadline(rs.getString("headline"));
                    app.setSkills(rs.getString("skills"));
                    app.setResumePath(rs.getString("resume_path"));
                    
                    applicantList.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applicantList;
    }
}