// ============================
// Variables globales
// ============================
let monthYear, calendarBody, selectedDateSpan, selectedTimeSpan, timeButtonsContainer;
let ID_TUTOR, ID_VETE, ID_MASCOTA;

let currentDate;
let selectedDate = null;
let selectedTime = null;

const hours = [
    "09:00", "10:00", "11:00",
    "12:00", "13:00", "16:00",
    "17:00", "18:00"
];

// ============================
// Inicialización del calendario
// ============================
function initCalendar() {
    monthYear = document.getElementById("monthYear");
    calendarBody = document.getElementById("calendar-body");
    selectedDateSpan = document.getElementById("selected-date");
    selectedTimeSpan = document.getElementById("selected-time");
    timeButtonsContainer = document.getElementById("time-buttons");

    // Veterinario fijo
    ID_VETE = parseInt(document.getElementById("ID_VETE").value);

    currentDate = new Date();

    document.getElementById("prevMonth").onclick = () => {
        currentDate.setMonth(currentDate.getMonth() - 1);
        loadCalendar();
    };

    document.getElementById("nextMonth").onclick = () => {
        currentDate.setMonth(currentDate.getMonth() + 1);
        loadCalendar();
    };

    document.getElementById("confirm-btn").onclick = confirmCita;

    loadCalendar();
}

// ============================
// Cargar calendario
// ============================
function loadCalendar() {
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();

    const firstDay = new Date(year, month, 1).getDay();
    const lastDate = new Date(year, month + 1, 0).getDate();

    monthYear.textContent = currentDate.toLocaleString("es-MX", {
        month: "long",
        year: "numeric"
    });

    calendarBody.innerHTML = "";

    let date = 1;

    for (let row = 0; row < 6; row++) {
        let tr = document.createElement("tr");

        for (let col = 0; col < 7; col++) {
            let td = document.createElement("td");

            if (row === 0 && col < firstDay) {
                td.classList.add("disabled");
            } else if (date > lastDate) {
                td.classList.add("disabled");
            } else {
                let realDay = date;
                td.textContent = realDay;
                td.classList.add("enabled");

                td.onclick = () => {
                    document
                        .querySelectorAll("#calendar-body td.enabled")
                        .forEach(celda => celda.classList.remove("selected"));

                    td.classList.add("selected");

                    selectedDate = `${year}-${String(month + 1).padStart(2,"0")}-${String(realDay).padStart(2,"0")}`;
                    selectedDateSpan.textContent = selectedDate;

                    selectedTime = null;
                    selectedTimeSpan.textContent = "--";

                    loadHours();
                };

                date++;
            }

            tr.appendChild(td);
        }

        calendarBody.appendChild(tr);
    }
}

// ============================
// Cargar horarios disponibles
// ============================
function loadHours() {
    timeButtonsContainer.innerHTML = "";

    fetch(`getHoras.jsp?fecha=${selectedDate}&id_vete=${ID_VETE}`)
        .then(r => r.json())
        .then(horasOcupadas => {
            hours.forEach((hour) => {
                let btn = document.createElement("button");
                btn.classList.add("btn", "btn-outline-primary", "m-1");
                btn.textContent = hour;

                if (horasOcupadas.includes(hour)) {
                    btn.classList.add("ocupado");
                    btn.disabled = true;
                }

                btn.onclick = () => {
                    selectedTime = hour;
                    selectedTimeSpan.textContent = selectedTime;
                    document.querySelectorAll("#time-buttons button")
                            .forEach(b => b.classList.remove("selected-hour"));
                    btn.classList.add("selected-hour");
                };

                timeButtonsContainer.appendChild(btn);
            });
        })
        .catch(err => {
            console.error("Error obteniendo horas:", err);
        });
}

// ============================
// Confirmar cita
// ============================
function confirmCita() {
    if (!selectedDate || !selectedTime) {
        alert("Selecciona una fecha y una hora antes de confirmar.");
        return;
    }

    ID_TUTOR = parseInt(document.getElementById("ID_TUTOR").value);
    ID_MASCOTA = parseInt(document.getElementById("ID_MASCOTA").value);

    if (isNaN(ID_TUTOR) || isNaN(ID_MASCOTA)) {
        alert("Debes seleccionar un tutor y una mascota.");
        return;
    }

    const data = new URLSearchParams();
    data.append("fecha", selectedDate);
    data.append("hora", selectedTime);
    data.append("id_tutor", ID_TUTOR);
    data.append("id_vete", ID_VETE);
    data.append("id_mascota", ID_MASCOTA);

    fetch("guardarCita.jsp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: data.toString()
    })
    .then(r => r.text())
    .then(respuesta => {
        if (respuesta.includes("OK")) {
            alert("Cita registrada correctamente");
        } else if (respuesta.includes("DUPLICADO")) {
            alert("Esta hora ya está ocupada para este veterinario.");
        } else if (respuesta.includes("SQL_ERROR")) {
            alert("Error SQL: " + respuesta);
        } else {
            alert("Respuesta inesperada: " + respuesta);
        }
    })
    .catch(err => {
        console.error(err);
        alert("Error al guardar la cita.");
    });
}

// ============================
// Ejecutar cuando el script cargue
// ============================
document.addEventListener("DOMContentLoaded", initCalendar);