<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userId") == null || !"tutor".equals(session.getAttribute("userType"))) {
        response.sendRedirect("iniciosesion.html?error=not_logged");
        return;
    }

    int idTutor = (Integer) session.getAttribute("userId");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de Citas</title>
    <link rel="stylesheet" href="es.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom right, #e1f5fe, #ffffff);
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            background: rgba(255,255,255,0.95);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }

        .titulo {
            font-size: 36px;
            color: #0288d1;
            text-align: center;
            margin-bottom: 25px;
        }

        h2 {
            color: #0277bd;
            margin-top: 30px;
            margin-bottom: 15px;
            border-bottom: 2px solid #0288d1;
            padding-bottom: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
        }

        th {
            background-color: #0288d1;
            color: white;
            border-radius: 8px 8px 0 0;
        }

        td {
            background: #e1f5fe;
            border-bottom: 1px solid #b3e5fc;
        }

        tr:last-child td {
            border-bottom: none;
        }

        p {
            background: #e3f2fd;
            padding: 10px 15px;
            border-radius: 8px;
            margin: 8px 0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        p:hover {
            background: #b3e5fc;
            transform: translateX(5px);
        }

        a {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            background: #0288d1;
            color: #fff;
            padding: 12px 28px;
            border-radius: 10px;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        a:hover {
            background: #01579b;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="titulo">Historial de Citas</h1>

    <h2>Todas tus citas</h2>
    <table>
        <thead>
            <tr>
                <th>Fecha</th>
                <th>Hora</th>
                <th>Mascota</th>
                <th>Veterinario</th>
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

                String sqlHistorial = "SELECT c.fecha, c.hora, m.nombre AS mascota, v.nom_vete AS veterinario " +
                                      "FROM citas c " +
                                      "JOIN mascota m ON c.id_mascota = m.id_mascota " +
                                      "JOIN veterinario v ON c.id_vete = v.id_vete " +
                                      "WHERE c.id_tutor = ? " +
                                      "ORDER BY c.fecha DESC, c.hora DESC";
                ps = conn.prepareStatement(sqlHistorial);
                ps.setInt(1, idTutor);
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getDate("fecha") %></td>
                        <td><%= rs.getString("hora").substring(0,5) %></td>
                        <td><%= rs.getString("mascota") %></td>
                        <td><%= rs.getString("veterinario") %></td>
                    </tr>
        <%
                }
                rs.close();
                ps.close();
        %>
        </tbody>
    </table>

    <h2>Última cita programada</h2>
    <%
                String sqlUltima = "SELECT c.fecha, c.hora, m.nombre AS mascota, v.nom_vete AS veterinario " +
                                   "FROM citas c " +
                                   "JOIN mascota m ON c.id_mascota = m.id_mascota " +
                                   "JOIN veterinario v ON c.id_vete = v.id_vete " +
                                   "WHERE c.id_tutor = ? " +
                                   "ORDER BY c.fecha DESC, c.hora DESC LIMIT 1";
                ps = conn.prepareStatement(sqlUltima);
                ps.setInt(1, idTutor);
                rs = ps.executeQuery();
                if (rs.next()) {
    %>
                    <p><strong>Fecha:</strong> <%= rs.getDate("fecha") %></p>
                    <p><strong>Hora:</strong> <%= rs.getString("hora").substring(0,5) %></p>
                    <p><strong>Mascota:</strong> <%= rs.getString("mascota") %></p>
                    <p><strong>Veterinario:</strong> <%= rs.getString("veterinario") %></p>
    <%
                } else {
    %>
                    <p>No tienes citas programadas aún.</p>
    <%
                }
                rs.close();
                ps.close();
                conn.close();
            } catch(Exception e) {
                e.printStackTrace();
    %>
                <p>Error al cargar citas.</p>
    <%
            }
    %>

    <div style="text-align:center;">
        <a href="menututor.jsp">Volver al menú</a>
    </div>
</div>
</body>
</html>
