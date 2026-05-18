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

    String nombre = "";
    String telefono = "";
    String correo = "";
    int totalMascotas = 0;
    int totalCitas = 0;
%>
<!DOCTYPE html>
<html lang="es"> 
<head>
    <meta charset="UTF-8">
    <title>Perfil del Tutor</title>
    <link rel="stylesheet" href="es.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom right, #e3f2fd, #ffffff);
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            background: rgba(255,255,255,0.95);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.12);
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }

        .titulo {
            font-size: 36px;
            color: #1976d2;
            margin-bottom: 20px;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
        }

        th {
            background-color: #1976d2;
            color: white;
            border-radius: 8px 8px 0 0;
        }

        td {
            background: #e3f2fd;
            border-bottom: 1px solid #b3e5fc;
        }

        tr:last-child td {
            border-bottom: none;
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
    <h1 class="titulo">Perfil del Tutor</h1>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                "root","n0m3l0"
            );

            ps = conn.prepareStatement("SELECT nom_tutor, telefono, correo FROM tutor WHERE id_tutor=?");
            ps.setInt(1, idTutor);
            rs = ps.executeQuery();
            if (rs.next()) {
                nombre = rs.getString("nom_tutor");
                telefono = rs.getString("telefono");
                correo = rs.getString("correo");
            }
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM mascota WHERE id_tutor=?");
            ps.setInt(1, idTutor);
            rs = ps.executeQuery();
            if (rs.next()) totalMascotas = rs.getInt("total");
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM citas WHERE id_tutor=?");
            ps.setInt(1, idTutor);
            rs = ps.executeQuery();
            if (rs.next()) totalCitas = rs.getInt("total");
            rs.close();
            ps.close();

            conn.close();
        } catch(Exception e) { e.printStackTrace(); }
    %>

    <table>
        <tr>
            <th>Nombre</th>
            <td><%= nombre %></td>
        </tr>
        <tr>
            <th>Teléfono</th>
            <td><%= telefono %></td>
        </tr>
        <tr>
            <th>Correo</th>
            <td><%= correo %></td>
        </tr>
        <tr>
            <th>Mascotas registradas</th>
            <td><%= totalMascotas %></td>
        </tr>
        <tr>
            <th>Citas programadas</th>
            <td><%= totalCitas %></td>
        </tr>
    </table>

    <div style="text-align:center;">
        <a href="menututor.jsp">Volver al menú</a>
    </div>
</div>
</body>
</html>
