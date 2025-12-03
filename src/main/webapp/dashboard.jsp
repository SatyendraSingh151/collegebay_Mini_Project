<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.collegebay.util.DBConnection" %>
<%@ page import="java.util.*" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int currentUserId = -1;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // mentorship data where current user is mentor
    List<Integer> requestIds = new ArrayList<>();
    List<String> menteeNames = new ArrayList<>();
    List<String> menteeEmails = new ArrayList<>();
    List<String> menteeMessages = new ArrayList<>();
    List<String> requestStatuses = new ArrayList<>();

    // mentorship data where current user is mentee (for viewing replies)
    List<String> mentorNames = new ArrayList<>();
    List<String> mentorEmails = new ArrayList<>();
    List<String> myMessages = new ArrayList<>();
    List<String> myStatuses = new ArrayList<>();

    // resources data (with ids and seller info)
    List<Integer> resIds = new ArrayList<>();
    List<String> resTitles = new ArrayList<>();
    List<String> resDescriptions = new ArrayList<>();
    List<String> resPrices = new ArrayList<>();
    List<String> resSellerEmails = new ArrayList<>();
    List<Integer> resSellerIds = new ArrayList<>();
    List<String> resSellerNames = new ArrayList<>();

    try {
        conn = DBConnection.getConnection();

        // get logged-in user's id
        ps = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
        ps.setString(1, user);
        rs = ps.executeQuery();
        if (rs.next()) {
            currentUserId = rs.getInt("id");
        }
        rs.close();
        ps.close();

        // 1) mentorship requests where this user is mentor
        if (currentUserId != -1) {
            ps = conn.prepareStatement(
                "SELECT mr.id, u.username AS mentee_name, u.email AS mentee_email, " +
                "       mr.message, mr.status " +
                "FROM mentorship_requests mr " +
                "JOIN users u ON mr.mentee_id = u.id " +
                "WHERE mr.mentor_id = ? " +
                "ORDER BY mr.created_at DESC"
            );
            ps.setInt(1, currentUserId);
            rs = ps.executeQuery();
            while (rs.next()) {
                requestIds.add(rs.getInt("id"));
                menteeNames.add(rs.getString("mentee_name"));
                menteeEmails.add(rs.getString("mentee_email"));
                menteeMessages.add(rs.getString("message"));
                requestStatuses.add(rs.getString("status"));
            }
            rs.close();
            ps.close();
        }

        // 2) mentorship rows where this user is mentee (to see mentor's reply)
        if (currentUserId != -1) {
            ps = conn.prepareStatement(
                "SELECT u.username AS mentor_name, u.email AS mentor_email, " +
                "       mr.message, mr.status " +
                "FROM mentorship_requests mr " +
                "JOIN users u ON mr.mentor_id = u.id " +
                "WHERE mr.mentee_id = ? " +
                "ORDER BY mr.created_at DESC"
            );
            ps.setInt(1, currentUserId);
            rs = ps.executeQuery();
            while (rs.next()) {
                mentorNames.add(rs.getString("mentor_name"));
                mentorEmails.add(rs.getString("mentor_email"));
                myMessages.add(rs.getString("message"));
                myStatuses.add(rs.getString("status"));
            }
            rs.close();
            ps.close();
        }

        // 3) load all resources with seller username + email
        ps = conn.prepareStatement(
            "SELECT r.id, r.title, r.description, r.price, r.seller_id, " +
            "       u.username AS seller_name, u.email AS seller_email " +
            "FROM resources r " +
            "JOIN users u ON r.seller_id = u.id " +
            "ORDER BY r.created_at DESC"
        );
        rs = ps.executeQuery();
        while (rs.next()) {
            resIds.add(rs.getInt("id"));
            resTitles.add(rs.getString("title"));
            resDescriptions.add(rs.getString("description"));
            resPrices.add(rs.getBigDecimal("price").toString());
            resSellerEmails.add(rs.getString("seller_email"));
            resSellerIds.add(rs.getInt("seller_id"));
            resSellerNames.add(rs.getString("seller_name"));
        }
        rs.close();
        ps.close();

%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - CollegeBay</title>
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
  <div class="container d-flex justify-content-between">
    <a class="navbar-brand" href="#">CollegeBay</a>
    <div class="d-flex align-items-center text-white">
        <span class="me-3">Logged in as&nbsp;<strong><%= user %></strong></span>
    </div>
  </div>
</nav>

<div class="container my-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Available Resources</h3>
        <div class="d-flex align-items-center">
            <form class="d-flex me-3" method="get" action="searchStudent">
                <input class="form-control form-control-sm me-2"
                       type="text" name="query"
                       placeholder="Search student by name" required>
                <button class="btn btn-sm btn-outline-secondary" type="submit">
                    Search
                </button>
            </form>
            <a href="students?page=1" class="btn btn-sm btn-outline-primary me-2">All Students</a>
            <a href="addResource.jsp" class="btn btn-sm btn-primary me-2">Add New Resource</a>
            <a href="logout" class="btn btn-sm btn-outline-secondary me-2">Logout</a>
            <form method="post" action="deleteAccount" class="d-inline"
                  onsubmit="return confirm('Delete your account and all your resources and mentorship data?');">
                <button type="submit" class="btn btn-sm btn-danger">
                    Delete My Account
                </button>
            </form>
        </div>
    </div>

    <!-- 1) Requests where you are the mentor (you can reply) -->
    <%
        if (!requestIds.isEmpty()) {
    %>
    <div class="card card-shadow mb-4">
        <div class="card-body">
            <h5 class="mb-3">Mentorship Requests (You as Mentor)</h5>
            <ul class="list-group">
                <%
                    for (int i = 0; i < requestIds.size(); i++) {
                        int reqId     = requestIds.get(i);
                        String mName  = menteeNames.get(i);
                        String mEmail = menteeEmails.get(i);
                        String mMsg   = menteeMessages.get(i);
                        String stat   = requestStatuses.get(i);
                        String mailSubject = "CollegeBay%20Mentorship%20Reply";
                        String mailBody = "Hi%20" + mName + ",%0D%0A%0D%0AI%20received%20your%20mentorship%20request.";
                %>
                <li class="list-group-item">
                    <strong><%= mName %></strong><br>
                    <small class="text-muted">Email:</small> <%= mEmail %><br>
                    <small class="text-muted">Message:</small>
                    <span><%= (mMsg != null && !mMsg.isBlank()) ? mMsg : "No message provided." %></span>

                    <div class="mt-2 d-flex flex-wrap gap-2">
                        <form method="post" action="updateMentorRequest" style="display:inline;">
                            <input type="hidden" name="requestId" value="<%= reqId %>">
                            <input type="hidden" name="status" value="yes">
                            <button type="submit" class="btn btn-sm btn-success">Yes</button>
                        </form>

                        <form method="post" action="updateMentorRequest" style="display:inline;">
                            <input type="hidden" name="requestId" value="<%= reqId %>">
                            <input type="hidden" name="status" value="no">
                            <button type="submit" class="btn btn-sm btn-danger">No</button>
                        </form>

                        <form method="post" action="updateMentorRequest" style="display:inline;">
                            <input type="hidden" name="requestId" value="<%= reqId %>">
                            <input type="hidden" name="status" value="later">
                            <button type="submit" class="btn btn-sm btn-warning">Later</button>
                        </form>

                        <a class="btn btn-sm btn-outline-primary"
                           href="mailto:<%= mEmail %>?subject=<%= mailSubject %>&body=<%= mailBody %>">
                           Reply via Email
                        </a>

                        <form method="post" action="deleteMentorRequest" style="display:inline;"
                              onsubmit="return confirm('Delete this mentorship request?');">
                            <input type="hidden" name="requestId" value="<%= reqId %>">
                            <button type="submit" class="btn btn-sm btn-outline-secondary">
                                Delete
                            </button>
                        </form>
                    </div>

                    <small class="text-muted">Current status:
                        <%= (stat != null) ? stat : "pending" %>
                    </small>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
    <%
        }
    %>

    <!-- 2) Requests you have sent (you are mentee, see mentor reply) -->
    <%
        if (!mentorNames.isEmpty()) {
    %>
    <div class="card card-shadow mb-4">
        <div class="card-body">
            <h5 class="mb-3">My Mentorship Requests (Replies from Mentors)</h5>
            <ul class="list-group">
                <%
                    for (int i = 0; i < mentorNames.size(); i++) {
                        String mentorName  = mentorNames.get(i);
                        String mentorEmail = mentorEmails.get(i);
                        String msg         = myMessages.get(i);
                        String st          = myStatuses.get(i);
                %>
                <li class="list-group-item">
                    <strong><%= mentorName %></strong><br>
                    <small class="text-muted">Email:</small> <%= mentorEmail %><br>
                    <small class="text-muted">Your message:</small>
                    <span><%= (msg != null && !msg.isBlank()) ? msg : "No message provided." %></span><br>
                    <small class="text-muted">Mentor reply status:</small>
                    <span class="badge bg-secondary text-uppercase"><%= (st != null) ? st : "pending" %></span>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
    <%
        }
    %>

    <!-- 3) Resources table -->
    <div class="card card-shadow">
        <div class="card-body">
            <%
                if (!resTitles.isEmpty()) {
            %>
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-primary">
                        <tr>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Posted By</th>
                            <th style="width:120px;">Price</th>
                            <th style="width:220px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (int i = 0; i < resTitles.size(); i++) {
                            int resId    = resIds.get(i);
                            String t     = resTitles.get(i);
                            String d     = resDescriptions.get(i);
                            String p     = resPrices.get(i);
                            String se    = resSellerEmails.get(i);
                            int sellerId = resSellerIds.get(i);
                            String sellerName = resSellerNames.get(i);

                            String sub = "CollegeBay%20Resource%20Request";
                            String body = "Hi%20" + sellerName +
                                          ",%0D%0A%0D%0AI%20am%20interested%20in%20your%20resource:%20"
                                          + t.replace(" ", "%20");
                    %>
                        <tr>
                            <td><%= t %></td>
                            <td><%= d %></td>
                            <td><%= sellerName %></td>
                            <td>₹ <%= p %></td>
                            <td>
                                <a class="btn btn-sm btn-outline-success mb-1"
                                   href="mailto:<%= se %>?subject=<%= sub %>&body=<%= body %>">
                                   Ask for Resource
                                </a>
                                <% if (sellerId == currentUserId) { %>
                                <form method="post" action="deleteResource" style="display:inline;"
                                      onsubmit="return confirm('Delete this resource?');">
                                    <input type="hidden" name="resourceId" value="<%= resId %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        Delete
                                    </button>
                                </form>
                                <% } %>
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
                <p class="text-muted mb-0">No resources yet. Be the first to add one!</p>
            <%
                }
            %>
        </div>
    </div>
</div>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("Error loading dashboard");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
