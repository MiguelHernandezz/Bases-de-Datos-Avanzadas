--Tablas
CREATE DATABASE MUSICOS;

-- object: public.Musicos | type: TABLE --
-- DROP TABLE IF EXISTS public.Musicos CASCADE;
CREATE TABLE public.Musicos (
	codigo_musico integer NOT NULL,
	DNI char(10) NOT NULL,
	Nombre text NOT NULL,
	Direccion text NOT NULL,
	Codigo_Postal integer NOT NULL,
	Ciudad text NOT NULL,
	Provincia text NOT NULL,
	telefono integer NOT NULL,
	Instrumentos text NOT NULL,
	Codigo_grupo_Grupo integer NOT NULL,
	CONSTRAINT Musicos_pk PRIMARY KEY (codigo_musico),
	CONSTRAINT Unique_DNI UNIQUE (DNI)
);
-- ddl-end --
ALTER TABLE public.Musicos OWNER TO postgres;
-- ddl-end --

-- object: public.Grupo | type: TABLE --
-- DROP TABLE IF EXISTS public.Grupo CASCADE;
CREATE TABLE public.Grupo (
	Codigo_grupo integer NOT NULL,
	Nombre text NOT NULL,
	Genero_musical text NOT NULL,
	Pais text NOT NULL,
	Sitio_web text NOT NULL,
	CONSTRAINT Grupo_pk PRIMARY KEY (Codigo_grupo)
);
-- ddl-end --
ALTER TABLE public.Grupo OWNER TO postgres;
-- ddl-end --

-- object: public.Conciertos | type: TABLE --
-- DROP TABLE IF EXISTS public.Conciertos CASCADE;
CREATE TABLE public.Conciertos (
	Codigo_concierto integer NOT NULL,
	Fecha_realizacion date NOT NULL,
	Pais text NOT NULL,
	Ciudad text NOT NULL,
	Recinto text NOT NULL,
	CONSTRAINT Conciertos_pk PRIMARY KEY (Codigo_concierto)
);
-- ddl-end --
ALTER TABLE public.Conciertos OWNER TO postgres;
-- ddl-end --

-- object: public.Discos | type: TABLE --
-- DROP TABLE IF EXISTS public.Discos CASCADE;
CREATE TABLE public.Discos (
	Codigo_disco integer NOT NULL,
	Titulo text NOT NULL,
	Fecha_edicion date NOT NULL,
	Genero text NOT NULL,
	Formato text NOT NULL,
	Codigo_grupo_Grupo integer NOT NULL,
	CONSTRAINT Discos_pk PRIMARY KEY (Codigo_disco)
);
-- ddl-end --
ALTER TABLE public.Discos OWNER TO postgres;
-- ddl-end --

-- object: Grupo_fk | type: CONSTRAINT --
-- ALTER TABLE public.Discos DROP CONSTRAINT IF EXISTS Grupo_fk CASCADE;
ALTER TABLE public.Discos ADD CONSTRAINT Grupo_fk FOREIGN KEY (Codigo_grupo_Grupo)
REFERENCES public.Grupo (Codigo_grupo) MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

-- object: public.Canciones | type: TABLE --
-- DROP TABLE IF EXISTS public.Canciones CASCADE;
CREATE TABLE public.Canciones (
	Codigo_cancion integer NOT NULL,
	Nombre text NOT NULL,
	Compositor text NOT NULL,
	Fecha_grabacion date NOT NULL,
	Duracion time NOT NULL,
	Codigo_disco_Discos integer NOT NULL,
	CONSTRAINT Canciones_pk PRIMARY KEY (Codigo_cancion)
);
-- ddl-end --
ALTER TABLE public.Canciones OWNER TO postgres;
-- ddl-end --

-- object: Discos_fk | type: CONSTRAINT --
-- ALTER TABLE public.Canciones DROP CONSTRAINT IF EXISTS Discos_fk CASCADE;
ALTER TABLE public.Canciones ADD CONSTRAINT Discos_fk FOREIGN KEY (Codigo_disco_Discos)
REFERENCES public.Discos (Codigo_disco) MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

-- object: public.Entradas | type: TABLE --
-- DROP TABLE IF EXISTS public.Entradas CASCADE;
CREATE TABLE public.Entradas (
	Codigo_entrada integer NOT NULL,
	Localidad text NOT NULL,
	Precio money NOT NULL,
	Usuario text NOT NULL,
	Codigo_concierto_Conciertos integer NOT NULL,
	CONSTRAINT Entradas_pk PRIMARY KEY (Codigo_entrada)
);
-- ddl-end --
ALTER TABLE public.Entradas OWNER TO postgres;
-- ddl-end --

-- object: Conciertos_fk | type: CONSTRAINT --
-- ALTER TABLE public.Entradas DROP CONSTRAINT IF EXISTS Conciertos_fk CASCADE;
ALTER TABLE public.Entradas ADD CONSTRAINT Conciertos_fk FOREIGN KEY (Codigo_concierto_Conciertos)
REFERENCES public.Conciertos (Codigo_concierto) MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

-- object: Grupo_fk | type: CONSTRAINT --
-- ALTER TABLE public.Musicos DROP CONSTRAINT IF EXISTS Grupo_fk CASCADE;
ALTER TABLE public.Musicos ADD CONSTRAINT Grupo_fk FOREIGN KEY (Codigo_grupo_Grupo)
REFERENCES public.Grupo (Codigo_grupo) MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

-- object: public.Grupos_Tocan_Conciertos | type: TABLE --
-- DROP TABLE IF EXISTS public.Grupos_Tocan_Conciertos CASCADE;
CREATE TABLE public.Grupos_Tocan_Conciertos (
	Codigo_grupo_Grupo integer NOT NULL,
	Codigo_concierto_Conciertos integer NOT NULL,
	CONSTRAINT Grupos_Tocan_Conciertos_pk PRIMARY KEY (Codigo_grupo_Grupo,Codigo_concierto_Conciertos)
);
-- ddl-end --

-- object: Grupo_fk | type: CONSTRAINT --
-- ALTER TABLE public.Grupos_Tocan_Conciertos DROP CONSTRAINT IF EXISTS Grupo_fk CASCADE;
ALTER TABLE public.Grupos_Tocan_Conciertos ADD CONSTRAINT Grupo_fk FOREIGN KEY (Codigo_grupo_Grupo)
REFERENCES public.Grupo (Codigo_grupo) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: Conciertos_fk | type: CONSTRAINT --
-- ALTER TABLE public.Grupos_Tocan_Conciertos DROP CONSTRAINT IF EXISTS Conciertos_fk CASCADE;
ALTER TABLE public.Grupos_Tocan_Conciertos ADD CONSTRAINT Conciertos_fk FOREIGN KEY (Codigo_concierto_Conciertos)
REFERENCES public.Conciertos (Codigo_concierto) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --





-- cuestión 2, Inserción básica en una transacción

BEGIN;

-- Insertamos el grupo con todos sus campos obligatorios
INSERT INTO public.Grupo (Codigo_grupo, Nombre, Genero_musical, Pais, Sitio_web) 
VALUES (1, 'Estopa', 'Rumba Rock', 'España', 'www.estopa.com');

-- Insertamos el músico respetando los tipos de datos (el teléfono y CP son enteros)
INSERT INTO public.Musicos (codigo_musico, DNI, Nombre, Direccion, Codigo_Postal, Ciudad, Provincia, telefono, Instrumentos, Codigo_grupo_Grupo) 
VALUES (1, '11223344Z', 'David Muñoz', 'Calle Falsa 123', 08940, 'Cornellà', 'Barcelona', 933001122, 'Voz y Guitarra', 1);

COMMIT;



-- cuestión 5, Forzar salto de WAL tras el backup

SELECT pg_switch_wal();



-- cuestión 6, Consultar actividad de la base de datos

SELECT * FROM pg_stat_activity;
SELECT * FROM pg_locks;



-- cuestión 7, Creación de usuarios y permisos

CREATE USER musico1 WITH PASSWORD '1234';
CREATE USER musico2 WITH PASSWORD '1234';
CREATE USER musico3 WITH PASSWORD '1234';

GRANT CONNECT ON DATABASE musicos TO musico1, musico2, musico3;
GRANT USAGE ON SCHEMA public TO musico1, musico2, musico3;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO musico1, musico2, musico3;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO musico1, musico2, musico3;



-- cuestión 8, Transacción T1 ABIERTA (consola musico1)

BEGIN;
INSERT INTO public.Grupo (Codigo_grupo, Nombre, Genero_musical, Pais, Sitio_web) 
VALUES (1300, 'Piedras Negras', 'rock', 'España', 'www.piedrasnegras.es');

INSERT INTO public.Musicos (codigo_musico, DNI, Nombre, Direccion, Codigo_Postal, Ciudad, Provincia, telefono, Instrumentos, Codigo_grupo_Grupo) 
VALUES (1301, '123456789X', 'Músico Prueba', 'Calle Mayor 1', 39001, 'Santander', 'Cantabria', 942000000, 'Batería', 1300);

-- Comprobación: El musico1 si ve los datos
SELECT * FROM public.Grupo WHERE Codigo_grupo = 1300;

-- Comprobación de actividad
SELECT pid, usename, state, query FROM pg_stat_activity WHERE usename = 'musico1';



-- cuestión 9, Aislamiento (Consola musico2)

-- Comprobación: El musico2 no ve los datos (Devuelve 0 filas)
SELECT * FROM public.Grupo WHERE Codigo_grupo = 1300;



-- cuestión 11, Finalización de T1 y visibilidad

-- consola musico1
COMMIT;

-- consola musico2
-- Ahora que hay COMMIT, musico2 SÍ ve los datos
SELECT * FROM public.Grupo WHERE Codigo_grupo = 1300;



-- cuestión 12, Errores y Rollback automático

-- consola musico1
BEGIN;
INSERT INTO public.Grupo (Codigo_grupo, Nombre, Genero_musical, Pais, Sitio_web) 
VALUES (1400, 'Grupo Temporal', 'Pop', 'España', 'www.temporal.es');

INSERT INTO public.Musicos (codigo_musico, DNI, Nombre, Direccion, Codigo_Postal, Ciudad, Provincia, telefono, Instrumentos, Codigo_grupo_Grupo) 
VALUES (1401, '987654321A', 'Cantante Temp', 'Calle Alta 2', 28001, 'Madrid', 'Madrid', 910000000, 'Voz', 1400);

UPDATE public.Musicos SET telefono = 918856931 WHERE codigo_musico = 1401;

--  Violación de Primary Key (El 1300 ya existe)
UPDATE public.Grupo SET Codigo_grupo = 1300 WHERE Codigo_grupo = 1400;

-- Se ignora por estar en estado abortado
UPDATE public.Grupo SET Nombre = 'Héroes del Silencio' WHERE Codigo_grupo = 1300;

-- Se produce un ROLLBACK interno forzado
COMMIT; 



-- cuestión 13, Prueba de ROLLBACK manual

-- consola musico1
BEGIN;
INSERT INTO public.Grupo (Codigo_grupo, Nombre, Genero_musical, Pais, Sitio_web) 
VALUES (1500, 'Grupo Descartable', 'Jazz', 'España', 'www.jazz.es');

INSERT INTO public.Musicos (codigo_musico, DNI, Nombre, Direccion, Codigo_Postal, Ciudad, Provincia, telefono, Instrumentos, Codigo_grupo_Grupo) 
VALUES (1501, '555555555B', 'Saxofonista', 'Calle Baja 3', 41001, 'Sevilla', 'Sevilla', 954000000, 'Saxofón', 1500);

-- consola musico2 No ve los datos
SELECT * FROM public.Grupo WHERE Codigo_grupo = 1500;

-- consola musico1 Deshace los cambios
ROLLBACK;

-- Ninguno de los dos ve los datos
SELECT * FROM public.Grupo WHERE Codigo_grupo = 1500;



-- cuestión 14, Preparación tablas de concurrencia

CREATE TABLE ValorA (A real PRIMARY KEY);
CREATE TABLE ValorB (B real PRIMARY KEY);
CREATE TABLE ValorC (C real PRIMARY KEY);

INSERT INTO ValorA (A) VALUES (40);
INSERT INTO ValorB (B) VALUES (50);
INSERT INTO ValorC (C) VALUES (60);




-- cuestión 15, Planificación Concurrente y Deadlock


-- consola musico1 - Terminal 1
BEGIN;
SELECT C FROM ValorC;
UPDATE ValorC SET C = 0.6;
-- (Espera turnos de M2 y M3...)
SELECT A FROM ValorA;
UPDATE ValorA SET A = 140; 
-- BLOQUEO: M1 queda esperando a que M3 libere ValorA
-- (M1 se desbloquea tras el Deadlock de M2 y el COMMIT de M3)
UPDATE ValorC SET C = -39.4;
COMMIT;


-- consola musico2 - Terminal 2
BEGIN;
SELECT B FROM ValorB;
UPDATE ValorB SET B = 250;

SELECT C FROM ValorC;
UPDATE ValorC SET C = 190; 
-- error, Se detecta el DEADLOCK en este punto. El sistema aborta a M2.
ROLLBACK;


-- [consola musico3 - Terminal 3]
BEGIN;
SELECT A FROM ValorA;
SELECT B FROM ValorB;
UPDATE ValorA SET A = 750;
-- (Espera turnos...)
SELECT C FROM ValorC;
UPDATE ValorB SET B = 45000; 
-- BLOQUEO: M3 queda esperando a que M2 libere ValorB
-- (M3 se desbloquea automáticamente cuando el Deadlock mata a M2)
COMMIT;



-- cuestión 16, Comprobación valores finales

SELECT A FROM ValorA;
SELECT B FROM ValorB;
SELECT C FROM ValorC;
-- Resultado real final: A=140, B=45000, C=-39.4




-- cuestion 17, Recuperación PITR ante pérdida del clúster


/* La recuperación PITR no se realiza con sentencias SQL, 
sino a nivel de sistema operativo. A continuación se detallan los comandos 
de PowerShell (ejecutados como Administrador) y las modificaciones de ficheros 
utilizados para tirar el servidor y realizar la recuperación:

--INICIO COMANDOS POWERSHELL

1. Detención del servidor de forma segura:
> & "C:\PostgreSQL17\bin\pg_ctl.exe" -D "C:\PostgreSQL17\data" stop

2. Simulación de la pérdida del clúster (renombramos la carpeta de datos original):
> Rename-Item -Path "C:\PostgreSQL17\data" -NewName "data_rota"

3. Restauración de la copia base (creada en la Cuestión 5):
> Copy-Item -Path "C:\pg_practica\backup" -Destination "C:\PostgreSQL17\data" -Recurse

4. Limpieza de WALs residuales de la copia y creación de señal de recuperación:
> Remove-Item -Path "C:\PostgreSQL17\data\pg_wal\*" -Recurse -Force
> New-Item -Path "C:\PostgreSQL17\data\recovery.signal" -ItemType File

5. Configuración del archivo postgresql.conf:
   Abrimos C:\PostgreSQL17\data\postgresql.conf y aseguramos que existe la línea:
   restore_command = 'copy "C:\\pg_practica\\wal_archive\\%f" "%p"'

6. Reinicio del servidor (Inicia la recuperación automática leyendo el WAL):
> & "C:\PostgreSQL17\bin\pg_ctl.exe" -D "C:\PostgreSQL17\data" start

--FIN COMANDOS POWERSHELL
*/


-- comprobacion de datos restaurados


-- 1. Comprobamos que las inserciones previas a la concurrencia siguen ahí:
SELECT * FROM public.Grupo WHERE Codigo_grupo = 1300;
SELECT * FROM public.Musicos WHERE Codigo_grupo_Grupo = 1300;

-- 2. Comprobamos que la base de datos aplicó los WAL correctamente,
-- reproduciendo el estado exacto tras el interbloqueo (deadlock) de la Cuestión 15:
SELECT A FROM ValorA; 
-- El resultado es A = 140

SELECT B FROM ValorB; 
-- El resultado es B = 45000

SELECT C FROM ValorC; 
-- El resultado es C = -39.4