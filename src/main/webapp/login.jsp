<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - CollegeBay</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        body {
            /* new gradient: teal to purple */
            background: linear-gradient(135deg, #11998e, #38ef7d, #7F00FF, #E100FF);
            background-size: 200% 200%;
            animation: gradientMove 12s ease infinite;
            min-height: 100vh;
            display: flex;
            flex-direction: column; /* footer at bottom */
            font-family: Arial, sans-serif;
        }
        @keyframes gradientMove {
            0%   { background-position: 0% 50%; }
            50%  { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .page-content {
            flex: 1; /* fill space above footer */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            border-radius: 1rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.25);
            backdrop-filter: blur(6px);
        }
        .brand-text {
            font-weight: 700;
            letter-spacing: 1px;
            color: #7F00FF;
        }
    </style>
</head>
<body>

<div class="page-content">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card p-4 bg-white bg-opacity-75">
                    <h3 class="text-center mb-3 brand-text">CollegeBay</h3>
                    <h5 class="text-center mb-4">Student Login</h5>

                    <form method="post" action="login">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 mb-2">Login</button>
                    </form>

                    <div class="text-center">
                        <small>New here?
                            <a href="register.jsp">Create an account</a>
                        </small>
                    </div>

                    <div class="text-danger mt-2 text-center">
                        ${error}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="text-center mt-3 mb-3 text-white">
    <small>
        Project developed by <strong>Satyendra Singh</strong> ·
        Contact:
        <a href="mailto:151satyendrasingh@gmail.com" class="text-white text-decoration-underline">
            151satyendrasingh@gmail.com
        </a>
    </small>
</footer>

</body>
</html>
