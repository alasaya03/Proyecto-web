<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
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
    <title>Clientes atendidos</title>
    <link rel="stylesheet" href="es.css">
</head>
<body>
<div class="container">
    <h1 class="titulo">Clientes atendidos</h1>
    <p class="subtitulo">Veterinario: <%= session.getAttribute("userName") %></p>

    <table border="1" cellpadding="8" cellspacing="0">
        <thead>
            <tr>
                <th>Nombre del Tutor</th>
                <th>Correo</th>
                <th>Total de citas</th>
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

                String sql = "SELECT t.nom_tutor, t.correo, COUNT(*) AS total_citas " +
                             "FROM citas c " +
                             "JOIN tutor t ON c.id_tutor = t.id_tutor " +
                             "WHERE c.id_vete = ? " +
                             "GROUP BY t.nom_tutor, t.correo";

                ps = conn.prepareStatement(sql);
                ps.setInt(1, idVete);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getString("nom_tutor") %></td>
                        <td><%= rs.getString("correo") %></td>
                        <td><%= rs.getInt("total_citas") %></td>
                    </tr>
        <%
                }
            } catch(Exception e) {
                e.printStackTrace();
        %>
                <tr><td colspan="3">Error al cargar clientes</td></tr>
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