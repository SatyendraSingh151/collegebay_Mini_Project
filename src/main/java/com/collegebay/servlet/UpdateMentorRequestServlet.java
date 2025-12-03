package com.collegebay.servlet;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegebay.util.DBConnection;

@WebServlet("/updateMentorRequest")
public class UpdateMentorRequestServlet extends HttpServlet {
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
        String status = request.getParameter("status"); // yes, no, later

        if (reqIdParam == null || status == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        int requestId = Integer.parseInt(reqIdParam);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE mentorship_requests SET status = ? WHERE id = ?")) {
            ps.setString(1, status);
            ps.setInt(2, requestId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("dashboard.jsp");
    }
}
