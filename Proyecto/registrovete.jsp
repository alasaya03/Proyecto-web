<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.security.MessageDigest" %>

<%! 
    public String hashPassword(String pass) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashed = md.digest(pass.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashed) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            return pass;
        }
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    String nombre = request.getParameter("nombre");
    String email = request.getParameter("email");
    String contra = request.getParameter("contra");
    String telf = request.getParameter("telf");
    String espec = request.getParameter("espec");

    if (nombre == null || email == null || contra == null || telf == null || espec == null) {
        response.sendRedirect("registrovete.html?error=invalid_params");
        return;
    }

    String passHash = hashPassword(contra);

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/petify?useSSL=false&allowPublicKeyRetrieval=true",
            "root", "n0m3l0"
        );

        // 🔍 PRIMERO: VERIFICAR SI EL CORREO YA EXISTE
        String checkSql = "SELECT id_vete FROM veterinario WHERE correo = ?";
        PreparedStatement check = con.prepareStatement(checkSql);
        check.setString(1, email);
        ResultSet rs = check.executeQuery();

        if (rs.next()) {
            // Ya existe un veterinario registrado con ese correo
            response.sendRedirect("registrovete.html?error=email_exists");
            rs.close();
            check.close();
            con.close();
            return;
        }
        rs.close();
        check.close();

        // 🟢 SI NO EXISTE, INSERTAR
        String sql = "INSERT INTO veterinario (nom_vete, especialidad, telefono, correo, contraseña) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement st = con.prepareStatement(sql);

        st.setString(1, nombre);
        st.setString(2, espec);
        st.setString(3, telf);
        st.setString(4, email);
        st.setString(5, passHash);

        int filas = st.executeUpdate();

        st.close();
        con.close();

        if (filas > 0) {
            response.sendRedirect("iniciosesion.html?success=registered");
        } else {
            response.sendRedirect("registrovete.html?error=unknown");
        }

    } catch (Exception e) {
        response.sendRedirect("registrovete.html?error=server");
    }
%>