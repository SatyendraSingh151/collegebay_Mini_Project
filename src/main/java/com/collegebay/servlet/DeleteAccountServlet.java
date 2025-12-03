package com.collegebay.servlet;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/deleteAccount")
public class DeleteAccountServlet extends HttpServlet {
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

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // find user id
            int userId = -1;
            try (PreparedStatement psUser = conn.prepareStatement(
                    "SELECT id FROM users WHERE username = ?")) {
                psUser.setString(1, username);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("id");
                    }
                }
            }

            if (userId != -1) {
                // delete mentorship rows where user is mentor or mentee
                try (PreparedStatement ps1 = conn.prepareStatement(
                        "DELETE FROM mentorship_requests WHERE mentor_id = ? OR mentee_id = ?")) {
                    ps1.setInt(1, userId);
                    ps1.setInt(2, userId);
                    ps1.executeUpdate();
                }

                // delete resources owned by this user
                try (PreparedStatement ps2 = conn.prepareStatement(
                        "DELETE FROM resources WHERE seller_id = ?")) {
                    ps2.setInt(1, userId);
                    ps2.executeUpdate();
                }

                // delete user account
                try (PreparedStatement ps3 = conn.prepareStatement(
                        "DELETE FROM users WHERE id = ?")) {
                    ps3.setInt(1, userId);
                    ps3.executeUpdate();
                }
            }

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }

        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
    }
}
