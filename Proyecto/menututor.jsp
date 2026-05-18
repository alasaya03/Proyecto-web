<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Si intenta entrar sin iniciar sesión como tutor, lo sacamos
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
    <title>Panel del Tutor</title>
    <link rel="stylesheet" href="menuTutor.css">
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
        <a href="miPerfilTutor.jsp">Mi Perfil</a>
        <a href="historialCitas.jsp">Historial de citas</a>
    </div>
</section>

</body>
</html>