<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%! 
public static String sha256(String base) {
    try{
        java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(base.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();

        for (int i = 0; i < hash.length; i++) {
            String hex = Integer.toHexString(0xff & hash[i]);
            if(hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }

        return hexString.toString();
    } catch(Exception ex){
        throw new RuntimeException(ex);
    }
}
%>
<%
    request.setCharacterEncoding("UTF-8");

    String correo = request.getParameter("correo");
    String contrasena = request.getParameter("contrasena");
    String tipoUsuario = request.getParameter("tipoUsuario");

    String dbURL = "jdbc:mysql://localhost:3306/petify?useUnicode=true&characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPass = "n0m3l0";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String query = "";
    String redirectURL = "";
    boolean loginSuccess = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        if ("tutor".equals(tipoUsuario)) {
            query = "SELECT * FROM tutor WHERE correo = ? AND contraseña = ?";
            redirectURL = "menututor.jsp"; //menututor

        } else if ("veterinario".equals(tipoUsuario)) {
            query = "SELECT * FROM veterinario WHERE correo = ? AND contraseña = ?";
            redirectURL = "menuveterinario.jsp"; //menuveterinario

        } else {
            response.sendRedirect("iniciosesion.html?error=invalid_type");
            return;
        }
//verifica que si sea la cuenta
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, correo);
        pstmt.setString(2, sha256(contrasena));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            loginSuccess = true;
            session.setAttribute("user", correo);
            session.setAttribute("userType", tipoUsuario);

            if ("tutor".equals(tipoUsuario)) {
                session.setAttribute("userId", rs.getInt("id_tutor"));
                session.setAttribute("userName", rs.getString("nom_tutor"));
            } else {
                session.setAttribute("userId", rs.getInt("id_vete"));
                session.setAttribute("userName", rs.getString("nom_vete"));
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
//redirecciona respectivamente
    if (loginSuccess) {
        response.sendRedirect(redirectURL);
    } else {
        if ("tutor".equals(tipoUsuario)) {
            response.sendRedirect("iniciosesion.html?error=1");
        } else {
            response.sendRedirect("iniciosesionvete.html?error=1");
        }
    }
%>