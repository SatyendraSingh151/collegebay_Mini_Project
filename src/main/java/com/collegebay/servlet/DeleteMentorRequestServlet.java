package com.collegebay.servlet;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/deleteMentorRequest")
public class DeleteMentorRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("user") : null;
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String reqIdParam = request.getParameter("requestId");
        if (reqIdParam == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        int requestId = Integer.parseInt(reqIdParam);

        try (Connection conn = DBConnection.getConnection()) {

            // ensure this user is the mentor for that request
            int currentUserId = -1;
            try (PreparedStatement psUser = conn.prepareStatement(
                    "SELECT id FROM users WHERE username = ?")) {
                psUser.setString(1, username);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        currentUserId = rs.getInt("id");
                    }
                }
            }

            if (currentUserId != -1) {
                try (PreparedStatement psDel = conn.prepareStatement(
                        "DELETE FROM mentorship_requests WHERE id = ? AND mentor_id = ?")) {
                    psDel.setInt(1, requestId);
                    psDel.setInt(2, currentUserId);
                    psDel.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("dashboard.jsp");
    }
}
