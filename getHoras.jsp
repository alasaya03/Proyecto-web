<%@ page import="java.sql.*, java.util.*, com.google.gson.Gson" %>
<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    String fecha = request.getParameter("fecha");
    String id_vete = request.getParameter("id_vete");

    if (fecha == null || id_vete == null || id_vete.isEmpty()) {
        out.print("[]");
        return;
    }
    
    java.util.List<String> horasOcupadas = new java.util.ArrayList<>();

    if (fecha != null && id_vete != null && !id_vete.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/petify?useSSL=false&serverTimezone=UTC",
                "root","n0m3l0"
            );

            PreparedStatement ps = conn.prepareStatement(
                "SELECT hora FROM citas WHERE fecha=? AND id_vete=?"
            );
            ps.setString(1, fecha);
            ps.setInt(2, Integer.parseInt(id_vete));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String hora = rs.getString("hora");
                if (hora != null && hora.length() >= 5) {
                    horasOcupadas.add(hora.substring(0,5));
                }
            }

            rs.close();
            ps.close();
            conn.close();

        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    out.print(new Gson().toJson(horasOcupadas));
%>