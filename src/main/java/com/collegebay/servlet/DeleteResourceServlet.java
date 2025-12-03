package com.collegebay.servlet;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/deleteResource")
public class DeleteResourceServlet extends HttpServlet {
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

        String resIdParam = request.getParameter("resourceId");
        if (resIdParam == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        int resourceId = Integer.parseInt(resIdParam);

        try (Connection conn = DBConnection.getConnection()) {

            // find current user id
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
                // delete only if this resource belongs to this user
                try (PreparedStatement psDel = conn.prepareStatement(
                        "DELETE FROM resources WHERE id = ? AND seller_id = ?")) {
                    psDel.setInt(1, resourceId);
                    psDel.setInt(2, userId);
                    psDel.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("dashboard.jsp");
    }
}
