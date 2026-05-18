<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null || !"veterinario".equals(session.getAttribute("userType"))) {
        response.sendRedirect("iniciosesionvete.html?error=not_logged");
        return;
    }

    String nombreVete = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel del Veterinario</title>
    <link rel="stylesheet" href="menuveterinario.css">
</head>
<body>

<div class="background"></div>

<header class="header">
    <h1 class="titulo">Bienvenido, <%= nombreVete %></h1>

    <nav class="nav">
        <a href="index.html" class="nav-btn">Inicio</a>
        <a href="cerrarSesion.jsp" class="nav-btn salir">Cerrar Sesión</a>
    </nav>
</header>

<section class="contenedor">
    <h2 class="subtitulo">Opciones Disponibles</h2>

    <div class="opciones">
        <a href="listaPacientes.jsp" class="opcion card">Ver Pacientes</a>
        <a href="citasProgramadas.jsp" class="opcion card">Citas Programadas</a>
        <a href="agendarCitaVete.jsp" class="opcion card">Agendar Cita</a>
        <a href="miPerfilVeterinario.jsp" class="opcion card">Mi Perfil</a>
    </div>
</section>

</body>
</html>
