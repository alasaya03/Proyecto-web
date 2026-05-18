<%@ page import="java.sql.*" %>
<%
    String idTutor = request.getParameter("id_tutor");

    if (idTutor == null || idTutor.isEmpty()) {
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
            "root","n0m3l0"
        );

        ps = con.prepareStatement(
            "SELECT id_mascota, nombre FROM mascota WHERE id_tutor=?"
        );
        ps.setInt(1, Integer.parseInt(idTutor));

        rs = ps.executeQuery();

        while (rs.next()) {
            out.println("<option value='" + rs.getInt("id_mascota") + "'>"
                        + rs.getString("nombre") +
                        "</option>");
        }

    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(con!=null) con.close();
    }
%>