package com.collegebay.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String currentUser = (session != null) ? (String) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userIdParam = request.getParameter("userId");
        if (userIdParam == null) {
            response.sendRedirect("students");
            return;
        }

        int userId = Integer.parseInt(userIdParam);

        String username = null;
        String email = null;

        List<String> titles = new ArrayList<>();
        List<String> descriptions = new ArrayList<>();
        List<String> prices = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // load user info
            try (PreparedStatement psUser = conn.prepareStatement(
                    "SELECT username, email FROM users WHERE id = ?")) {
                psUser.setInt(1, userId);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        username = rs.getString("username");
                        email = rs.getString("email");
                    }
                }
            }

            // load that user's resources
            try (PreparedStatement psRes = conn.prepareStatement(
                    "SELECT title, description, price FROM resources WHERE seller_id = ? ORDER BY created_at DESC")) {
                psRes.setInt(1, userId);
                try (ResultSet rs = psRes.executeQuery()) {
                    while (rs.next()) {
                        titles.add(rs.getString("title"));
                        descriptions.add(rs.getString("description"));
                        prices.add(rs.getBigDecimal("price").toString());
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading profile.");
        }

        request.setAttribute("profileUsername", username);
        request.setAttribute("profileEmail", email);
        request.setAttribute("titles", titles);
        request.setAttribute("descriptions", descriptions);
        request.setAttribute("prices", prices);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
