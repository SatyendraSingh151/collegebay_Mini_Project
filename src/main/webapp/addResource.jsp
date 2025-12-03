<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Resource - CollegeBay</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f5f7fb;
            font-family: Arial, sans-serif;
        }
        .navbar-collegebay {
            background: linear-gradient(135deg, #0d6efd, #6610f2);
        }
        .navbar-collegebay .navbar-brand {
            font-weight: 700;
            letter-spacing: 1px;
        }
        .card-shadow {
            border-radius: 1rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-collegebay mb-4">
  <div class="container">
    <a class="navbar-brand" href="dashboard.jsp">CollegeBay</a>
    <div class="d-flex text-white">
        Logged in as&nbsp;<strong><%= user %></strong>
    </div>
  </div>
</nav>

<div class="container d-flex justify-content-center align-items-start" style="min-height: 70vh;">
    <div class="col-md-6">
        <div class="card card-shadow p-4">
            <h4 class="mb-3 text-center">Add New Resource</h4>
            <p class="text-muted text-center mb-4">
                Share your notes, books, or any useful study material with other students.
            </p>

            <form method="post" action="addResource">
                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control" placeholder="e.g. Java Notes - Unit 1 to 5" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="4"
                              placeholder="Briefly describe what this resource contains"></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Price (₹)</label>
                    <input type="number" step="0.01" min="0" name="price" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-2">Save Resource</button>
            </form>

            <div class="d-flex justify-content-between mt-2">
                <a href="dashboard.jsp" class="btn btn-link p-0">← Back to Dashboard</a>
                <a href="logout" class="btn btn-link text-danger p-0">Logout</a>
            </div>

            <div class="text-danger mt-2 text-center">
                ${error}
            </div>
        </div>
    </div>
</div>
<footer class="text-center mt-4 mb-3">
    <small>
        Project developed by <strong>Satyendra Singh</strong> ·
        Contact: <a href="mailto:151satyendrasingh@gmail.com">151satyendrasingh@gmail.com</a>
    </small>
</footer>

</body>
</html>
