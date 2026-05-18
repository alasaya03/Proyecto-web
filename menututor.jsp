<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null || !"tutor".equals(session.getAttribute("userType"))) {
        response.sendRedirect("iniciosesion.html?error=not_logged");
        return;
    }
    String nombreTutor = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Panel del Tutor</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Urbanist:wght@300;400;600;800&display=swap');

* { margin:0; padding:0; box-sizing:border-box; }

body {
    font-family: 'Urbanist', sans-serif;
    background: linear-gradient(135deg,#e0f7ff,#a0d4ff);
    min-height:100vh;
    display:flex;
    flex-direction:column;
    align-items:center;
    color:#0c0f16;
    overflow:hidden;
}

header {
    width:100%;
    padding:20px 40px;
    background: rgba(255,255,255,0.95);
    box-shadow:0 6px 18px rgba(0,0,0,0.15);
    display:flex;
    justify-content: space-between;
    align-items:center;
    position:sticky;
    top:0;
    z-index:10;
    animation:fadeInDown 1s ease forwards;
}

header h1 {
    font-size:28px;
    color:#0077c2;
}

header nav a {
    text-decoration:none;
    margin-left:20px;
    font-weight:600;
    color:#0c0f16;
    transition:0.3s;
}

header nav a:hover {
    color:#2196f3;
}

.contenedor {
    width:90%;
    max-width:1000px;
    margin-top:50px;
    text-align:center;
    animation:fadeIn 1.5s ease forwards;
}

.contenedor h2 {
    font-size:26px;
    margin-bottom:30px;
    color:#0077c2;
}

.opciones {
    display:grid;
    grid-template-columns: repeat(auto-fit,minmax(180px,1fr));
    gap:25px;
}

.opcion {
    background: linear-gradient(135deg,#2196f3,#64b5f6);
    padding:22px 15px;
    border-radius:16px;
    font-size:18px;
    font-weight:700;
    text-decoration:none;
    color:white;
    box-shadow:0 10px 25px rgba(0,0,0,0.2);
    transition: all 0.4s ease;
}

.opcion:hover {
    transform: translateY(-6px) scale(1.06);
    box-shadow:0 14px 35px rgba(33,150,243,0.5);
}

body::before {
    content:'';
    position:absolute;
    width:100%; height:100%;
    background: radial-gradient(circle, rgba(255,255,255,0.12) 1px, transparent 1px);
    background-size:25px 25px;
    top:0; left:0;
    z-index:0;
    animation:moveParticles 60s linear infinite;
}

@keyframes fadeInDown {
    from { opacity:0; transform: translateY(-30px);}
    to { opacity:1; transform: translateY(0);}
}

@keyframes fadeIn {
    from { opacity:0; transform: translateY(20px);}
    to { opacity:1; transform: translateY(0);}
}

@keyframes moveParticles {
    from { background-position: 0 0; }
    to { background-position: 600px 600px; }
}
</style>
</head>
<body>

<header>
    <h1>Bienvenido, <%= nombreTutor %></h1>
    <nav>
        <a href="index.html">Inicio</a>
        <a href="cerrarSesion.jsp">Cerrar Sesión</a>
    </nav>
</header>

<section class="contenedor">
    <h2>Opciones Disponibles</h2>
    <div class="opciones">
        <a href="registromascota.jsp" class="opcion">Registrar Mascota</a>
        <a href="mismascotas.jsp" class="opcion">Mis Mascotas</a>
        <a href="agendarCitaTutor.jsp" class="opcion">Agendar Cita</a>
        <a href="miPerfilTutor.jsp" class="opcion">Mi Perfil</a>
        <a href="historialCitas.jsp" class="opcion">Historial de citas</a>
    </div>
</section>

</body>
</html>
