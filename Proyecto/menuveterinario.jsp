<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Si alguien intenta entrar sin iniciar sesión, lo sacamos
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

<header>
    <h1>Bienvenido, <%= nombreVete %></h1>
    <nav>
        <a href="index.html">Inicio</a>
        <a href="cerrarSesion.jsp">Cerrar Sesión</a>
    </nav>
</header>

<section class="contenedor">
    <h2>Opciones Disponibles</h2>

    <div class="opciones">
        <a href="listaPacientes.jsp" class="opcion">Ver Pacientes</a>
        <a href="citasProgramadas.jsp" class="opcion">Citas Programadas</a>
        <a href="agendarCitaVete.jsp" class="opcion">Agendar Cita</a>
        <a href="miPerfilVeterinario.jsp" class="opcion">Mi Perfil</a>
    </div>
</section>

</body>
</html>
