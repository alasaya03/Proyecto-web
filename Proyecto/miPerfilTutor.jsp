<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // Validar sesión: debe existir userId y ser tutor
    if (session.getAttribute("userId") == null || !"tutor".equals(session.getAttribute("userType"))) {
        response.sendRedirect("iniciosesion.html?error=not_logged");
        return;
    }

    int idTutor = (Integer) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String nombre = "";
    String telefono = "";
    String correo = "";
    int totalMascotas = 0;
    int totalCitas = 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Perfil del Tutor</title>
    <link rel="stylesheet" href="es.css">
</head>
<body>
<div class="container">
    <h1 class="titulo">Perfil del Tutor</h1>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                "root","n0m3l0"
            );

            // Datos básicos del tutor
            ps = conn.prepareStatement("SELECT nom_tutor, telefono, correo FROM tutor WHERE id_tutor=?");
            ps.setInt(1, idTutor);
            rs = ps.executeQuery();
            if (rs.next()) {
                nombre = rs.getString("nom_tutor");
                telefono = rs.getString("telefono");
                correo = rs.getString("correo");
            }
            rs.close();
            ps.close();

            // Total de mascotas
            ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM mascota WHERE id_tutor=?");
            ps.setInt(1, idTutor);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalMascotas = rs.getInt("total");
            }
            rs.close();
            ps.close();

            // Total de citas
            ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM citas WHERE id_tutor=?");
            ps.setInt(1, idTutor);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalCitas = rs.getInt("total");
            }
            rs.close();
            ps.close();

            conn.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    %>

    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>Nombre</th>
            <td><%= nombre %></td>
        </tr>
        <tr>
            <th>Teléfono</th>
            <td><%= telefono %></td>
        </tr>
        <tr>
            <th>Correo</th>
            <td><%= correo %></td>
        </tr>
        <tr>
            <th>Mascotas registradas</th>
            <td><%= totalMascotas %></td>
        </tr>
        <tr>
            <th>Citas programadas</th>
            <td><%= totalCitas %></td>
        </tr>
    </table>

    <br>
    <a href="menututor.jsp">Volver al menú</a>
</div>
</body>
</html>