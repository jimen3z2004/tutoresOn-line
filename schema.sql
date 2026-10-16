-- TutoresOn-Line · MySQL 8
CREATE DATABASE IF NOT EXISTS tutoreson CHARACTER SET utf8mb4;
USE tutoreson;

CREATE TABLE niveles (
  id_nivel INT PRIMARY KEY AUTO_INCREMENT,
  numero INT NOT NULL UNIQUE,
  puntos_requeridos INT NOT NULL
);
CREATE TABLE usuarios (
  id_usuario INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(150) NOT NULL UNIQUE,
  contrasena_hash VARCHAR(255) NOT NULL,
  rol ENUM('estudiante','tutor') NOT NULL DEFAULT 'estudiante',
  avatar_url VARCHAR(255),
  puntos INT NOT NULL DEFAULT 0,
  id_nivel INT NOT NULL DEFAULT 1,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_nivel) REFERENCES niveles(id_nivel)
);
CREATE TABLE materias (
  id_materia INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL UNIQUE
);
CREATE TABLE tutorias (            -- oferta publicada por un tutor
  id_tutoria INT PRIMARY KEY AUTO_INCREMENT,
  id_tutor INT NOT NULL,
  id_materia INT NOT NULL,
  titulo VARCHAR(120) NOT NULL,
  descripcion TEXT,
  precio_hora DECIMAL(10,2) NOT NULL,
  imagen_url VARCHAR(255),
  FOREIGN KEY (id_tutor) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_materia) REFERENCES materias(id_materia)
);
CREATE TABLE carrito_items (
  id_usuario INT NOT NULL,
  id_tutoria INT NOT NULL,
  horas INT NOT NULL DEFAULT 1,
  PRIMARY KEY (id_usuario, id_tutoria),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_tutoria) REFERENCES tutorias(id_tutoria)
);
CREATE TABLE metodos_pago (
  id_metodo INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  tipo ENUM('visa','mastercard','pse','otro') NOT NULL,
  ultimos4 CHAR(4),
  vence VARCHAR(7),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);
CREATE TABLE pedidos (
  id_pedido INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_metodo INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  estado ENUM('pendiente','pagado','cancelado') DEFAULT 'pendiente',
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_metodo) REFERENCES metodos_pago(id_metodo)
);
CREATE TABLE pedido_items (
  id_pedido INT NOT NULL,
  id_tutoria INT NOT NULL,
  horas INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_pedido, id_tutoria),
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
  FOREIGN KEY (id_tutoria) REFERENCES tutorias(id_tutoria)
);
CREATE TABLE sesiones (            -- "Mis tutorías" (biblioteca del estudiante)
  id_sesion INT PRIMARY KEY AUTO_INCREMENT,
  id_pedido INT NOT NULL,
  id_tutoria INT NOT NULL,
  id_estudiante INT NOT NULL,
  fecha_hora DATETIME,
  estado ENUM('agendada','realizada','cancelada') DEFAULT 'agendada',
  FOREIGN KEY (id_pedido, id_tutoria) REFERENCES pedido_items(id_pedido, id_tutoria),
  FOREIGN KEY (id_estudiante) REFERENCES usuarios(id_usuario)
);
CREATE TABLE resenas (
  id_resena INT PRIMARY KEY AUTO_INCREMENT,
  id_tutoria INT NOT NULL,
  id_usuario INT NOT NULL,
  calificacion DECIMAL(2,1) NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
  comentario TEXT,
  FOREIGN KEY (id_tutoria) REFERENCES tutorias(id_tutoria),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);
CREATE TABLE mensajes_comunidad (  -- Comunidad: mensajes y respuestas
  id_mensaje INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_padre INT NULL,
  contenido TEXT NOT NULL,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_padre) REFERENCES mensajes_comunidad(id_mensaje)
);
CREATE TABLE reacciones (
  id_mensaje INT NOT NULL,
  id_usuario INT NOT NULL,
  tipo ENUM('me_gusta','no_me_gusta') NOT NULL,
  PRIMARY KEY (id_mensaje, id_usuario),
  FOREIGN KEY (id_mensaje) REFERENCES mensajes_comunidad(id_mensaje),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

INSERT INTO niveles(numero,puntos_requeridos) VALUES (1,0),(11,1000),(12,1500);
INSERT INTO materias(nombre) VALUES ('Matemáticas'),('Historia'),('Inglés'),('Física'),('Tecnología'),('Filosofía');
