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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mis Mascotas</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Urbanist:wght@300;400;600;800&display=swap');

* { margin:0; padding:0; box-sizing:border-box; }

body {
    font-family: 'Urbanist', sans-serif;
    background: linear-gradient(135deg,#cce7ff,#e0f7ff);
    display:flex;
    justify-content:center;
    padding:40px 0;
    min-height:100vh;
    color:#0c0f16;
}

h1 {
    text-align:center;
    font-size:32px;
    margin-bottom:30px;
    color:#0077c2;
    animation:fadeInDown 1s ease forwards;
}

table {
    width:90%;
    max-width:900px;
    border-collapse: separate;
    border-spacing:0;
    border-radius:12px;
    overflow:hidden;
    box-shadow:0 12px 30px rgba(0,0,0,0.15);
    background:white;
    animation:fadeIn 1.5s ease forwards;
}

thead {
    background: linear-gradient(135deg,#2196f3,#64b5f6);
    color:white;
}

th, td {
    padding:12px 18px;
    text-align:center;
    font-size:16px;
}

tbody tr {
    transition: transform 0.3s, background 0.3s;
    cursor:pointer;
}

tbody tr:hover {
    background: #e0f7ff;
    transform: scale(1.02);
}

tbody tr:nth-child(even) {
    background:#f5faff;
}

td:last-child {
    font-weight:600;
    color:#0077c2;
}

.no-data {
    text-align:center;
    padding:20px;
    font-weight:600;
    color:#555;
}

@keyframes fadeInDown {
    from { opacity:0; transform: translateY(-30px);}
    to { opacity:1; transform: translateY(0);}
}

@keyframes fadeIn {
    from { opacity:0; transform: translateY(20px);}
    to { opacity:1; transform: translateY(0);}
}
</style>
</head>
<body>

<div>
<h1>Mis Mascotas</h1>

<table>
    <thead>
        <tr>
            <th>Nombre</th>
            <th>Edad</th>
            <th>Sexo</th>
            <th>Raza</th>
            <th>Peso</th>
            <th>Veterinario</th>
        </tr>
    </thead>
    <tbody>
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
        <tr><td colspan="6" class="no-data">No tienes mascotas registradas.</td></tr>
<%
        }

        con.close();
    } catch (Exception e) {
%>
        <tr><td colspan="6" class="no-data">Error: <%= e.getMessage() %></td></tr>
<%
    }
%>
    </tbody>
</table>
</div>

</body>
</html>
