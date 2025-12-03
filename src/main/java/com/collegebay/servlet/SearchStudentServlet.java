package com.collegebay.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/searchStudent")
public class SearchStudentServlet extends HttpServlet {
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

        String query = request.getParameter("query");
        if (query == null || query.isBlank()) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        List<String> usernames = new ArrayList<>();
        List<String> emails = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT username, email FROM users " +
                "WHERE username ILIKE ? AND username <> ? ORDER BY username")) {

            ps.setString(1, "%" + query + "%");   // case-insensitive contains search
            ps.setString(2, currentUser);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    usernames.add(rs.getString("username"));
                    emails.add(rs.getString("email"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error while searching students.");
        }

        request.setAttribute("searchQuery", query);
        request.setAttribute("usernames", usernames);
        request.setAttribute("emails", emails);
        request.getRequestDispatcher("searchStudent.jsp").forward(request, response);
    }
}
