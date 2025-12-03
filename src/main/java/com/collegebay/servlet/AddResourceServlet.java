package com.collegebay.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/addResource")
public class AddResourceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("user") : null;
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));

        try (Connection conn = DBConnection.getConnection()) {
            // find user id
            int userId = -1;
            try (PreparedStatement psUser = conn.prepareStatement(
                    "SELECT id FROM users WHERE username = ?")) {
                psUser.setString(1, username);
                ResultSet rs = psUser.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("id");
                }
            }

            if (userId != -1) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO resources (title, description, price, seller_id) VALUES (?, ?, ?, ?)")) {
                    ps.setString(1, title);
                    ps.setString(2, description);
                    ps.setBigDecimal(3, price);
                    ps.setInt(4, userId);
                    ps.executeUpdate();
                }
            }

            response.sendRedirect("dashboard.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Failed to add resource");
            request.getRequestDispatcher("addResource.jsp").forward(request, response);
        }
    }
}
