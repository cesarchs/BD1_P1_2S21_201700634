OPTIONS (SKIP=1)
    LOAD DATA
    CHARACTERSET UTF8
    INFILE 'Entrada/BlockbusterData.csv'
    INTO TABLE TEMPORAL TRUNCATE
    FIELDS TERMINATED BY ";"
    TRAILING NULLCOLS(
        NOMBRE_CLIENTE                      NULLIF NOMBRE_CLIENTE='-',
        CORREO_CLIENTE,
        CLIENTE_ACTIVO,
        FECHA_CREACION                      NULLIF FECHA_CREACION='-',
        TIENDA_PREFERIDA,
        DIRECCION_CLIENTE,
        CODIGO_POSTAL_CLIENTE,
        CIUDAD_CLIENTE,
        PAIS_CLIENTE,
        FECHA_RENTA                         NULLIF FECHA_RENTA='-',
        FECHA_RETORNO                       NULLIF FECHA_RETORNO='-',
        MONTO_A_PAGAR                       ,
        FECHA_PAGO                          NULLIF FECHA_PAGO='-',
        NOMBRE_EMPLEADO,
        CORREO_EMPLEADO,
        EMPLEADO_ACTIVO,
        TIENDA_EMPLEADO                     NULLIF TIENDA_EMPLEADO='-',
        USUARIO_EMPLEADO,
        CONTRASENA_EMPLEADO,
        DIRECCION_EMPLEADO,
        CODIGO_POSTAL_EMPLEADO,
        CIUDAD_EMPLEADO,
        PAIS_EMPLEADO,
        NOMBRE_TIENDA,
        ENCARGADO_TIENDA,
        DIRECCION_TIENDA,
        CODIGO_POSTAL_TIENDA,
        CIUDAD_TIENDA,
        PAIS_TIENDA,
        TIENDA_PELICULA                     NULLIF TIENDA_PELICULA='-',
        NOMBRE_PELICULA,
        DESCRIPCION_PELICULA,
        ANO_LANZAMIENTO                     ,
        DIAS_RENTA                          ,
        COSTO_RENTA                         ,
        DURACION                            ,
        COSTO_POR_DANO                      ,
        CLASIFICACION,
        LENGUAJE_PELICULA,
        CATEGORIA_PELICULA,
        ACTOR_PELICULA
        
    )