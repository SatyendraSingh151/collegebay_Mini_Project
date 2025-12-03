<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String currentUser = (String) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String profileUsername = (String) request.getAttribute("profileUsername");
    String profileEmail    = (String) request.getAttribute("profileEmail");
    List<String> titles        = (List<String>) request.getAttribute("titles");
    List<String> descriptions  = (List<String>) request.getAttribute("descriptions");
    List<String> prices        = (List<String>) request.getAttribute("prices");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Profile - <%= profileUsername %> | CollegeBay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f7fb; font-family: Arial, sans-serif; }
        .navbar-collegebay { background: linear-gradient(135deg, #0d6efd, #6610f2); }
        .navbar-collegebay .navbar-brand { font-weight: 700; letter-spacing: 1px; }
        .card-shadow { border-radius: 1rem; box-shadow: 0 10px 25px rgba(0,0,0,0.12); }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-collegebay mb-4">
  <div class="container">
    <a class="navbar-brand" href="dashboard.jsp">CollegeBay</a>
    <div class="d-flex text-white">
        Logged in as&nbsp;<strong><%= currentUser %></strong>
    </div>
  </div>
</nav>

<div class="container my-4">
    <div class="row g-4">
        <!-- Left: student info + mentorship form -->
        <div class="col-md-4">
            <div class="card card-shadow">
                <div class="card-body">
                    <h4 class="card-title mb-2"><%= profileUsername %></h4>
                    <p class="mb-1"><strong>Email:</strong> <%= profileEmail %></p>
                    <a class="btn btn-sm btn-outline-primary mt-2 mb-3"
                       href="mailto:<%= profileEmail %>?subject=CollegeBay%20Connection">
                       Connect via Email
                    </a>

                    <hr>

                    <h6 class="mb-2">Request Mentorship</h6>
                    <form method="post" action="requestMentor">
                        <!-- mentorId comes from the query string userId -->
                        <input type="hidden" name="mentorId" value="<%= request.getParameter("userId") %>">

                        <div class="mb-2">
                            <label class="form-label">Message (optional)</label>
                            <textarea name="message" class="form-control" rows="3"
                                      placeholder="Describe what kind of help you need"></textarea>
                        </div>

                        <button type="submit" class="btn btn-sm btn-success w-100">
                            Request Mentorship
                        </button>
                    </form>

                    <%
                        String reqMsg = (String) request.getAttribute("requestStatus");
                        if (reqMsg != null) {
                    %>
                    <p class="mt-2 text-success"><%= reqMsg %></p>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <!-- Right: resources list with Ask for Resource -->
        <div class="col-md-8">
            <div class="card card-shadow">
                <div class="card-body">
                    <h5 class="mb-3">Resources by <%= profileUsername %></h5>
                    <%
                        if (titles != null && !titles.isEmpty()) {
                    %>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover align-middle">
                            <thead class="table-primary">
                                <tr>
                                    <th>Title</th>
                                    <th>Description</th>
                                    <th style="width:120px;">Price</th>
                                    <th style="width:180px;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                for (int i = 0; i < titles.size(); i++) {
                                    String t  = titles.get(i);
                                    String d  = descriptions.get(i);
                                    String p  = prices.get(i);
                                    String sub = "CollegeBay%20Resource%20Request";
                                    String body = "Hi%20" + profileUsername +
                                                  ",%0D%0A%0D%0AI%20am%20interested%20in%20your%20resource:%20"
                                                  + t.replace(" ", "%20");
                            %>
                                <tr>
                                    <td><%= t %></td>
                                    <td><%= d %></td>
                                    <td>₹ <%= p %></td>
                                    <td>
                                        <a class="btn btn-sm btn-outline-success"
                                           href="mailto:<%= profileEmail %>?subject=<%= sub %>&body=<%= body %>">
                                           Ask for Resource
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
                        <p class="text-muted mb-0">This student has not posted any resources yet.</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-3 d-flex justify-content-between">
        <a href="students" class="btn btn-link p-0">← Back to Students</a>
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
