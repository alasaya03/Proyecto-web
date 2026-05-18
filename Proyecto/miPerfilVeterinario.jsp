<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // Validar sesión: debe existir userId y ser veterinario
    if (session.getAttribute("userId") == null || !"veterinario".equals(session.getAttribute("userType"))) {
        response.sendRedirect("iniciosesionvete.html?error=not_logged");
        return;
    }

    int idVete = (Integer) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String nombre = "";
    String especialidad = "";
    String telefono = "";
    String correo = "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Perfil del Veterinario</title>
    <link rel="stylesheet" href="es.css">
</head>
<body>
<div class="container">
    <h1 class="titulo">Perfil del Veterinario</h1>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                "root","n0m3l0"
            );

            String sql = "SELECT nom_vete, especialidad, telefono, correo " +
                         "FROM veterinario WHERE id_vete = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idVete);
            rs = ps.executeQuery();

            if (rs.next()) {
                nombre = rs.getString("nom_vete");
                especialidad = rs.getString("especialidad");
                telefono = rs.getString("telefono");
                correo = rs.getString("correo");
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    %>

    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>Nombre</th>
            <td><%= nombre %></td>
        </tr>
        <tr>
            <th>Especialidad</th>
            <td><%= especialidad %></td>
        </tr>
        <tr>
            <th>Teléfono</th>
            <td><%= telefono %></td>
        </tr>
        <tr>
            <th>Correo</th>
            <td><%= correo %></td>
        </tr>
    </table>

    <br>
    <a href="menuveterinario.jsp">Volver al menú</a>
</div>
</body>
</html>