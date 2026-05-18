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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Citas Programadas</title>
    <link rel="stylesheet" href="es.css">
</head>
<body>
<div class="container">
    <h1 class="titulo">Citas Programadas</h1>
    <p class="subtitulo">Veterinario: <%= session.getAttribute("userName") %></p>

    <table border="1" cellpadding="8" cellspacing="0">
        <thead>
            <tr>
                <th>Fecha</th>
                <th>Hora</th>
                <th>Tutor</th>
                <th>Mascota</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                    "root","n0m3l0"
                );

                String sql = "SELECT c.fecha, c.hora, t.nom_tutor, m.nombre " +
                             "FROM citas c " +
                             "JOIN tutor t ON c.id_tutor = t.id_tutor " +
                             "JOIN mascota m ON c.id_mascota = m.id_mascota " +
                             "WHERE c.id_vete = ? " +
                             "ORDER BY c.fecha, c.hora";

                ps = conn.prepareStatement(sql);
                ps.setInt(1, idVete);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getDate("fecha") %></td>
                        <td><%= rs.getString("hora").substring(0,5) %></td>
                        <td><%= rs.getString("nom_tutor") %></td>
                        <td><%= rs.getString("nombre") %></td>
                    </tr>
        <%
                }
            } catch(Exception e) {
                e.printStackTrace();
        %>
                <tr><td colspan="4">Error al cargar citas</td></tr>
        <%
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>