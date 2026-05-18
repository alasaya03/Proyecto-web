<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("user") == null || !"tutor".equals(session.getAttribute("userType"))) {
        response.sendRedirect("iniciosesion.html?error=not_logged");
        return;
    }

    int idTutor = (int) session.getAttribute("userId"); 
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Mascotas</title>
    <link rel="stylesheet" href="misMascotas.css">
</head>
<body>

<h1>Mis Mascotas</h1>

<table border="1">
    <tr>
        <th>Nombre</th>
        <th>Edad</th>
        <th>Sexo</th>
        <th>Raza</th>
        <th>Peso</th>
        <th>Veterinario</th>
    </tr>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
            "root",
            "n0m3l0"
        );

        String sql = "SELECT m.*, v.nom_vete FROM mascota m " +
                     "JOIN veterinario v ON m.id_vete = v.id_vete " +
                     "WHERE m.id_tutor = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idTutor);

        ResultSet rs = ps.executeQuery();

        boolean tieneMascotas = false;

        while (rs.next()) {
            tieneMascotas = true;
%>
            <tr>
                <td><%= rs.getString("nombre") %></td>
                <td><%= rs.getString("edad") %></td>
                <td><%= rs.getString("sexo") %></td>
                <td><%= rs.getString("raza") %></td>
                <td><%= rs.getBigDecimal("peso") %> kg</td>
                <td><%= rs.getString("nom_vete") %></td>
            </tr>
<%
        }

        if (!tieneMascotas) {
%>
            <tr><td colspan="6">No tienes mascotas registradas.</td></tr>
<%
        }

        con.close();
    } catch (Exception e) {
%>
    <tr><td colspan="6">Error: <%= e.getMessage() %></td></tr>
<%
    }
%>

</table>

</body>
</html>
