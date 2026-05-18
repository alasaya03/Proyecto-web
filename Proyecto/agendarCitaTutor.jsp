<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
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
    <title>Agendar Cita</title>
    <link rel="stylesheet" href="es.css">
</head>
<body>
<div class="container">
    <h1 class="titulo">Agendar Cita</h1>
    <p class="subtitulo">Selecciona mascota, veterinario, fecha y hora</p>

    <!-- Tutor fijo -->
    <input type="hidden" id="ID_TUTOR" value="<%= idTutor %>">

    <!-- Lista de mascotas del tutor -->
    <label for="ID_MASCOTA">Mascota:</label>
    <select id="ID_MASCOTA">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                    "root","n0m3l0"
                );
                ps = conn.prepareStatement("SELECT id_mascota, nombre FROM mascota WHERE id_tutor=?");
                ps.setInt(1, idTutor);
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("id_mascota") %>"><%= rs.getString("nombre") %></option>
        <%
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); }
        %>
    </select>

    <!-- Lista de veterinarios -->
    <label for="ID_VETE">Veterinario:</label>
    <select id="ID_VETE">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                    "root","n0m3l0"
                );
                ps = conn.prepareStatement("SELECT id_vete, nom_vete FROM veterinario");
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("id_vete") %>"><%= rs.getString("nom_vete") %></option>
        <%
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); }
        %>
    </select>

    <!-- Incluir calendario -->
    <jsp:include page="Calendario.jsp"/>
</div>
<div>
    <a href="menututor.jsp">Regresar</a>
</div>
</body>
</html>