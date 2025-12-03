// com.collegebay.util.DBConnection
package com.collegebay.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	
    private static final String URL  = "jdbc:postgresql://localhost:5432/collegebay";
    private static final String USER = "postgres";      // your DB user
    private static final String PASS = "tiger";         // your DB password

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
    	Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
