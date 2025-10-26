<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register - Job Portal</title>
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    div { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; }
    input[type="text"], input[type="email"], input[type="password"] { width: 300px; padding: 8px; }
    select { padding: 8px; }
    button { padding: 10px 15px; background-color: #007bff; color: white; border: none; cursor: pointer; }
</style>
</head>
<body>

    <h2>Create an Account</h2>

    <form action="register" method="post">
        <div>
            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" required>
        </div>
        <div>
            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" required>
        </div>
        <div>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div>
            <label for="userRole">I am a:</label>
            <select id="userRole" name="userRole">
                <option value="job_seeker">Job Seeker</option>
                <option value="recruiter">Recruiter</option>
            </select>
        </div>
        <div>
            <button type="submit">Register</button>
        </div>
    </form>
    
    <p>Already have an account? <a href="login.jsp">Login here</a></p>

</body>
</html>