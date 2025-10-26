CREATE DATABASE job_portal;
USE job_portal;

-- Table for all users (both seekers and recruiters)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    user_role ENUM('job_seeker', 'recruiter') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for job seeker specific profile details
CREATE TABLE job_seeker_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    headline VARCHAR(255),
    skills TEXT,
    education TEXT,
    experience TEXT,
    resume_path VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table for jobs posted by recruiters
CREATE TABLE jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    recruiter_id INT NOT NULL,
    job_title VARCHAR(255) NOT NULL,
    job_description TEXT NOT NULL,
    location VARCHAR(150),
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recruiter_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table to link seekers and jobs they applied to
CREATE TABLE applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    job_seeker_id INT NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Applied', 'Viewed', 'Interviewing', 'Rejected', 'Hired') DEFAULT 'Applied',
    UNIQUE(job_id, job_seeker_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (job_seeker_id) REFERENCES users(user_id) ON DELETE CASCADE
);