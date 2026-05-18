<%@ page import="java.sql.*" %>
<table border="1">
<tr><th>ID</th><th>Tutor</th><th>Fecha</th><th>Hora</th></tr>
<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost/petify?useSSL=false&allowPublicKeyRetrieval=true",
        "root",
        "n0m3l0"
    );

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM citas ORDER BY fecha, hora");

    while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("id_cita") %></td>
            <td><%= rs.getInt("id_tutor") %></td>
            <td><%= rs.getString("fecha") %></td>
            <td><%= rs.getString("hora") %></td>
        </tr>
<%
    }
    rs.close();
    con.close();
%>
</table>
