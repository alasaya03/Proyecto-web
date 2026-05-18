<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%
request.setCharacterEncoding("UTF-8");

Integer idTutor = (Integer) session.getAttribute("userId");
if (idTutor == null) {
    response.sendRedirect("iniciosesion.html?error=session");
    return;
}

String nombre = request.getParameter("nombre");
String edad = request.getParameter("edad");
String sexo = request.getParameter("sexo");
String raza = request.getParameter("raza");
String peso = request.getParameter("peso");
String idVete = request.getParameter("id_vete");

// Validación
if (nombre == null || edad == null || sexo == null || raza == null || peso == null || idVete == null) {
    response.sendRedirect("registromascota.jsp?error=datos");
    return;
}

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/petify", "root", "n0m3l0");

    String sql = "INSERT INTO mascota (nombre, edad, sexo, raza, peso, id_vete, id_tutor) VALUES (?,?,?,?,?,?,?)";
    PreparedStatement pstmt = conn.prepareStatement(sql);

    pstmt.setString(1, nombre);
    pstmt.setString(2, edad);
    pstmt.setString(3, sexo);
    pstmt.setString(4, raza);
    pstmt.setBigDecimal(5, new BigDecimal(peso));
    pstmt.setInt(6, Integer.parseInt(idVete));
    pstmt.setInt(7, idTutor);

    pstmt.executeUpdate();

    conn.close();

    response.sendRedirect("menututor.jsp?success=1");

} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("registromascota.jsp?error=1");
}
%>
