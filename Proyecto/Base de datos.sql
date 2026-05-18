CREATE DATABASE IF NOT EXISTS petify;
USE petify;

CREATE TABLE IF NOT EXISTS veterinario ( 
    id_vete INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nom_vete VARCHAR(50) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(50) NOT NULL,
    contraseña VARCHAR(255) NOT NULL 
);

CREATE TABLE IF NOT EXISTS tutor (
    id_tutor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nom_tutor VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(50),
    contraseña VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS mascota (
    id_mascota INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    edad VARCHAR(50) NOT NULL,
    sexo VARCHAR(50) NOT NULL,
    raza VARCHAR(50) NOT NULL,
    peso DECIMAL(5, 2) NOT NULL, 
    id_vete INT NOT NULL,
    id_tutor INT NOT NULL,
    FOREIGN KEY (id_vete) REFERENCES veterinario(id_vete),
    FOREIGN KEY (id_tutor) REFERENCES tutor(id_tutor)
);

CREATE TABLE IF NOT EXISTS citas (
    id_citas INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    id_mascota INT NOT NULL,
    id_vete INT NOT NULL,
    id_tutor INT NOT NULL,
    FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota),
    FOREIGN KEY (id_vete) REFERENCES veterinario(id_vete),
    FOREIGN KEY (id_tutor) REFERENCES tutor(id_tutor),

    UNIQUE (fecha, hora, id_vete)  -- evita citas duplicadas para un veterinario
);