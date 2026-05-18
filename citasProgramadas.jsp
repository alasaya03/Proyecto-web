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
    <title>Citas Programadas</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Urbanist:wght@300;400;600;800&display=swap');

        body {
            margin: 0;
            padding: 0;
            font-family: 'Urbanist', sans-serif;
            background: #0c0f16 url("imagenes/petifyFondo.png") no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .glow {
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(0,200,255,0.25), transparent 70%);
            filter: blur(90px);
            animation: mover 10s infinite alternate ease-in-out;
            top: -100px;
            left: -100px;
        }

        @keyframes mover {
            0% { transform: translate(0,0); }
            100% { transform: translate(200px,150px); }
        }

        .panel {
            background: rgba(10, 12, 20, 0.85);
            border: 2px solid rgba(0,255,255,0.35);
            border-radius: 18px;
            padding: 40px;
            width: 90%;
            max-width: 900px;
            color: #e9faff;
            box-shadow: 0 0 30px rgba(0,255,255,0.18);
            animation: spawn 0.9s ease-out forwards;
            opacity: 0;
            transform: scale(0.85) translateY(40px);
        }

        @keyframes spawn {
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        .titulo {
            text-align: center;
            font-size: 36px;
            font-weight: 800;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 5px;
            background: linear-gradient(90deg, #00eaff, #6bff8c);
            -webkit-background-clip: text;
            color: transparent;
        }

        .sub {
            text-align: center;
            font-size: 18px;
            opacity: 0.8;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 12px;
            animation: tablaEntrada 1.2s ease-out forwards;
            opacity: 0;
            transform: translateY(30px);
        }

        @keyframes tablaEntrada {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        th {
            background: rgba(0,255,255,0.18);
            padding: 12px;
            font-size: 16px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        td {
            padding: 12px;
            background: rgba(255,255,255,0.05);
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }

        tr:hover td {
            background: rgba(0,255,255,0.15);
            transition: 0.3s;
        }
    </style>
</head>
<body>

<div class="glow"></div>

<div class="panel">
    <h1 class="titulo">Citas Programadas</h1>
    <p class="sub">Veterinario: <%= session.getAttribute("userName") %></p>

    <table>
        <thead>
            <tr>
                <th>Fecha</th>
                <th>Hora</th>
                <th>Tutor</th>
                <th>Mascota</th>
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

                String sql = "SELECT c.fecha, c.hora, t.nom_tutor, m.nombre " +
                             "FROM citas c " +
                             "JOIN tutor t ON c.id_tutor = t.id_tutor " +
                             "JOIN mascota m ON c.id_mascota = m.id_mascota " +
                             "WHERE c.id_vete = ? " +
                             "ORDER BY c.fecha, c.hora";

                ps = conn.prepareStatement(sql);
                ps.setInt(1, idVete);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getDate("fecha") %></td>
                <td><%= rs.getString("hora").substring(0,5) %></td>
                <td><%= rs.getString("nom_tutor") %></td>
                <td><%= rs.getString("nombre") %></td>
            </tr>
        <%
                }
            } catch(Exception e) {
        %>
            <tr><td colspan="4">Error al cargar citas</td></tr>
        <%
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>
        </tbody>
    </table>

</div>

</body>
</html>
