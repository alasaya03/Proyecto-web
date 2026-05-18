<%@ page import="java.sql.*, java.security.MessageDigest" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%! 
    public String hashPassword(String pass) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashed = md.digest(pass.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashed) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            return pass;
        }
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    String correo = request.getParameter("correo");
    String pass1 = request.getParameter("contra");
    String pass2 = request.getParameter("contra2");

    // Validaciones
    if (correo == null || pass1 == null || pass2 == null) {
        response.sendRedirect("cambiarcontraseña.html?error=invalid_params");
        return;
    }

    if (!pass1.equals(pass2)) {
        response.sendRedirect("cambiarcontraseña.html?error=no_match");
        return;
    }

    String passHash = hashPassword(pass1);

    boolean updated = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/petify",
            "root", "n0m3l0"
        );

        // Intentar actualizar en tutor
        String sql1 = "UPDATE tutor SET contraseña=? WHERE correo=?";
        PreparedStatement pst1 = conn.prepareStatement(sql1);
        pst1.setString(1, passHash);
        pst1.setString(2, correo);

        if (pst1.executeUpdate() > 0) updated = true;
        pst1.close();

        // Si no existe en tutor, buscar en veterinario
        if (!updated) {
            String sql2 = "UPDATE veterinario SET contraseña=? WHERE correo=?";
            PreparedStatement pst2 = conn.prepareStatement(sql2);
            pst2.setString(1, passHash);
            pst2.setString(2, correo);

            if (pst2.executeUpdate() > 0) updated = true;
            pst2.close();
        }

        conn.close();

    } catch (Exception e) {
        response.sendRedirect("cambiarcontraseña.html?error=server");
        return;
    }

    if (updated) {
        response.sendRedirect("iniciosesion.html?success=password_changed");
    } else {
        response.sendRedirect("cambiarcontraseña.html?error=email_not_found");
    }
%>