<%@ page import="java.sql.*" %>
<%
Integer idTutor = (Integer) session.getAttribute("userId");
if (idTutor == null) {
    response.sendRedirect("iniciosesion.html?error=session");
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Mascota</title>
</head>
<body>

<h1>Registrar Mascota</h1>

<% if (request.getParameter("error") != null) { %>
    <p style="color:red;">Error al registrar la mascota.</p>
<% } %>

<form method="post" action="procesarMascota.jsp">
    <label>Nombre:</label>
    <input type="text" name="nombre" required>

    <label>Edad:</label>
    <input type="text" name="edad" required>

    <label>Sexo:</label>
    <select name="sexo" required>
        <option value="Macho">Macho</option>
        <option value="Hembra">Hembra</option>
    </select>

    <label>Raza:</label>
    <input type="text" name="raza" required>

    <label>Peso (kg):</label>
    <input type="number" step="0.01" name="peso" required>

    <label>Veterinario:</label>
    <select name="id_vete" required>
        <%
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/petify", "root", "n0m3l0");

            PreparedStatement ps = con.prepareStatement("SELECT id_vete, nom_vete FROM veterinario");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
        %>
                <option value="<%= rs.getInt("id_vete") %>"><%= rs.getString("nom_vete") %></option>
        <%
            }
            con.close();
        %>
    </select>

    <button type="submit">Registrar</button>
</form>

</body>
</html>
