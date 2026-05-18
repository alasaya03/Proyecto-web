<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="es.css">
    </head>
    <body>
        <div class="calendar">
            <div class="month">
                <button id="prevMonth">&#171;</button>
                <div id="monthYear"></div>
                <button id="nextMonth">&#187;</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Domingo</th><th>Lunes</th><th>Martes</th><th>Miercoles</th>
                        <th>Jueves</th><th>Viernes</th><th>Sabado</th>
                    </tr>
                </thead>
                <tbody id="calendar-body"></tbody>
            </table>

            <div class="time-selection">
                <h3>Selecciona hora</h3>
                <div id="time-buttons"></div>
            </div>

            <div class="summary">
                Fecha: <span id="selected-date">--</span><br>
                Hora: <span id="selected-time">--</span>
            </div>

            <button id="confirm-btn">Confirmar cita</button>
        </div>

        <script src="Calendario.js"></script>
    </body>
</html> 