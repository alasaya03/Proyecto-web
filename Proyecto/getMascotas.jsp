<%@ page import="java.sql.*" %>
<%
    String idTutor = request.getParameter("id_tutor");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost/petify","root","n0m3l0"
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT id_mascota, nombre FROM mascota WHERE id_tutor=?"
    );
    ps.setInt(1, Integer.parseInt(idTutor));

    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        out.println("<option value='" + rs.getInt("id_mascota") + "'>"
                    + rs.getString("nombre") +
                    "</option>");
    }

    rs.close();
    ps.close();
    con.close();
%>
