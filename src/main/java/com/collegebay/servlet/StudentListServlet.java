package com.collegebay.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/students")
public class StudentListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String currentUser = (session != null) ? (String) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        int offset = (page - 1) * PAGE_SIZE;
        int totalCount = 0;

        List<Integer> ids = new ArrayList<>();
        List<String> usernames = new ArrayList<>();
        List<String> emails = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // total students count
            try (PreparedStatement psCount = conn.prepareStatement(
                    "SELECT COUNT(*) FROM users")) {
                try (ResultSet rs = psCount.executeQuery()) {
                    if (rs.next()) {
                        totalCount = rs.getInt(1);
                    }
                }
            }

            // current page data
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT id, username, email FROM users " +
                    "ORDER BY username LIMIT ? OFFSET ?")) {

                ps.setInt(1, PAGE_SIZE);
                ps.setInt(2, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        ids.add(rs.getInt("id"));
                        usernames.add(rs.getString("username"));
                        emails.add(rs.getString("email"));
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading students.");
        }

        int totalPages = (int) Math.ceil(totalCount / (double) PAGE_SIZE);

        request.setAttribute("ids", ids);
        request.setAttribute("usernames", usernames);
        request.setAttribute("emails", emails);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("students.jsp").forward(request, response);
    }
}
