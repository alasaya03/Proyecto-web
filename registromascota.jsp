
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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Registrar Mascota</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Urbanist:wght@300;400;600;800&display=swap');

* { margin:0; padding:0; box-sizing:border-box; }

body {
    font-family: 'Urbanist', sans-serif;
    background: linear-gradient(135deg,#e0f7ff,#a0d4ff);
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:flex-start;
    padding-top:60px;
    color:#0c0f16;
}

h1 {
    text-align:center;
    color:#0077c2;
    font-size:32px;
    margin-bottom:20px;
    animation:fadeInDown 1s ease forwards;
}

form {
    background: rgba(255,255,255,0.95);
    padding:30px 40px;
    border-radius:16px;
    box-shadow:0 12px 30px rgba(0,0,0,0.15);
    width:90%;
    max-width:500px;
    display:flex;
    flex-direction:column;
    gap:15px;
    animation:fadeIn 1.5s ease forwards;
}

label {
    font-weight:600;
    margin-bottom:5px;
    color:#0077c2;
}

input, select {
    padding:10px 12px;
    border-radius:8px;
    border:1px solid #ccc;
    font-size:16px;
    transition:0.3s;
}

input:focus, select:focus {
    outline:none;
    border-color:#2196f3;
    box-shadow:0 0 8px rgba(33,150,243,0.3);
}

button {
    padding:12px;
    border:none;
    border-radius:12px;
    background: linear-gradient(135deg,#2196f3,#64b5f6);
    color:white;
    font-size:18px;
    font-weight:700;
    cursor:pointer;
    transition: all 0.3s ease;
}

button:hover {
    transform: translateY(-3px) scale(1.03);
    box-shadow:0 8px 25px rgba(33,150,243,0.5);
}

p.error {
    color:red;
    font-weight:600;
    text-align:center;
    margin-bottom:10px;
}

@keyframes fadeInDown {
    from { opacity:0; transform: translateY(-20px);}
    to { opacity:1; transform: translateY(0);}
}

@keyframes fadeIn {
    from { opacity:0; transform: translateY(10px);}
    to { opacity:1; transform: translateY(0);}
}
</style>
</head>
<body>

<h1>Registrar Mascota</h1>

<% if (request.getParameter("error") != null) { %>
    <p class="error">Error al registrar la mascota.</p>
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
