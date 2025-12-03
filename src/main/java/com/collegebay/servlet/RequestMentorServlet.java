// src/main/java/com/collegebay/servlet/RequestMentorServlet.java
package com.collegebay.servlet;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/requestMentor")
public class RequestMentorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String menteeUsername = (session != null) ? (String) session.getAttribute("user") : null;
        if (menteeUsername == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String mentorIdParam = request.getParameter("mentorId");
        String message = request.getParameter("message");

        if (mentorIdParam == null) {
            response.sendRedirect("students");
            return;
        }

        int mentorId = Integer.parseInt(mentorIdParam);

        try (Connection conn = DBConnection.getConnection()) {

            // find mentee id from username
            int menteeId = -1;
            try (PreparedStatement psUser = conn.prepareStatement(
                    "SELECT id FROM users WHERE username = ?")) {
                psUser.setString(1, menteeUsername);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        menteeId = rs.getInt("id");
                    }
                }
            }

            if (menteeId != -1) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO mentorship_requests (mentor_id, mentee_id, message) VALUES (?, ?, ?)")) {
                    ps.setInt(1, mentorId);
                    ps.setInt(2, menteeId);
                    ps.setString(3, message);
                    ps.executeUpdate();
                }
                request.setAttribute("requestStatus", "Mentorship request sent successfully.");
            } else {
                request.setAttribute("requestStatus", "Could not identify current user.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("requestStatus", "Failed to send mentorship request.");
        }

        // forward back to same profile page (userId still in query string)
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
