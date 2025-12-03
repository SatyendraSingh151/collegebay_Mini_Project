<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String searchQuery = (String) request.getAttribute("searchQuery");
    List<String> usernames = (List<String>) request.getAttribute("usernames");
    List<String> emails = (List<String>) request.getAttribute("emails");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Find Students - CollegeBay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f7fb; font-family: Arial, sans-serif; }
        .navbar-collegebay {
            background: linear-gradient(135deg, #0d6efd, #6610f2);
        }
        .navbar-collegebay .navbar-brand { font-weight: 700; letter-spacing: 1px; }
        .card-shadow { border-radius: 1rem; box-shadow: 0 10px 25px rgba(0,0,0,0.12); }
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

<div class="container my-4">
    <div class="card card-shadow">
        <div class="card-body">
            <h4 class="mb-3">Search Results for "<%= searchQuery %>"</h4>

            <%
                if (usernames != null && !usernames.isEmpty()) {
            %>
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-primary">
                        <tr>
                            <th>Student Name</th>
                            <th>Email</th>
                            <th>Connect</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (int i = 0; i < usernames.size(); i++) {
                    %>
                        <tr>
                            <td><%= usernames.get(i) %></td>
                            <td><%= emails.get(i) %></td>
                            <td>
                                <!-- Simple contact via email link for now -->
                                <a class="btn btn-sm btn-outline-primary"
                                   href="mailto:<%= emails.get(i) %>?subject=CollegeBay%20Connection">
                                   Email
                                </a>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <%
                } else {
            %>
                <p class="text-muted mb-0">No students found with that name.</p>
            <%
                }
            %>
        </div>
    </div>

    <div class="mt-3 d-flex justify-content-between">
        <a href="dashboard.jsp" class="btn btn-link p-0">← Back to Dashboard</a>
        <a href="logout" class="btn btn-link text-danger p-0">Logout</a>
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
