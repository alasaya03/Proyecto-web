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
<title>Agendar Cita Veterinario</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Urbanist:wght@300;400;600;800&display=swap');

body {
    margin:0; padding:0;
    font-family: 'Urbanist', sans-serif;
    background:#0c0f16 url("imagenes/petifyFondo.png") no-repeat center center fixed;
    background-size: cover;
    display:flex; justify-content:center; align-items:flex-start;
    min-height:100vh;
    color:#e0e0e0;
}

.glow {
    position:absolute;
    width:400px; height:400px;
    background: radial-gradient(circle, rgba(0,200,255,0.25), transparent 70%);
    filter: blur(90px);
    animation:mover 12s infinite alternate ease-in-out;
    top:-50px; left:-50px;
}
@keyframes mover {
    0% { transform: translate(0,0); }
    100% { transform: translate(200px,150px); }
}

.panel {
    background: rgba(10,12,20,0.9);
    border: 2px solid rgba(0,240,255,0.35);
    border-radius: 20px;
    padding: 40px 50px;
    margin: 40px 0;
    width: 90%;
    max-width: 700px;
    box-shadow: 0 0 30px rgba(0,240,255,0.2);
    animation: appear 0.9s ease-out forwards;
    opacity: 0;
    transform: scale(0.85) translateY(30px);
}

@keyframes appear {
    to {
        opacity:1;
        transform: scale(1) translateY(0);
    }
}

.titulo {
    font-size:36px;
    text-align:center;
    font-weight:800;
    background: linear-gradient(90deg, #00f0ff, #28f4a8);
    -webkit-background-clip: text;
    color: transparent;
    margin-bottom:5px;
}

.subtitulo {
    text-align:center;
    font-size:18px;
    color:#a0a0a0;
    margin-bottom:25px;
}

label {
    display:block;
    text-align:left;
    margin:15px 0 5px 0;
    font-weight:600;
}

select {
    width:100%;
    padding:10px 12px;
    border-radius:10px;
    border:1px solid rgba(0,240,255,0.3);
    background: rgba(0,0,0,0.2);
    color:#e0e0e0;
    font-size:16px;
    transition: all 0.3s ease;
}

select:hover, select:focus {
    border-color: #00f0ff;
    box-shadow: 0 0 10px rgba(0,240,255,0.25);
    outline:none;
}

a {
    display:inline-block;
    margin-top:25px;
    text-decoration:none;
    padding:12px 25px;
    border-radius:12px;
    font-weight:600;
    background: linear-gradient(90deg,#00f0ff,#28f4a8);
    color:#0c0f16;
    transition: all 0.3s ease;
}

a:hover {
    transform: scale(1.05);
    background: linear-gradient(90deg,#28f4a8,#00f0ff);
}
</style>
</head>
<body>

<div class="glow"></div>

<div class="panel">
    <h1 class="titulo">Agendar Cita</h1>
    <p class="subtitulo">Selecciona tutor, mascota, fecha y hora</p>

    <input type="hidden" id="ID_VETE" value="<%= idVete %>">

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
                    <option value="<%= rs.getInt("id_tutor") %>" <%= first ? "selected" : "" %>><%= rs.getString("nom_tutor") %></option>
        <%
                    first = false;
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); }
        %>
    </select>

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
                    <option value="<%= rs.getInt("id_mascota") %>" <%= firstM ? "selected" : "" %>><%= rs.getString("nombre") %></option>
        <%
                    firstM = false;
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); }
        %>
    </select>

    <jsp:include page="Calendario.jsp"/>
</div>

<div style="text-align:center; margin-top:20px;">
    <a href="menuveterinario.jsp">Regresar</a>
</div>
<script>
document.addEventListener("DOMContentLoaded", function () {

    const tutorSelect = document.getElementById("ID_TUTOR");
    const mascotaSelect = document.getElementById("ID_MASCOTA");

    function cargarMascotas(idTutor) {
        if (!idTutor) {
            mascotaSelect.innerHTML = "<option>Selecciona un tutor</option>";
            return;
        }

        mascotaSelect.innerHTML = "<option>Cargando...</option>";

        fetch("getMascotas.jsp?id_tutor=" + idTutor)
            .then(response => response.text()) // 🔥 IMPORTANTE (no JSON)
            .then(data => {
                mascotaSelect.innerHTML = data;

                if (data.trim() === "") {
                    mascotaSelect.innerHTML = "<option>No hay mascotas</option>";
                }
            })
            .catch(error => {
                console.error(error);
                mascotaSelect.innerHTML = "<option>Error al cargar</option>";
            });
    }

    // 🔥 Cuando cambia el tutor
    tutorSelect.addEventListener("change", function () {
        cargarMascotas(this.value);
    });

    // 🔥 Cargar automáticamente el primero
    if (tutorSelect.value) {
        cargarMascotas(tutorSelect.value);
    }
});
</script>
</body>
</html>
