package com.portal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.portal.model.Job;
import com.portal.util.DBConnection;

public class JobDAO {

    /**
     * Saves a new job posting to the database.
     * Linked to a specific recruiter.
     */
    public boolean postNewJob(Job job) {
        String sql = "INSERT INTO jobs (recruiter_id, job_title, job_description, location) VALUES (?, ?, ?, ?)";
        boolean rowInserted = false;

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, job.getRecruiterId());
            ps.setString(2, job.getJobTitle());
            ps.setString(3, job.getJobDescription());
            ps.setString(4, job.getLocation());

            rowInserted = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowInserted;
    }

    /**
     * Retrieves all jobs posted by a specific recruiter.
     * This will be used for the "myJobs.jsp" page.
     */
    public List<Job> getJobsByRecruiter(int recruiterId) {
        List<Job> jobList = new ArrayList<>();
        String sql = "SELECT * FROM jobs WHERE recruiter_id = ? ORDER BY posted_date DESC";

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, recruiterId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Job job = new Job();
                    job.setJobId(rs.getInt("job_id"));
                    job.setRecruiterId(rs.getInt("recruiter_id"));
                    job.setJobTitle(rs.getString("job_title"));
                    job.setJobDescription(rs.getString("job_description"));
                    job.setLocation(rs.getString("location"));
                    job.setPostedDate(rs.getTimestamp("posted_date"));
                    
                    jobList.add(job);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobList;
    }
    
    // We will add more methods later, such as:
    // - getAllJobs() (for job seekers)
    // - getJobById(int jobId) (for viewing details)
    // - deleteJob(int jobId) (for recruiters)

    /**
     * Retrieves ALL jobs from the database for job seekers to browse.
     * Orders them by the newest first.
     */
    public List<Job> getAllJobs() {
        List<Job> jobList = new ArrayList<>();
        // Select all jobs, but also get the recruiter's name for display
        String sql = "SELECT j.*, u.first_name, u.last_name FROM jobs j " +
                     "JOIN users u ON j.recruiter_id = u.user_id " +
                     "ORDER BY j.posted_date DESC";

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Job job = new Job();
                job.setJobId(rs.getInt("job_id"));
                job.setRecruiterId(rs.getInt("recruiter_id"));
                job.setJobTitle(rs.getString("job_title"));
                job.setJobDescription(rs.getString("job_description"));
                job.setLocation(rs.getString("location"));
                job.setPostedDate(rs.getTimestamp("posted_date"));
                
                // Note: We are not storing the recruiter's name in the Job object
                // (We could add a field for it, but for now we'll just use it in the JSP)
                
                jobList.add(job);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobList;
    }
}