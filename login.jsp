<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - Job Portal</title>
<style>
    /* You can use the same styling as the register page */
    body { font-family: Arial, sans-serif; margin: 20px; }
    div { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; }
    input[type="email"], input[type="password"] { width: 300px; padding: 8px; }
    button { padding: 10px 15px; background-color: #007bff; color: white; border: none; cursor: pointer; }
</style>
</head>
<body>

    <h2>Login to Your Account</h2>

    <form action="login" method="post">
        <div>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div>
            <button type="submit">Login</button>
        </div>
    </form>
    
    <p>Don't have an account? <a href="register.jsp">Register here</a></p>

</body>
</html>