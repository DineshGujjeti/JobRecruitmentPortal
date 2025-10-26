package com.portal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.portal.model.JobSeekerProfile;
import com.portal.util.DBConnection;

public class ProfileDAO {

    /**
     * Fetches a job seeker's profile using their user ID.
     * Returns a profile object if one exists, otherwise returns null.
     */
    public JobSeekerProfile getProfileByUserId(int userId) {
        JobSeekerProfile profile = null;
        String sql = "SELECT * FROM job_seeker_profiles WHERE user_id = ?";

        try (Connection con = DBConnection.createConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    profile = new JobSeekerProfile();
                    profile.setProfileId(rs.getInt("profile_id"));
                    profile.setUserId(rs.getInt("user_id"));
                    profile.setHeadline(rs.getString("headline"));
                    profile.setSkills(rs.getString("skills"));
                    profile.setEducation(rs.getString("education"));
                    profile.setExperience(rs.getString("experience"));
                    profile.setResumePath(rs.getString("resume_path"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profile; // Will be null if no profile was found
    }

    /**
     * Saves or updates a user's profile.
     * It first checks if a profile exists. If so, it UPDATES.
     * If not, it INSERTS a new one.
     */
    public boolean saveOrUpdateProfile(JobSeekerProfile profile) {
        // 1. Check if a profile already exists for this user
        JobSeekerProfile existingProfile = getProfileByUserId(profile.getUserId());
        boolean success = false;
        String sql;

        if (existingProfile != null) {
            // 2. If it exists, UPDATE it
            sql = "UPDATE job_seeker_profiles SET headline = ?, skills = ?, education = ?, experience = ?, resume_path = ? " +
                  "WHERE user_id = ?";
            
            try (Connection con = DBConnection.createConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                
                ps.setString(1, profile.getHeadline());
                ps.setString(2, profile.getSkills());
                ps.setString(3, profile.getEducation());
                ps.setString(4, profile.getExperience());
                // Only update resume path if a new one is provided.
                // If no new file is uploaded, we must keep the old path.
                String newPath = profile.getResumePath();
                if (newPath == null || newPath.isEmpty()) {
                    ps.setString(5, existingProfile.getResumePath()); // Keep old path
                } else {
                    ps.setString(5, newPath); // Set new path
                }
                ps.setInt(6, profile.getUserId());

                success = ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
        } else {
            // 3. If it doesn't exist, INSERT it
            sql = "INSERT INTO job_seeker_profiles (user_id, headline, skills, education, experience, resume_path) " +
                  "VALUES (?, ?, ?, ?, ?, ?)";
            
            try (Connection con = DBConnection.createConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                
                ps.setInt(1, profile.getUserId());
                ps.setString(2, profile.getHeadline());
                ps.setString(3, profile.getSkills());
                ps.setString(4, profile.getEducation());
                ps.setString(5, profile.getExperience());
                ps.setString(6, profile.getResumePath());

                success = ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return success;
    }
}