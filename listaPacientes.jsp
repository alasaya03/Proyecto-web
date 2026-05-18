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
    <title>Clientes atendidos</title>
    <style>
        body {
            margin: 0;
            height: 100vh;
            font-family: "Poppins", sans-serif;
            background: url("imagenes/petifyFondo.png") no-repeat center center fixed;
            background-size: cover;
            overflow-x: hidden;
            animation: bgZoom 3.5s ease forwards;
        }

        @keyframes bgZoom {
            0% { transform: scale(1.15) blur(4px); opacity: 0; }
            40% { opacity: 1; }
            100% { transform: scale(1) blur(0); opacity: 1; }
        }

        .container {
            width: 90%;
            max-width: 950px;
            margin: 50px auto;
            background: rgba(255, 255, 255, 0.82);
            backdrop-filter: blur(10px);
            padding: 35px;
            border-radius: 28px;
            box-shadow: 0 0 25px rgba(255,255,255,0.4),
                        0 0 50px rgba(0,0,0,0.25);
            animation: epicDrop 1.8s cubic-bezier(.13,.56,.18,1.2);
        }

        @keyframes epicDrop {
            0% { transform: translateY(-120px) scale(.85); opacity: 0; filter: blur(6px); }
            60% { transform: translateY(15px) scale(1.02); opacity: 1; }
            100% { transform: translateY(0) scale(1); filter: blur(0); }
        }

        .titulo {
            text-align: center;
            font-size: 36px;
            font-weight: 700;
            color: #1a1a1a;
            animation: glowTitle 2.5s infinite ease-in-out;
        }

        @keyframes glowTitle {
            0% { text-shadow: 0 0 0px rgba(255,255,255,0.6); }
            50% { text-shadow: 0 0 20px rgba(255,255,255,1); }
            100% { text-shadow: 0 0 0px rgba(255,255,255,0.6); }
        }

        .subtitulo {
            text-align: center;
            margin-top: 5px;
            font-size: 18px;
            color: #333;
            opacity: 0;
            animation: fadeInSub 1.6s ease forwards 0.9s;
        }

        @keyframes fadeInSub {
            to { opacity: 1; }
        }

        table {
            width: 100%;
            margin-top: 28px;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 18px;
            animation: holoTable 2.3s ease forwards;
        }

        @keyframes holoTable {
            0% { opacity: 0; transform: translateY(30px) scale(0.9); }
            100% { opacity: 1; transform: translateY(0) scale(1); }
        }

        thead {
            background: linear-gradient(90deg, #141414, #333);
            color: white;
            font-size: 18px;
            letter-spacing: 1px;
        }

        th, td {
            padding: 15px;
            text-align: left;
        }

        tbody tr {
            background: rgba(255,255,255,0.65);
            backdrop-filter: blur(6px);
            border-bottom: 1px solid rgba(0,0,0,0.15);
            transition: 0.3s ease;
            position: relative;
        }

        tbody tr:hover {
            background: rgba(255,255,255,0.92);
            transform: scale(1.015);
            box-shadow: 0 6px 18px rgba(0,0,0,0.18);
        }

        tbody tr:hover td {
            animation: pulseText 0.6s ease;
        }

        @keyframes pulseText {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="titulo">Clientes atendidos</h1>
    <p class="subtitulo">Veterinario: <%= session.getAttribute("userName") %></p>

    <table>
        <thead>
        <tr>
            <th>Nombre del Tutor</th>
            <th>Correo</th>
            <th>Total de citas</th>
        </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                    "root","n0m3l0"
                );

                String sql = "SELECT t.nom_tutor, t.correo, COUNT(*) AS total_citas " +
                             "FROM citas c " +
                             "JOIN tutor t ON c.id_tutor = t.id_tutor " +
                             "WHERE c.id_vete = ? " +
                             "GROUP BY t.nom_tutor, t.correo";

                ps = conn.prepareStatement(sql);
                ps.setInt(1, idVete);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("nom_tutor") %></td>
            <td><%= rs.getString("correo") %></td>
            <td><%= rs.getInt("total_citas") %></td>
        </tr>
        <%
                }
            } catch(Exception e) {
        %>
        <tr><td colspan="3">Error al cargar clientes</td></tr>
        <%
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
