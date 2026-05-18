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
    <title>Agendar Cita</title>
    <link rel="stylesheet" href="es.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom right, #e0f7fa, #ffffff);
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            max-width: 950px;
            margin: 30px auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }

        .titulo {
            font-size: 36px;
            color: #00796b;
            margin-bottom: 8px;
        }

        .subtitulo {
            font-size: 16px;
            color: #555;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin: 12px 0 5px 0;
            font-weight: 600;
            color: #00796b;
        }

        select {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #b2dfdb;
            background: #f1fdfd;
            font-size: 14px;
            margin-bottom: 15px;
            transition: all 0.2s;
        }

        select:hover {
            border-color: #00796b;
            box-shadow: 0 0 8px rgba(0,121,107,0.2);
        }

        a {
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
            color: #ffffff;
            background: #00796b;
            padding: 12px 25px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        a:hover {
            background: #004d40;
            transform: scale(1.05);
        }

        /* === CALENDARIO === */
        .calendar {
            width: 100%;
            margin-top: 20px;
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            animation: fadeIn 1s ease-in-out;
        }

        .calendar table {
            width: 100%;
            border-collapse: collapse;
        }

        .calendar thead th {
            font-weight: 600;
            color: #00796b;
            padding: 12px 6px;
            font-size: 14px;
            letter-spacing: 1px;
            text-align: center;
            min-width: 40px;
        }

        .calendar td {
            padding: 12px;
            text-align: center;
            font-size: 14px;
            border-radius: 8px;
            transition: all 0.2s;
            cursor: pointer;
        }

        .calendar td:hover {
            background: #b2dfdb;
        }

        .selected {
            background: #00796b !important;
            color: white !important;
            font-weight: bold;
        }

        .time-selection {
            margin-top: 20px;
        }

        .time-btn {
            background: #00796b;
            padding: 10px 18px;
            margin: 6px;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            display: inline-block;
            font-weight: bold;
            transition: all 0.3s;
        }

        .time-btn:hover {
            background: #004d40;
            transform: scale(1.1);
        }

        .time-selected {
            background: #00bfa5 !important;
            color: white !important;
        }

        #confirm-btn {
            margin-top: 25px;
            background: #00bfa5;
            color: white;
            padding: 12px 22px;
            font-size: 16px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        #confirm-btn:hover {
            background: #00796b;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="titulo">Agendar Cita</h1>
    <p class="subtitulo">Selecciona mascota, veterinario, fecha y hora</p>

    <input type="hidden" id="ID_TUTOR" value="<%= idTutor %>">

    <label for="ID_MASCOTA">Mascota:</label>
    <select id="ID_MASCOTA">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                    "root","n0m3l0"
                );
                ps = conn.prepareStatement("SELECT id_mascota, nombre FROM mascota WHERE id_tutor=?");
                ps.setInt(1, idTutor);
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
            <option value="<%= rs.getInt("id_mascota") %>"><%= rs.getString("nombre") %></option>
        <%
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); }
        %>
    </select>

    <label for="ID_VETE">Veterinario:</label>
    <select id="ID_VETE">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                    "root","n0m3l0"
                );
                ps = conn.prepareStatement("SELECT id_vete, nom_vete FROM veterinario");
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
            <option value="<%= rs.getInt("id_vete") %>"><%= rs.getString("nom_vete") %></option>
        <%
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); }
        %>
    </select>

    <jsp:include page="Calendario.jsp"/>
</div>
<div style="text-align:center;">
    <a href="menututor.jsp">Regresar</a>
</div>
</body>
</html>
