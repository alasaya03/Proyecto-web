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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de Citas</title>
    <link rel="stylesheet" href="es.css">
</head>
<body>
<div class="container">
    <h1 class="titulo">Historial de Citas</h1>

    <h2>Todas tus citas</h2>
    <table border="1" cellpadding="8" cellspacing="0">
        <thead>
            <tr>
                <th>Fecha</th>
                <th>Hora</th>
                <th>Mascota</th>
                <th>Veterinario</th>
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

                String sqlHistorial = "SELECT c.fecha, c.hora, m.nombre AS mascota, v.nom_vete AS veterinario " +
                                      "FROM citas c " +
                                      "JOIN mascota m ON c.id_mascota = m.id_mascota " +
                                      "JOIN veterinario v ON c.id_vete = v.id_vete " +
                                      "WHERE c.id_tutor = ? " +
                                      "ORDER BY c.fecha DESC, c.hora DESC";
                ps = conn.prepareStatement(sqlHistorial);
                ps.setInt(1, idTutor);
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getDate("fecha") %></td>
                        <td><%= rs.getString("hora").substring(0,5) %></td>
                        <td><%= rs.getString("mascota") %></td>
                        <td><%= rs.getString("veterinario") %></td>
                    </tr>
        <%
                }
                rs.close();
                ps.close();
        %>
        </tbody>
    </table>

    <h2>Última cita programada</h2>
    <%
                String sqlUltima = "SELECT c.fecha, c.hora, m.nombre AS mascota, v.nom_vete AS veterinario " +
                                   "FROM citas c " +
                                   "JOIN mascota m ON c.id_mascota = m.id_mascota " +
                                   "JOIN veterinario v ON c.id_vete = v.id_vete " +
                                   "WHERE c.id_tutor = ? " +
                                   "ORDER BY c.fecha DESC, c.hora DESC LIMIT 1";
                ps = conn.prepareStatement(sqlUltima);
                ps.setInt(1, idTutor);
                rs = ps.executeQuery();
                if (rs.next()) {
    %>
                    <p><strong>Fecha:</strong> <%= rs.getDate("fecha") %></p>
                    <p><strong>Hora:</strong> <%= rs.getString("hora").substring(0,5) %></p>
                    <p><strong>Mascota:</strong> <%= rs.getString("mascota") %></p>
                    <p><strong>Veterinario:</strong> <%= rs.getString("veterinario") %></p>
    <%
                } else {
    %>
                    <p>No tienes citas programadas aún.</p>
    <%
                }
                rs.close();
                ps.close();
                conn.close();
            } catch(Exception e) {
                e.printStackTrace();
    %>
                <p>Error al cargar citas.</p>
    <%
            }
    %>

    <br>
    <a href="menututor.jsp">Volver al menú</a>
</div>
</body>
</html>