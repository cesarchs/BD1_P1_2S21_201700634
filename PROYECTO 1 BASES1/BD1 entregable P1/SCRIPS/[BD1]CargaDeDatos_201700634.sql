/*
    ACA VAMOS A HACER LA CARGA DE DATOS DESDE LA TEMPORAR HASTA LAS TABLAS DE LA BASE DE DATOS
*/
alter session set nls_date_format = 'dd/MON/yyyy hh24:mi:ss'

INSERT INTO PAIS (pais)
    SELECT DISTINCT temporal.pais_cliente
        FROM TEMPORAL
           WHERE  temporal.pais_cliente != '-'
                AND temporal.pais_cliente IS NOT NULL
             GROUP BY temporal.pais_cliente;


INSERT INTO PAIS (pais)
    SELECT DISTINCT temporal.pais_empleado
        FROM TEMPORAL
            WHERE temporal.pais_empleado NOT IN (
                    SELECT pais
                    FROM PAIS
            )
            AND temporal.pais_empleado != '-';
             --GROUP BY temporal.pais_empleado;

INSERT INTO PAIS (pais)
    SELECT DISTINCT temporal.pais_tienda
        FROM TEMPORAL
            WHERE temporal.pais_tienda NOT IN (
                    SELECT pais
                    FROM PAIS
            )
            AND temporal.pais_tienda !='-';
             --GROUP BY temporal.pais_tienda;
 
 
 
 ----INSERT CIUDAD
 
 
  INSERT INTO CIUDAD (ciudad, fk_id_pais)
    SELECT DISTINCT Ciudad_cliente, pais.id_pais
        FROM TEMPORAL
            INNER JOIN PAIS ON PAIS.pais = pais_cliente
                WHERE temporal.pais_cliente IS NOT NULL 
                    AND temporal.pais_cliente != '-';
 
 
 INSERT INTO CIUDAD (ciudad, fk_id_pais)
    SELECT DISTINCT ciudad_empleado, pais.id_pais
        FROM TEMPORAL
            INNER JOIN PAIS ON PAIS.pais = temporal.pais_empleado
                WHERE temporal.ciudad_empleado NOT IN (
                    SELECT CIUDAD
                    FROM CIUDAD
                )
                    AND temporal.ciudad_empleado IS NOT NULL 
                    AND temporal.ciudad_empleado != '-';
 
 
 INSERT INTO CIUDAD (ciudad, fk_id_pais)
    SELECT DISTINCT temporal.ciudad_tienda, pais.id_pais
        FROM TEMPORAL
            INNER JOIN PAIS ON PAIS.pais = temporal.ciudad_tienda
                WHERE temporal.ciudad_tienda NOT IN (
                    SELECT CIUDAD
                    FROM CIUDAD
                )
                    AND temporal.ciudad_tienda IS NOT NULL 
                    AND temporal.ciudad_tienda != '-';

 
 ------INSERT LENGUAJE
 
 INSERT INTO LENGUAJE (lenguaje_pelicula)
    SELECT DISTINCT temporal.lenguaje_pelicula
        FROM TEMPORAL
            WHERE temporal.lenguaje_pelicula !='-'
                AND temporal.lenguaje_pelicula IS NOT NULL;
    
 
 ----INSERT CATEGORIA
 
  INSERT INTO CATEGORIA (categoria_pelicula)
    SELECT DISTINCT temporal.categoria_pelicula
        FROM TEMPORAL
            WHERE temporal.categoria_pelicula !='-'
                AND temporal.categoria_pelicula IS NOT NULL;
 
 
 --- INSERT CLASIFICACION 
 
   INSERT INTO CLASIFICACION (clasificacion)
    SELECT DISTINCT temporal.clasificacion
        FROM TEMPORAL
            WHERE temporal.clasificacion !='-'
                AND temporal.clasificacion IS NOT NULL;
 
 
 
 ---- INSERT ACTOR
 
    INSERT INTO ACTOR (nombre_actor, apellido_actor )
    SELECT DISTINCT SUBSTR(temporal.ACTOR_PELICULA, 1, INSTR(temporal.ACTOR_PELICULA, ' ')-1) AS col_one,
       SUBSTR(temporal.ACTOR_PELICULA, INSTR(temporal.ACTOR_PELICULA, ' ')+1) AS col_two
        FROM temporal
            WHERE temporal.ACTOR_PELICULA !='-'
                AND temporal.ACTOR_PELICULA IS NOT NULL;
    
 

 --- INSERT CLIENTE 
 
  INSERT INTO CLIENTE (nombre_cliente, apellido_cliente,correo_cliente, cliente_activo, fecha_creacion, tienda_preferida, direccion_cliente,codigo_postal_cliente, fk_id_ciudad)
    SELECT DISTINCT SUBSTR(temporal.NOMBRE_CLIENTE, 1, INSTR(temporal.NOMBRE_CLIENTE, ' ')-1) AS col_one,
       SUBSTR(temporal.NOMBRE_CLIENTE, INSTR(temporal.NOMBRE_CLIENTE, ' ')+1) AS col_two,
       temporal.correo_cliente,
       temporal.cliente_activo,
       TO_DATE(temporal.fecha_creacion, 'DD/MM/YY'),
       temporal.tienda_preferida,
       temporal.direccion_cliente, 
       temporal.codigo_postal_cliente, 
       ciudad.id_ciudad
        FROM TEMPORAL
             INNER JOIN CIUDAD ON ciudad.ciudad= temporal.ciudad_cliente
                AND temporal.ciudad_cliente != '-'
            WHERE temporal.NOMBRE_CLIENTE !='-'
                AND temporal.NOMBRE_CLIENTE IS NOT NULL
                ;
 
 ----- INSERT TIENDA
 
 
   INSERT INTO TIENDA (nombre_tienda, encargado_tienda,direccion_tienda,codigo_postal_tienda,fk_id_ciudad)
    SELECT DISTINCT temporal.nombre_tienda,temporal.encargado_tienda, temporal.direccion_tienda, temporal.codigo_postal_tienda,ciudad.id_ciudad
        FROM TEMPORAL
            INNER JOIN CIUDAD ON ciudad.ciudad = temporal.ciudad_tienda
                WHERE temporal.nombre_tienda IS NOT NULL 
                    AND temporal.nombre_tienda != '-'
                    AND temporal.encargado_tienda!= '-'
                    AND temporal.encargado_tienda IS NOT NULL 
                    ;
 
 
 
 --- INSERT EMPLEADO

 
   INSERT INTO EMPLEADO (nombre_empleado, apellido_empleado, correo_empleado, empleado_activo, tienda_empleado, usuario_empleado, contrasena_empleado, direccion_empleado, codigo_postal_empleado, fk_id_tienda, fk_id_ciudad)
    SELECT DISTINCT SUBSTR(temporal.nombre_empleado, 1, INSTR(temporal.nombre_empleado, ' ')-1) AS col_one,
       SUBSTR(temporal.nombre_empleado, INSTR(temporal.nombre_empleado, ' ')+1) AS col_two,
       temporal.correo_empleado, 
       temporal.empleado_activo, 
       temporal.tienda_empleado, 
       temporal.usuario_empleado, 
       temporal.contrasena_empleado,
       temporal.direccion_empleado,
       temporal.codigo_postal_empleado,
       tienda.id_tienda, 
       ciudad.id_ciudad
        FROM TEMPORAL
             INNER JOIN TIENDA ON tienda.nombre_tienda= temporal.nombre_tienda
                AND temporal.nombre_tienda != '-'
                AND temporal.encargado_tienda != '-'
             INNER JOIN CIUDAD ON ciudad.ciudad= temporal.ciudad_empleado
                AND temporal.ciudad_empleado != '-'
            WHERE temporal.NOMBRE_CLIENTE !='-'
                AND temporal.NOMBRE_CLIENTE IS NOT NULL
                ;
 
 
 
 --- INSERT PELICULA
 
 
    INSERT INTO PELICULA ( nombre_pelicula, descripcion_pelicula, anio_lazamiento, dias_renta, costo_renta, duracion, costo_por_danio, fk_id_clasificacion)
    SELECT DISTINCT 
                    temporal.nombre_pelicula, 
                    temporal.descripcion_pelicula, 
                    TO_NUMBER(temporal.ANO_LANZAMIENTO), 
                    TO_NUMBER(temporal.dias_renta),
                    TO_NUMBER(temporal.costo_renta),
                    TO_NUMBER(temporal.duracion),
                    TO_NUMBER(temporal.costo_por_dano),
                    clasificacion.id_clasificacion
        FROM TEMPORAL
             INNER JOIN CLASIFICACION ON clasificacion.clasificacion= temporal.clasificacion
            WHERE temporal.nombre_pelicula !='-'
                AND temporal.nombre_pelicula IS NOT NULL
                ;
 

---- INSERT ALQUILER 


  INSERT INTO ALQUILER (fecha_renta, fecha_retorno, monto_a_pagar, fecha_pago, comision, fk_id_cliente, fk_id_empleado, fk_id_pelicula)
    SELECT DISTINCT  
                    TO_DATE(temporal.fecha_renta,'DD-MM-YY HH24:MI:SS') AS fecha_renta, 
                    TO_DATE(temporal.fecha_retorno,'DD-MM-YY HH24:MI:SS') AS fecha_retorno,
                    TO_NUMBER(temporal.monto_a_pagar) AS  monto_a_pagar, 
                    TO_DATE(temporal.fecha_pago,'DD-MM-YY HH24:MI:SS') AS fecha_pago,
                    TO_NUMBER(temporal.monto_a_pagar) AS comision,
                    cliente.id_cliente,
                    empleado.id_empleado,
                    pelicula.id_pelicula
        FROM TEMPORAL
             INNER JOIN CLIENTE ON CONCAT( CONCAT (CLIENTE.nombre_cliente, ' '), cliente.apellido_cliente)  = temporal.NOMBRE_CLIENTE
             INNER JOIN EMPLEADO ON CONCAT( CONCAT (empleado.nombre_empleado, ' '), EMPLEADO.apellido_empleado)= temporal.nombre_empleado
             INNER JOIN PELICULA ON pelicula.nombre_pelicula = temporal.nombre_pelicula
            WHERE temporal.fecha_renta !='-'
                AND temporal.fecha_renta IS NOT NULL
                AND temporal.nombre_cliente != '-'
                AND temporal.nombre_cliente IS NOT NULL
                AND temporal.nombre_empleado != '-'
                AND temporal.nombre_empleado IS NOT NULL
               -- AND temporal.fecha_retorno !='-'
               --AND temporal.fecha_retorno IS NOT NULL
                AND temporal.fecha_pago !='-'
                AND temporal.fecha_pago IS NOT NULL
                AND temporal.nombre_pelicula !='-'
                AND temporal.nombre_pelicula IS NOT NULL
                ;
 

------- INSERT TIENDA_PELICULA


    INSERT INTO TIENDA_PELICULA (tienda_pelicula, fk_id_tienda, fk_id_pelicula)
    SELECT DISTINCT temporal.tienda_pelicula,
                    tienda.id_tienda, 
                    pelicula.id_pelicula
        FROM TEMPORAL
             INNER JOIN TIENDA ON tienda.nombre_tienda = temporal.nombre_tienda
                                AND tienda.nombre_tienda = temporal.tienda_pelicula
             INNER JOIN PELICULA ON pelicula.nombre_pelicula = temporal.nombre_pelicula
                WHERE temporal.tienda_pelicula !='-'
                    AND temporal.tienda_pelicula IS NOT NULL
                    AND temporal.tienda_pelicula = tienda.nombre_tienda
                    AND temporal.tienda_pelicula != '-'
                    AND temporal.tienda_pelicula IS NOT NULL
                ;

/*
-- PARA CUANDO GUARDAR TODAS LAS PUPLAS COMO UNA COPIA DE INVENTARIO 

    INSERT INTO TIENDA_PELICULA (tienda_pelicula, fk_id_tienda, fk_id_pelicula)
    SELECT  temporal.tienda_pelicula,
                    tienda.id_tienda, 
                    pelicula.id_pelicula
        FROM TEMPORAL
             INNER JOIN TIENDA ON tienda.nombre_tienda = temporal.nombre_tienda
                                AND tienda.nombre_tienda = temporal.tienda_pelicula
             INNER JOIN PELICULA ON pelicula.nombre_pelicula = temporal.nombre_pelicula
                WHERE temporal.tienda_pelicula !='-'
                    AND temporal.tienda_pelicula IS NOT NULL
                    AND temporal.tienda_pelicula = tienda.nombre_tienda
                    AND temporal.tienda_pelicula != '-'
                    AND temporal.tienda_pelicula IS NOT NULL
                ;
*/

---- INSERT DETALLE ACTOR
 
 
     INSERT INTO DETALLE_ACTOR ( fk_id_actor, fk_id_pelicula)
        SELECT DISTINCT 
                    actor.id_actor, 
                    pelicula.id_pelicula
        FROM TEMPORAL
             INNER JOIN ACTOR ON CONCAT( CONCAT (actor.nombre_actor, ' '), actor.apellido_actor) = temporal.actor_pelicula
             INNER JOIN PELICULA ON pelicula.nombre_pelicula = temporal.nombre_pelicula
                WHERE temporal.actor_pelicula !='-'
                    AND temporal.actor_pelicula IS NOT NULL
                    AND temporal.nombre_pelicula !='-'
                    AND temporal.nombre_pelicula IS NOT NULL
                    ;
 
--INSERT DETALLE_LENGUAJE 

 
   INSERT INTO DETALLE_LENGUAJE ( fk_id_lenguaje, fk_id_pelicula)
        SELECT DISTINCT 
                    lenguaje.id_lenguaje, 
                    pelicula.id_pelicula
        FROM TEMPORAL
             INNER JOIN LENGUAJE ON lenguaje.lenguaje_pelicula = temporal.lenguaje_pelicula
             INNER JOIN PELICULA ON pelicula.nombre_pelicula = temporal.nombre_pelicula
                WHERE temporal.lenguaje_pelicula !='-'
                    AND temporal.lenguaje_pelicula IS NOT NULL
                    AND temporal.nombre_pelicula !='-'
                    AND temporal.nombre_pelicula IS NOT NULL
                    ;
 
 
 --INSERT DETALLE_CATEGORIA
 
 
    INSERT INTO DETALLE_CATEGORIA ( fk_id_categoria, fk_id_pelicula)
        SELECT DISTINCT 
                    categoria.id_categoria, 
                    pelicula.id_pelicula
        FROM TEMPORAL
             INNER JOIN CATEGORIA ON categoria.categoria_pelicula = temporal.categoria_pelicula
             INNER JOIN PELICULA ON pelicula.nombre_pelicula = temporal.nombre_pelicula
                WHERE temporal.categoria_pelicula !='-'
                    AND temporal.categoria_pelicula IS NOT NULL
                    AND temporal.nombre_pelicula !='-'
                    AND temporal.nombre_pelicula IS NOT NULL
                    ;
 
 
 
 
 -- PARA SELECCIONAR Y BORRAR LOS REGISTROS DE UNA TABLA
 SELECT * FROM TEMPORAL
 
SELECT * FROM PAIS;
SELECT COUNT (*) FROM PAIS;
DELETE FROM PAIS;
----------------------------------------------------------
SELECT * FROM CIUDAD;
SELECT COUNT (*) FROM CIUDAD;
DELETE FROM CIUDAD;
----------------------------------------------------------
SELECT * FROM LENGUAJE;
SELECT COUNT (*) FROM LENGUAJE;
DELETE FROM LENGUAJE;
----------------------------------------------------------
SELECT * FROM CATEGORIA;
SELECT COUNT (*) FROM CATEGORIA;
DELETE FROM CATEGORIA;
----------------------------------------------------------
SELECT * FROM CLASIFICACION;
SELECT COUNT (*) FROM CLASIFICACION;
DELETE FROM CLASIFICACION;
----------------------------------------------------------
 SELECT * FROM ACTOR;
 SELECT COUNT (*) FROM ACTOR;
 DELETE FROM ACTOR;
---------------------------------------------------------
SELECT * FROM CLIENTE
ORDER BY cliente.id_cliente
SELECT COUNT (*) FROM CLIENTE
DELETE FROM CLIENTE
---------------------------------------------------------
SELECT * FROM TIENDA
SELECT COUNT (*) FROM TIENDA
DELETE FROM TIENDA
---------------------------------------------------------
SELECT * FROM EMPLEADO
SELECT COUNT (*) FROM EMPLEADO
DELETE FROM EMPLEADO
---------------------------------------------------------
SELECT * FROM PELICULA
SELECT COUNT (*) FROM PELICULA
DELETE FROM PELICULA
---------------------------------------------------------
SELECT * FROM ALQUILER
SELECT COUNT (*) FROM ALQUILER
DELETE FROM ALQUILER
---------------------------------------------------------
SELECT * FROM TIENDA_PELICULA
SELECT COUNT (*) FROM TIENDA_PELICULA
DELETE FROM TIENDA_PELICULA
---------------------------------------------------------
SELECT * FROM DETALLE_ACTOR
SELECT COUNT (*) FROM DETALLE_ACTOR
DELETE FROM DETALLE_ACTOR
---------------------------------------------------------
SELECT * FROM DETALLE_LENGUAJE
SELECT COUNT (*) FROM DETALLE_LENGUAJE
DELETE FROM DETALLE_LENGUAJE
---------------------------------------------------------
SELECT * FROM DETALLE_CATEGORIA
SELECT COUNT (*) FROM DETALLE_CATEGORIA
DELETE FROM DETALLE_CATEGORIA