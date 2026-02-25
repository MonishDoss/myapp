import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection
 * ------------
 * Centralises all JDBC connection details.
 * Change the four constants below to match your MySQL setup.
 */
public class DBConnection {

    // ── connection settings ────────────────────────────────────────────────
    private static final String HOST   = "localhost";
    private static final String PORT   = "3306";
    private static final String DB     = "studentdb";
    private static final String USER   = "root";
    private static final String PASS   = "your_password";   // <-- change this

    private static final String URL =
        "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB
        + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    // ── public factory method ──────────────────────────────────────────────
    public static Connection getConnection() throws SQLException {
        try {
            // Explicitly load the driver (required for older JVMs / Tomcat classloaders)
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found. "
                + "Copy mysql-connector-j-*.jar to $TOMCAT_HOME/lib/", e);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}