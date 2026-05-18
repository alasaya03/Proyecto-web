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
    <title>Agendar Cita Veterinario</title>
    <!-- Estilos -->
    <link rel="stylesheet" href="es.css">
</head>
<body>
<div class="container">
    <h1 class="titulo">Agendar Cita</h1>
    <p class="subtitulo">Selecciona tutor, mascota, fecha y hora</p>

    <!-- Veterinario fijo -->
    <input type="hidden" id="ID_VETE" value="<%= idVete %>">

    <!-- Lista de tutores -->
    <label for="ID_TUTOR">Tutor:</label>
    <select id="ID_TUTOR">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                    "root","n0m3l0"
                );
                ps = conn.prepareStatement("SELECT id_tutor, nom_tutor FROM tutor");
                rs = ps.executeQuery();
                boolean first = true;
                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("id_tutor") %>" <%= first ? "selected" : "" %>>
                        <%= rs.getString("nom_tutor") %>
                    </option>
        <%
                    first = false;
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); }
        %>
    </select>

    <!-- Lista de mascotas -->
    <label for="ID_MASCOTA">Mascota:</label>
    <select id="ID_MASCOTA">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                    "root","n0m3l0"
                );
                ps = conn.prepareStatement("SELECT id_mascota, nombre FROM mascota");
                rs = ps.executeQuery();
                boolean firstM = true;
                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("id_mascota") %>" <%= firstM ? "selected" : "" %>>
                        <%= rs.getString("nombre") %>
                    </option>
        <%
                    firstM = false;
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); }
        %>
    </select>

    <!-- Incluir calendario -->
    <jsp:include page="Calendario.jsp"/>
</div>
<div>
    <a href="menuveterinario.jsp">Regresar</a>
</div>
</body>
</html>