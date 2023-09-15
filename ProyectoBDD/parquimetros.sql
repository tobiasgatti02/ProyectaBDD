CREATE DATABASE parquimetros;

# selecciono la base de datos sobre la cual voy a hacer modificaciones
USE parquimetros;


CREATE TABLE Conductores (
 dni INT UNSIGNED NOT NULL,
 nombre VARCHAR(45) NOT NULL,
 apellido VARCHAR(45) NOT NULL,
 direccion VARCHAR(45) NOT NULL,
 telefono VARCHAR(45) NOT NULL,
 registro INT UNSIGNED NOT NULL,
 CONSTRAINT pk_conductores PRIMARY KEY (dni)
) ENGINE=InnoDB;


CREATE TABLE Automoviles (
 patente CHAR(6),
 marca VARCHAR(45),
 modelo VARCHAR(45),
 color VARCHAR(45),
 dni INT UNSIGNED, 
 CONSTRAINT FK_Automoviles_Conductores FOREIGN KEY (dni) REFERENCES Conductores(dni),
 CONSTRAINT pk_automoviles PRIMARY KEY (patente)
) ENGINE=InnoDB;

CREATE TABLE Tipo_tarjeta (
 tipo VARCHAR(45) ,
 descuento DECIMAL(3,2) CHECK (Descuento >= 0 AND Descuento <= 1), 
 
 CONSTRAINT pk_tipo_tarjeta
 PRIMARY KEY (tipo)

) ENGINE=InnoDB;


CREATE TABLE Tarjetas(
 id_tarjeta INT UNSIGNED NOT NULL ,
 saldo DECIMAL(5,2) NOT NULL, 
 tipo VARCHAR(25), /*PREGUNTAR. enumerado o algo que marque especificamente los tipos??*/
 
 CONSTRAINT FK_Tarjetas_Automoviles
 FOREIGN KEY (patente) REFERENCES Automoviles(patente),
 
 CONSTRAINT pk_tarjetas
 PRIMARY KEY (id_tarjeta)

) ENGINE=InnoDB;


CREATE TABLE Recargas (
 fecha  DATE NOT NULL,
 hora TIME NOT NULL,
 saldo_anterior DECIMAL(5,2) NOT NULL, 
 saldo_anterior DECIMAL(5,2) NOT NULL, 
 
 CONSTRAINT FK_Recargas_Tarjetas
 FOREIGN KEY (id_tarjeta) REFERENCES Tarjetas(id_tarjeta)
 CONSTRAINT pk_recargas
 PRIMARY KEY (id_tarjeta)
 KEY(fecha)
 KEY(hora) /*preguntar si esta bien key solo separado por comas.*/ 
 
 /*otra opcion:
    CONSTRAINT k_Recargas
    KEY (fecha)
    KEY(hora),
 */

) ENGINE=InnoDB;


CREATE TABLE Inspectores (
 legajo INT UNSIGNED NOT NULL ,
 dni INT UNSIGNED NOT NULL ,
 nombre VARCHAR(45) NOT NULL, 
 apellido  VARCHAR(45) NOT NULL,
 passwrd  CHAR(32) NOT NULL, 
 
 CONSTRAINT pk_Inspectores
 PRIMARY KEY (legajo)

) ENGINE=InnoDB;


CREATE TABLE Ubicaciones (
 calle VARCHAR(45),
 altura INT UNSIGNED NOT NULL,
 tarifa DECIMAL(5,2) CHECK (tarifa >= 0)
 
 CONSTRAINT pk_Ubicaciones
 KEY (calle) /*PREGUNTAR*/
 KEY (altura)
) ENGINE=InnoDB;


CREATE TABLE Parquimetros (
 id_parq INT UNSIGNED NOT NULL ,
 numero VARCHAR(45) NOT NULL, 
 
 CONSTRAINT FK_Parquimetros_Ubicaciones
 FOREIGN KEY (altura) REFERENCES Ubicaciones(altura) /*va separado por comas o van dos constraint separados?*/
 FOREIGN KEY (calle) REFERENCES Ubicaciones(calle)
 CONSTRAINT pk_Parquimetros
 PRIMARY KEY (id_parq)

) ENGINE=InnoDB;




CREATE TABLE Estacionamientos (
 fecha_ent DATE NOT NULL, 
 hora_ent TIME NOT NULL,
 fecha_sal DATE NOT NULL, 
 hora_sal TIME NOT NULL
 
 CONSTRAINT FK_Estacionamientos_Tarjetas
 FOREIGN KEY (id_tarjeta) REFERENCES Tarjetas(id_tarjetas)

 CONSTRAINT FK_Estacionamientos_Parquimetros
 FOREIGN KEY (id_parq) REFERENCES Parquimetros(id_parq)

 CONSTRAINT pk_Estacionamientos
 PRIMARY KEY (id_parq)
 KEY(fecha_ent) /*preguntar si esta bien key solo separado por comas.*/
 KEY(hora_ent)

) ENGINE=InnoDB;


CREATE TABLE Accede (
 fecha DATE NOT NULL, 
 hora TIME NOT NULL,
 
 CONSTRAINT FK_Accede_Parquimetros
 FOREIGN KEY (id_parq) REFERENCES Parquimetros(id_parq)

 CONSTRAINT FK_Accede_Inspectores
 FOREIGN KEY (legajo) REFERENCES Inspectores(legajo)
 CONSTRAINT pk_Accede /* o CONSTRAINT K?? */
 KEY(fecha)
 KEY(hora)


) ENGINE=InnoDB;

CREATE TABLE Asociado_con (
 id_asociado_con INT UNSIGNED NOT NULL,
 dia CHAR(2), /*enum??*/
 turno CHAR(1),

 CONSTRAINT FK_Asociado_con_Inspectores
 FOREIGN KEY (legajo) REFERENCES Inspectores(legajo)
 CONSTRAINT FK_Asociado_con_Ubicaciones
 FOREIGN KEY (calle) REFERENCES Ubicaciones(calle)
 FOREIGN KEY (altura) REFERENCES Ubicaciones(altura) /* o dos fk distintas*/
 CONSTRAINT pk_Asociado_con
 PRIMARY KEY (id_asociado_con)

) ENGINE=InnoDB;

CREATE TABLE Multa (
 numero INT UNSIGNED NOT NULL,
 fecha DATE NOT NULL, 
 hora TIME NOT NULL,

 CONSTRAINT FK_Multa_Asociado_con
 FOREIGN KEY (id_asociado_con) REFERENCES Asociado_con(id_asociado_con)
 CONSTRAINT FK_Multa_Automoviles
 FOREIGN KEY (patente) REFERENCES Automoviles(patente)
 CONSTRAINT pk_Multa
 PRIMARY KEY (numero)

) ENGINE=InnoDB;