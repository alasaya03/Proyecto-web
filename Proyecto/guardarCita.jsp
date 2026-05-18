<%@ page import="java.sql.*" %>
<%
    response.setContentType("text/plain");

    String fecha = request.getParameter("fecha");
    String hora = request.getParameter("hora");
    String id_tutor = request.getParameter("id_tutor");
    String id_vete = request.getParameter("id_vete");
    String id_mascota = request.getParameter("id_mascota");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
            "root",
            "n0m3l0"
        );

        // Verificar duplicado
        PreparedStatement ps = conn.prepareStatement(
            "SELECT COUNT(*) FROM citas WHERE fecha=? AND hora=? AND id_vete=?"
        );
        ps.setString(1, fecha);
        ps.setString(2, hora);
        ps.setInt(3, Integer.parseInt(id_vete));
        ResultSet rs = ps.executeQuery();
        rs.next();
        if (rs.getInt(1) > 0) {
            out.print("DUPLICADO");
            rs.close();
            ps.close();
            conn.close();
            return;
        }
        rs.close();
        ps.close();

        // Insertar cita
        ps = conn.prepareStatement(
            "INSERT INTO citas (fecha, hora, id_tutor, id_vete, id_mascota) VALUES (?, ?, ?, ?, ?)"
        );
        ps.setString(1, fecha);
        ps.setString(2, hora);
        ps.setInt(3, Integer.parseInt(id_tutor));
        ps.setInt(4, Integer.parseInt(id_vete));
        ps.setInt(5, Integer.parseInt(id_mascota));
        ps.executeUpdate();

        ps.close();
        conn.close();

        out.print("OK");

    } catch (Exception e) {
        out.print("SQL_ERROR: " + e.getMessage());
    }
%>