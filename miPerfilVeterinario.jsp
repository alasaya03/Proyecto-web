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

    String nombre = "";
    String especialidad = "";
    String telefono = "";
    String correo = "";
%> 
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Perfil del Veterinario</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');

        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: url("imagenes/petifyFondo.png") no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }

        @keyframes fadeSlide {
            0% { opacity: 0; transform: translateY(25px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        @keyframes smoothPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.015); }
            100% { transform: scale(1); }
        }

        .container {
            width: 450px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            padding: 35px;
            border-radius: 22px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.35);
            color: #fff;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.25);
            animation: fadeSlide 0.9s ease forwards, smoothPulse 6s ease-in-out infinite;
        }

        .titulo {
            font-size: 30px;
            margin-bottom: 25px;
            font-weight: 600;
            color: #ffffff;
            text-shadow: 0 0 6px rgba(0,0,0,0.5);
            animation: fadeSlide 1.2s ease forwards;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            color: #fff;
        }

        th {
            text-align: left;
            padding: 12px;
            font-weight: 600;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.1);
        }

        td {
            padding: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.05);
        }

        a {
            display: inline-block;
            margin-top: 25px;
            padding: 12px 30px;
            background: rgba(255,255,255,0.2);
            color: #fff;
            text-decoration: none;
            border-radius: 12px;
            transition: 0.35s;
            font-weight: 500;
            border: 1px solid rgba(255,255,255,0.35);
        }

        a:hover {
            background: rgba(255,255,255,0.4);
            box-shadow: 0 0 12px rgba(255,255,255,0.7);
            transform: translateY(-3px);
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="titulo">Perfil del Veterinario</h1>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                "root","n0m3l0"
            );

            String sql = "SELECT nom_vete, especialidad, telefono, correo FROM veterinario WHERE id_vete = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idVete);
            rs = ps.executeQuery();

            if (rs.next()) {
                nombre = rs.getString("nom_vete");
                especialidad = rs.getString("especialidad");
                telefono = rs.getString("telefono");
                correo = rs.getString("correo");
            }
        } catch(Exception e) {
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    %>

    <table>
        <tr><th>Nombre</th><td><%= nombre %></td></tr>
        <tr><th>Especialidad</th><td><%= especialidad %></td></tr>
        <tr><th>Teléfono</th><td><%= telefono %></td></tr>
        <tr><th>Correo</th><td><%= correo %></td></tr>
    </table>

    <a href="menuveterinario.jsp">Volver al menú</a>
</div>
</body>
</html>
