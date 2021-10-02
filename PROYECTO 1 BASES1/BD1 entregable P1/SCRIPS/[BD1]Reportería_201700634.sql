-- CONSULTAS 
/*
    CONSULTA#1
    Mostrar la cantidad de copias que existen en el inventario para la película
    “Sugar Wonka”.
*/

SELECT COUNT (*) AS COPIAS_PELICULA
FROM TIENDA_PELICULA
WHERE TIENDA_PELICULA.fk_id_pelicula IN 
    (
    SELECT pelicula.id_pelicula 
    FROM PELICULA
    WHERE pelicula.nombre_pelicula = 'SUGAR WONKA'
    )
    
    --PARA VER DETALLE DE COPIAS

SELECT *
FROM TIENDA_PELICULA
WHERE TIENDA_PELICULA.fk_id_pelicula IN 
    (
    SELECT pelicula.id_pelicula 
    FROM PELICULA
    WHERE pelicula.nombre_pelicula = 'SUGAR WONKA'
    )




/*
    CONSULTA # 2
    Mostrar el nombre, apellido y pago total de todos los clientes que han rentado
    películas por lo menos 40 veces.

*/

 SELECT cliente.id_cliente, cliente.nombre_cliente, cliente.apellido_cliente, SUM(alquiler.monto_a_pagar)AS total
 FROM cliente, alquiler
 WHERE cliente.id_cliente IN
         (SELECT alquiler.fk_id_cliente
         FROM alquiler
         HAVING COUNT (alquiler.fk_id_cliente)>=40
         GROUP BY alquiler.fk_id_cliente)
AND alquiler.fk_id_cliente = cliente.id_cliente
GROUP BY cliente.id_cliente, cliente.nombre_cliente, cliente.apellido_cliente
ORDER BY cliente.nombre_cliente;
 
 
 
 /*
    CONSULTA # 3
    Mostrar el nombre y apellido del cliente y el nombre de la película de todos
    aquellos clientes que hayan rentado una película y no la hayan devuelto y
    donde la fecha de alquiler esté más allá de la especificada por la película.
 */
 
 
( SELECT cliente.nombre_cliente, cliente.apellido_cliente, pelicula.nombre_pelicula
 FROM cliente, pelicula, alquiler
 WHERE alquiler.fecha_retorno is null
    AND alquiler.fk_id_cliente = cliente.id_cliente
    AND alquiler.fk_id_pelicula = pelicula.id_pelicula)
UNION ALL   -- hay diferencia en un UNION Y UNION ALL
(SELECT cliente.nombre_cliente, cliente.apellido_cliente, pelicula.nombre_pelicula
 FROM cliente, pelicula, alquiler, empleado
WHERE alquiler.fecha_retorno is not null
    AND alquiler.fecha_renta is not null
    AND pelicula.dias_renta is not null
    AND (alquiler.fecha_retorno-alquiler.fecha_pago) > pelicula.dias_renta
    AND alquiler.fk_id_cliente = cliente.id_cliente
    AND alquiler.fk_id_pelicula = pelicula.id_pelicula
    AND alquiler.fk_id_empleado = empleado.id_empleado)


/*
    CONSULTA # 4
    Mostrar el nombre y apellido (en una sola columna) de los actores que
    contienen la palabra “SON” en su apellido, ordenados por su primer nombre.
*/

select CONCAT( CONCAT( nombre_actor,' '), apellido_actor) as "Nombre actor"
from ACTOR
group by nombre_actor, apellido_actor
--having apellido_actor LIKE '%son%'      /*SE PUEDE USAR ESTE, O TAMBIEN CON WHERE, PERO EN ESE CASO YA NO ES NECESARIO EL GROUP BY*/
having instr(apellido_actor, 'son', 1, 1)>0
order by nombre_actor, apellido_actor


/*
    CONSULTA # 5
     Mostrar el apellido de todos los actores y la cantidad de actores que tienen
    ese apellido pero solo para los que comparten el mismo nombre por lo menos
    con dos actores.
*/

SELECT apellido_actor, COUNT(apellido_actor) AS repitencia_apellido, COUNT (nombre_actor) AS repitencia_nombre
FROM actor
group by apellido_actor
having COUNT(nombre_actor)>=2


/*
    CONSULTA # 6
    Mostrar el nombre y apellido de los actores que participaron en una película
    que involucra un “Cocodrilo” y un “Tiburón” junto con el año de lanzamiento
    de la película, ordenados por el apellido del actor en forma ascendente.
*/

    SELECT actor.nombre_actor, actor.apellido_actor, pelicula.anio_lazamiento
    FROM actor, pelicula, detalle_actor
    WHERE 
         detalle_actor.fk_id_actor = actor.id_actor
        AND detalle_actor.fk_id_pelicula = pelicula.id_pelicula
        AND pelicula.descripcion_pelicula LIKE '%Crocodile%' 
        AND pelicula.descripcion_pelicula LIKE '%Shark%'
    ORDER BY actor.apellido_actor ASC


--EN ESTA CONSULTA VEMOS EL NOMBRE DE LA PELICULA Y SU DESCRIPCION
/* select pelicula.nombre_pelicula , pelicula.descripcion_pelicula 
from pelicula
group by pelicula.nombre_pelicula ,pelicula.descripcion_pelicula
having instr(descripcion_pelicula, 'Crocodile', 1, 1)>0
    AND instr(descripcion_pelicula, 'Shark', 1, 1)>0

--EN ESTA CONSULTA VEMOS LOS ACTORES Y LA PELICULA EN LA QUE APARECEN 
SELECT nombre_actor,apellido_actor, nombre_pelicula
from actor, detalle_actor, pelicula
where detalle_actor.fk_id_actor = actor.id_actor
    and pelicula.id_pelicula = detalle_actor.fk_id_pelicula
order by  nombre_pelicula
*/




/*
    CONSULTA # 7 
    Mostrar el nombre de la categoría y el número de películas por categoría de
    todas las categorías de películas en las que hay entre 55 y 65 películas.
    Ordenar el resultado por número de películas de forma descendente.
*/

SELECT categoria.categoria_pelicula, COUNT (detalle_categoria.fk_id_categoria) as REPITENCIA
FROM categoria, detalle_categoria
GROUP BY categoria.categoria_pelicula, categoria.id_categoria, detalle_categoria.fk_id_categoria
HAVING 
    COUNT (detalle_categoria.fk_id_categoria) > 55
    AND COUNT (detalle_categoria.fk_id_categoria) < 65
    AND categoria.id_categoria = detalle_categoria.fk_id_categoria
ORDER BY COUNT (detalle_categoria.fk_id_categoria) DESC


/*
    CONSULTA # 8 
    Mostrar todas las categorías de películas en las que la diferencia promedio
    entre el costo de reemplazo de la película y el precio de alquiler sea superior
    a 17.
*/


SELECT categoria.categoria_pelicula, AVG (pelicula.costo_por_danio - pelicula.costo_renta) AS PROMEDIO
FROM categoria , pelicula , detalle_categoria
WHERE categoria.id_categoria = detalle_categoria.fk_id_categoria
    AND pelicula.id_pelicula = detalle_categoria.fk_id_pelicula
GROUP BY categoria.categoria_pelicula
HAVING AVG (pelicula.costo_por_danio - pelicula.costo_renta) > 17



/*
    CONSULTA # 9
    Mostrar el título de la película, el nombre y apellido del actor de todas
    aquellas películas en las que uno o más actores actuaron en dos o más
    películas.
*/

SELECT pelicula.nombre_pelicula, actor.nombre_actor, actor.apellido_actor 
FROM pelicula, actor, detalle_actor
WHERE pelicula.id_pelicula = detalle_actor.fk_id_pelicula
    AND actor.id_actor = detalle_actor.fk_id_actor
ORDER BY actor.nombre_actor, actor.apellido_actor   
    
        
/*
    CONSULTA # 10
    Mostrar el nombre y apellido (en una sola columna) de todos los actores y
    clientes cuyo primer nombre sea el mismo que el primer nombre del actor con
    ID igual a 8. No debe retornar el nombre del actor con ID igual a 8 
    dentro de la consulta. No puede utilizar el nombre del actor como una
    constante, únicamente el ID proporcionado.
*/

SELECT CONCAT (CONCAT (actor.nombre_actor, ' '), actor.apellido_actor) AS nombre
FROM actor
WHERE actor.id_actor !=8
    AND actor.nombre_actor IN
                    (SELECT actor.nombre_actor
                    FROM actor
                    WHERE actor.id_actor = 8)
UNION
SELECT CONCAT (CONCAT (cliente.nombre_cliente, ' '), cliente.apellido_cliente) as nombre
FROM cliente
WHERE cliente.nombre_cliente IN
                    (SELECT actor.nombre_actor
                    FROM actor
                    WHERE actor.id_actor = 8)


select * from actor
/*
    CONSULTA # 11
    Mostrar el país y el nombre del cliente que más películas rentó así como
    también el porcentaje que representa la cantidad de películas que rentó con
    respecto al resto de clientes del país.
*/


-- CONSULTA DONDE DEVUELVE EL PAIS, NOMBRE DEL CLIENTE Y APLELLIDO CONCATENADO 
SELECT pais.pais,cliente.nombre_cliente, cliente.apellido_cliente, PORCENTAJE
FROM (     SELECT CONCAT( COUNT(alquiler.fk_id_cliente)*100/ SUM( COUNT(alquiler.fk_id_cliente)), ' %') AS PORCENTAJE  -- ESTA CONSULTA NOS DEVULVE EL PORCENTAJE
            FROM ALQUILER
            GROUP BY alquiler.fk_id_cliente 
            HAVING COUNT(alquiler.fk_id_cliente) > 0 -- PARA PODER TETORNAR SOLO EL ID, Y USARLO COMO SUBCONSULTA
            ORDER BY COUNT(alquiler.fk_id_cliente) DESC -- ORDENA POR MEDIO DEL COUNT Y CON DESC PARA DEJAR AL MAS ALTO HASTA ARRIVA
            FETCH FIRST 1 ROW ONLY),pais, cliente, ciudad
WHERE cliente.id_cliente IN
            (
            SELECT alquiler.fk_id_cliente  -- ESTA CONSULTA NOS DEVULVE SOLO EL ID DEL CLIENTE QUE MAS PELICULAS HA RENTADO
            FROM ALQUILER
            GROUP BY alquiler.fk_id_cliente 
            HAVING COUNT(alquiler.fk_id_cliente) > 0 -- PARA PODER TETORNAR SOLO EL ID, Y USARLO COMO SUBCONSULTA
            ORDER BY COUNT(alquiler.fk_id_cliente) DESC -- ORDENA POR MEDIO DEL COUNT Y CON DESC PARA DEJAR AL MAS ALTO HASTA ARRIVA
            FETCH FIRST 1 ROW ONLY -- DEVUELVE SOLO LA PRIMERA FILA
            )
    AND cliente.fk_id_ciudad = ciudad.id_ciudad
    AND ciudad.fk_id_pais = pais.id_pais



/*
    CONSULTA # 12  NO SE REALIZABA POR FALTA DE SE UN CAMPO QUE DEFINA QUE SEXO ES CADA PERSONAJE EN EL ARCHIVO DE ENTRADA
    Mostrar el total de clientes y porcentaje de clientes mujeres por ciudad y país.
    El ciento por ciento es el total de mujeres por país. (Tip: Todos los
    porcentajes por ciudad de un país deben sumar el 100%).
*/



/*
    CONSULTA # 13
    Mostrar el nombre del país, nombre del cliente y número de películas
    rentadas de todos los clientes que rentaron más películas por país. Si el
    número de películas máximo se repite, mostrar todos los valores que
    representa el máximo.
*/
/*
--numero de peliculas rentadas por cliente
select alquiler.fk_id_cliente, COUNT (alquiler.fk_id_cliente) as cantidad_rentas
from alquiler
GROUP BY alquiler.fk_id_cliente
order by alquiler.fk_id_cliente


-- POR PAIS, POR NOMBRE Y APELLIDO Y NUMERO DE RENTAS DE CADA CLIENTE
select pais.pais, cliente.nombre_cliente, cliente.apellido_cliente, COUNT (alquiler.fk_id_cliente) as cantidad_rentas --TAMBIEN SE PUEDE HACER CON COUNT (*), POR QUE LO QUE NOS INTERESA SON LAS TUPLAS
from alquiler, pais, cliente, ciudad
WHERE alquiler.fk_id_cliente = cliente.id_cliente 
    AND cliente.fk_id_ciudad = ciudad.id_ciudad
    AND ciudad.fk_id_pais = pais.id_pais
GROUP BY pais.pais , cliente.nombre_cliente, cliente.apellido_cliente
order by pais , cantidad_rentas DESC


--MAXIMO POR PAIS
SELECT PA AS PAIS ,MAX(cantidad_rentas)
        FROM (select pais.pais AS PA, alquiler.fk_id_cliente , COUNT (*) as cantidad_rentas
                from alquiler, pais, cliente, ciudad
                WHERE alquiler.fk_id_cliente = cliente.id_cliente 
                    AND cliente.fk_id_ciudad = ciudad.id_ciudad
                    AND ciudad.fk_id_pais = pais.id_pais
                GROUP BY pais.pais ,alquiler.fk_id_cliente
                order by pais.pais)
        GROUP BY PA
        ORDER BY PA    
*/

SELECT PA AS PAIS , MAX(NOM)AS NOMBRE , MAX(APE) AS APELLIDO, MAX(cantidad_rentas) AS CANTIDAD
FROM (select pais.pais AS PA, cliente.nombre_cliente AS NOM, cliente.apellido_cliente AS APE , COUNT (*) as cantidad_rentas
        from alquiler, pais, cliente, ciudad
        WHERE alquiler.fk_id_cliente = cliente.id_cliente 
            AND cliente.fk_id_ciudad = ciudad.id_ciudad
            AND ciudad.fk_id_pais = pais.id_pais
        GROUP BY pais.pais , cliente.id_cliente,  cliente.nombre_cliente, cliente.apellido_cliente
        order by pais.pais)
GROUP BY PA
ORDER BY PA
   

/*
    CONSULTA # 14
    Mostrar todas las ciudades por país en las que predomina la renta de
    películas de la categoría “Horror”. Es decir, hay más rentas que las otras
    categorías.
*/

/*
--TODOS LOS PAISES CON SUS CIUDADES 
 SELECT pais.pais, ciudad.ciudad
 FROM pais, ciudad
 WHERE pais.id_pais = ciudad.fk_id_pais


--peliculas con categoria de HORROR 
SELECT pelicula.nombre_pelicula , categoria.categoria_pelicula
FROM pelicula, categoria, detalle_categoria
WHERE detalle_categoria.fk_id_categoria IN 
                    (
                    SELECT categoria.id_categoria
                    FROM categoria
                    WHERE categoria.categoria_pelicula = 'Horror'          
                    )
        AND detalle_categoria.fk_id_pelicula = pelicula.id_pelicula
        AND detalle_categoria.fk_id_categoria = categoria.id_categoria


--PAIS CON SUS CIUDADES, NOMBRE Y APELLIDO DEL CLIENTE, NOMBRE PELICULA QUE RENTO, CESGADO POR CATEGORIA HORROR
 SELECT pais.pais, ciudad.ciudad, cliente.nombre_cliente, cliente.apellido_cliente, pelicula.nombre_pelicula,categoria.categoria_pelicula
 FROM pais, ciudad, cliente, pelicula, alquiler, categoria, detalle_categoria
 WHERE 
     detalle_categoria.fk_id_categoria IN
                                        (
                                        SELECT categoria.id_categoria
                                        FROM categoria
                                        WHERE categoria.categoria_pelicula = 'Horror'
                                        )
    AND pais.id_pais = ciudad.fk_id_pais
    AND cliente.fk_id_ciudad = ciudad.id_ciudad
    AND alquiler.fk_id_cliente = cliente.id_cliente
    AND alquiler.fk_id_pelicula = pelicula.id_pelicula
    AND detalle_categoria.fk_id_pelicula = pelicula.id_pelicula
    AND detalle_categoria.fk_id_categoria = categoria.id_categoria
ORDER BY pais.pais,ciudad.ciudad


-- AGRUPADDO POR ID CLIENTE Y CATEGORIA HACIENDO COUNT DE LAS CATEGORIAS DE ALQUILERES POR CLIENTE
SELECT cliente.id_cliente, categoria.categoria_pelicula , COUNT (categoria.id_categoria) AS conteo_categoria
FROM ALQUILER, PELICULA, CATEGORIA, DETALLE_CATEGORIA, cliente
WHERE alquiler.fk_id_pelicula = pelicula.id_pelicula
     AND detalle_categoria.fk_id_pelicula = pelicula.id_pelicula
     AND detalle_categoria.fk_id_categoria = categoria.id_categoria
     AND alquiler.fk_id_cliente = cliente.id_cliente
GROUP BY cliente.id_cliente, categoria.categoria_pelicula
ORDER BY cliente.id_cliente, conteo_categoria DESC


-- AGRUPADO POR CLIENTE, OBTENIENDO LA CATEGORIA Y EL MAXIMO DE ALQUILERES QUE TIENE CADA CATEGORIA POR CLIENTE
SELECT CUSTOMER,MAX( CATEGOR)categoriaa, MAX(conteo_categoria)conteoo
    FROM(
        SELECT cliente.id_cliente AS CUSTOMER, categoria.categoria_pelicula AS CATEGOR, COUNT (categoria.id_categoria) AS conteo_categoria
        FROM ALQUILER, PELICULA, CATEGORIA, DETALLE_CATEGORIA, cliente
        WHERE alquiler.fk_id_pelicula = pelicula.id_pelicula
             AND detalle_categoria.fk_id_pelicula = pelicula.id_pelicula
             AND detalle_categoria.fk_id_categoria = categoria.id_categoria
             AND alquiler.fk_id_cliente = cliente.id_cliente
        GROUP BY cliente.id_cliente, categoria.categoria_pelicula
        )
GROUP BY CUSTOMER
ORDER BY CUSTOMER



-- sesgado por categoria horror, por lo mismo no devuelve solo el maximo
SELECT CUSTOMER,MAX( CATEGOR)AS categeria_nombre, MAX(conteo_categoria) AS categoria_conteo
    FROM(
        SELECT cliente.id_cliente AS CUSTOMER, categoria.categoria_pelicula AS CATEGOR, COUNT (categoria.id_categoria) AS conteo_categoria
        FROM ALQUILER, PELICULA, CATEGORIA, DETALLE_CATEGORIA, cliente
        WHERE alquiler.fk_id_pelicula = pelicula.id_pelicula
             AND detalle_categoria.fk_id_pelicula = pelicula.id_pelicula
             AND detalle_categoria.fk_id_categoria = categoria.id_categoria
             AND alquiler.fk_id_cliente = cliente.id_cliente
        GROUP BY cliente.id_cliente, categoria.categoria_pelicula
        ),DETALLE_CATEGORIA, CATEGORIA, PELICULA, ALQUILER, CLIENTE
        WHERE detalle_categoria.fk_id_categoria = categoria.id_categoria
            AND categoria.categoria_pelicula = CATEGOR
            AND detalle_categoria.fk_id_pelicula = pelicula.id_pelicula
            AND alquiler.fk_id_cliente = CUSTOMER
            AND cliente.id_cliente = CUSTOMER
            AND categoria.id_categoria IN 
                                        (
                                        SELECT categoria.id_categoria
                                        FROM categoria
                                        WHERE categoria.categoria_pelicula = 'Horror'
                                        )                
GROUP BY CUSTOMER
ORDER BY CUSTOMER


*/

-- TERMINADA
SELECT PA, CIU
FROM (
        SELECT pais.pais AS PA, ciudad.ciudad AS CIU, CUSTOMER,MAX( CATEGOR)categoriaa, MAX(conteo_categoria)conteoo
            FROM(
                SELECT cliente.id_cliente AS CUSTOMER, categoria.categoria_pelicula AS CATEGOR, COUNT (categoria.id_categoria) AS conteo_categoria
                FROM ALQUILER, PELICULA, CATEGORIA, DETALLE_CATEGORIA, cliente
                WHERE alquiler.fk_id_pelicula = pelicula.id_pelicula
                     AND detalle_categoria.fk_id_pelicula = pelicula.id_pelicula
                     AND detalle_categoria.fk_id_categoria = categoria.id_categoria
                     AND alquiler.fk_id_cliente = cliente.id_cliente
                GROUP BY cliente.id_cliente, categoria.categoria_pelicula
                ), CLIENTE, CIUDAD, PAIS
            WHERE cliente.id_cliente = CUSTOMER
                AND cliente.fk_id_ciudad = ciudad.id_ciudad
                AND ciudad.fk_id_pais = pais.id_pais
        GROUP BY pais.pais, ciudad.ciudad, CUSTOMER
        ORDER BY  pais.pais, ciudad.ciudad
        )
WHERE categoriaa = 'Horror'



/*
    CONSULTA # 15
    Mostrar el nombre del país, la ciudad y el promedio de rentas por ciudad. Por
    ejemplo: si el país tiene 3 ciudades, se deben sumar todas las rentas de la
    ciudad y dividirlo dentro de tres (número de ciudades del país).
*/

/*
-- NUMERO DE CIUDADES POR PAIS
SELECT pais.pais, COUNT (ciudad.ciudad)AS Countrys
FROM pais, ciudad
WHERE pais.id_pais = ciudad.fk_id_pais
group by pais.pais 
order by pais.pais


--numero de peliculas rentadas por cliente
select alquiler.fk_id_cliente, COUNT (alquiler.fk_id_cliente) as cantidad_rentas
from alquiler
GROUP BY alquiler.fk_id_cliente
order by alquiler.fk_id_cliente


-- cantidad de rentas por pais
select pais.pais, COUNT (alquiler.fk_id_cliente) as cantidad_rentas --TAMBIEN SE PUEDE HACER CON COUNT (*), POR QUE LO QUE NOS INTERESA SON LAS TUPLAS
from alquiler, pais, cliente, ciudad
WHERE alquiler.fk_id_cliente = cliente.id_cliente 
    AND cliente.fk_id_ciudad = ciudad.id_ciudad
    AND ciudad.fk_id_pais = pais.id_pais
GROUP BY pais.pais
order by pais , cantidad_rentas DESC




-- agrupado por pais y ciudad, suma de todas las rentas en esas ciudades
select pais.pais,ciudad.ciudad, COUNT (alquiler.fk_id_cliente) as cantidad_rentas --TAMBIEN SE PUEDE HACER CON COUNT (*), POR QUE LO QUE NOS INTERESA SON LAS TUPLAS
from alquiler, pais, cliente, ciudad
WHERE alquiler.fk_id_cliente = cliente.id_cliente 
    AND cliente.fk_id_ciudad = ciudad.id_ciudad
    AND ciudad.fk_id_pais = pais.id_pais
GROUP BY pais.pais, ciudad.ciudad
order by pais , cantidad_rentas DESC

*/


SELECT pais.pais, ciudad.ciudad, cantidad_rentas / Countrys
FROM (
        select pais.id_pais AS IDPA, pais.pais AS PA , ciudad.id_ciudad AS IDCIU, ciudad.ciudad AS CIU , COUNT (alquiler.fk_id_cliente) as cantidad_rentas --TAMBIEN SE PUEDE HACER CON COUNT (*), POR QUE LO QUE NOS INTERESA SON LAS TUPLAS
        from alquiler, pais, cliente, ciudad
        WHERE alquiler.fk_id_cliente = cliente.id_cliente 
            AND cliente.fk_id_ciudad = ciudad.id_ciudad
            AND ciudad.fk_id_pais = pais.id_pais
        GROUP BY  pais.id_pais ,pais.pais, ciudad.id_ciudad , ciudad.ciudad
        order by pais 
        ),
        (
        SELECT pais.id_pais AS CIDPA, pais.pais AS PAA ,COUNT (ciudad.ciudad)AS Countrys
        FROM pais, ciudad
        WHERE pais.id_pais = ciudad.fk_id_pais
        group by pais.id_pais, pais.pais
        order by PAA
        ), PAIS, CIUDAD
WHERE CIDPA = IDPA
    AND pais.id_pais = IDPA
    AND ciudad.id_ciudad = IDCIU
    AND ciudad.fk_id_pais = IDPA
ORDER BY pais.pais


/*
    CONSULTA # 16
    Mostrar el nombre del país y el porcentaje de rentas de películas de la
    categoría “Sports”
*/

SELECT pais.pais, CONCAT (CANTIDAD_ALQUILERES*100 / cantidad_rentas , ' %') PORCENTAJE_POR_PAIS
FROM
(
        SELECT pais.id_pais AS IDPA, categoria.id_categoria AS IDCAT, COUNT (*)AS CANTIDAD_ALQUILERES
        FROM pais, ciudad, cliente, alquiler, pelicula, categoria, detalle_categoria
        WHERE pais.id_pais = ciudad.fk_id_pais
            AND ciudad.id_ciudad = cliente.fk_id_ciudad
            AND alquiler.fk_id_cliente = cliente.id_cliente
            AND alquiler.fk_id_pelicula = pelicula.id_pelicula
            AND pelicula.id_pelicula = detalle_categoria.fk_id_pelicula
            AND detalle_categoria.fk_id_categoria = categoria.id_categoria
            AND categoria.categoria_pelicula = 'Sports'
        GROUP BY pais.id_pais, categoria.id_categoria
        ORDER BY pais.id_pais
        ),
        (
        select pais.id_pais AS IDPAA, COUNT (alquiler.fk_id_cliente) as cantidad_rentas --TAMBIEN SE PUEDE HACER CON COUNT (*), POR QUE LO QUE NOS INTERESA SON LAS TUPLAS
        from alquiler, pais, cliente, ciudad
        WHERE alquiler.fk_id_cliente = cliente.id_cliente 
            AND cliente.fk_id_ciudad = ciudad.id_ciudad
            AND ciudad.fk_id_pais = pais.id_pais
        GROUP BY pais.id_pais
        order by pais.id_pais
        ), PAIS, CATEGORIA 
WHERE IDPAA = IDPA
    AND pais.id_pais = IDPAA
    AND pais.id_pais = IDPA
    AND categoria.id_categoria = IDCAT 
    
    
/*
    CONSULTA # 17
    Mostrar la lista de ciudades de Estados Unidos y el número de rentas de
    películas para las ciudades que obtuvieron más rentas que la ciudad
    “Dayton”
*/

SELECT PA, CIU, CANTIDAD_ALQUILERES
FROM 
(
     SELECT pais.pais AS PA, ciudad.ciudad AS CIU, COUNT (*)AS CANTIDAD_ALQUILERES
            FROM pais, ciudad, cliente, alquiler, pelicula, categoria, detalle_categoria
            WHERE pais.id_pais = ciudad.fk_id_pais
                AND ciudad.id_ciudad = cliente.fk_id_ciudad
                AND alquiler.fk_id_cliente = cliente.id_cliente
                AND alquiler.fk_id_pelicula = pelicula.id_pelicula
                AND pelicula.id_pelicula = detalle_categoria.fk_id_pelicula
                AND detalle_categoria.fk_id_categoria = categoria.id_categoria
                AND pais.pais = 'United States'
    GROUP BY pais.pais, ciudad.ciudad
),
(
    SELECT COUNT (*)AS CANTIDAD_ALQUILERES_cuidad
        FROM pais, ciudad, cliente, alquiler, pelicula, categoria, detalle_categoria
        WHERE pais.id_pais = ciudad.fk_id_pais
            AND ciudad.id_ciudad = cliente.fk_id_ciudad
            AND alquiler.fk_id_cliente = cliente.id_cliente
            AND alquiler.fk_id_pelicula = pelicula.id_pelicula
            AND pelicula.id_pelicula = detalle_categoria.fk_id_pelicula
            AND detalle_categoria.fk_id_categoria = categoria.id_categoria
            AND pais.pais = 'United States'
            AND ciudad.ciudad = 'Dayton'
    GROUP BY pais.pais, ciudad.ciudad
)
WHERE CANTIDAD_ALQUILERES > CANTIDAD_ALQUILERES_cuidad
 

/*
    CONSULTA # 18
    Mostrar el nombre, apellido y fecha de retorno de película a la tienda de todos
    los clientes que hayan rentado más de 2 películas que se encuentren en
    lenguaje Inglés en donde el empleado que se las vendió ganará más de 15
    dólares en sus rentas del día en la que el cliente rentó la película.
*/


SELECT CLIN, CLIAPE, FECHR
FROM
        (
         SELECT cliente.id_cliente AS IDCLI, cliente.nombre_cliente AS CLIN, cliente.apellido_cliente AS CLIAPE, TRUNC(alquiler.fecha_renta) AS FECHI, alquiler.fecha_retorno AS FECHR, lenguaje.lenguaje_pelicula AS LENGU, alquiler.fk_id_empleado AS EMAQ1
         FROM cliente, alquiler, pelicula, lenguaje, detalle_lenguaje
         WHERE cliente.id_cliente = alquiler.fk_id_cliente
            AND alquiler.fk_id_pelicula = pelicula.id_pelicula
            AND pelicula.id_pelicula = detalle_lenguaje.fk_id_pelicula
            AND detalle_lenguaje.fk_id_lenguaje = lenguaje.id_lenguaje
            AND lenguaje.lenguaje_pelicula = 'English             '
            AND alquiler.fecha_retorno is not null
        ORDER BY CLIN, CLIAPE, FECHR
        ),  
        (  
        select cliente.id_cliente AS IDCLII, cliente.nombre_cliente AS CLINN, cliente.apellido_cliente AS CLIAPEE , count(*) AS CANTIDAD_RENTAS
        from alquiler, cliente, pelicula
        where cliente.id_cliente = alquiler.fk_id_cliente
            AND alquiler.fk_id_pelicula = pelicula.id_pelicula
        group by cliente.id_cliente ,cliente.nombre_cliente, cliente.apellido_cliente
        order by cliente.nombre_cliente, cliente.apellido_cliente
        ),
        (
        SELECT  alquiler.fk_id_empleado as empleadoFT , TRUNC(alquiler.fecha_renta) AS TFECH, sum(alquiler.comision)AS COMISIONN
        FROM alquiler
        group by alquiler.fk_id_empleado,TRUNC(alquiler.fecha_renta)
        order by alquiler.fk_id_empleado, alquiler.fk_id_empleado
        )
WHERE COMISIONN >15
    AND IDCLII = IDCLI
    AND EMAQ1 = empleadoFT
    AND CANTIDAD_RENTAS > 2
    AND FECHI = TFECH


/*
    CONSULTA #19
    Mostrar el número de mes, de la fecha de renta de la película, nombre y
    apellido de los clientes que más películas han rentado y las que menos en
    una sola consulta.
*/


SELECT EXTRACT(MONTH FROM alquiler.fecha_renta)No_MES, cliente.nombre_cliente, cliente.apellido_cliente
FROM 
    (
        (
        select alquiler.fk_id_cliente AS ALQ1 , COUNT (alquiler.fk_id_cliente) as cantidad_rentas
        from alquiler
        GROUP BY alquiler.fk_id_cliente
        order by cantidad_rentas DESC
        FETCH FIRST 1 ROW ONLY
        )
        UNION 
        (
        select alquiler.fk_id_cliente AS ALQ1, COUNT (alquiler.fk_id_cliente) as cantidad_rentas
        from alquiler
        GROUP BY alquiler.fk_id_cliente
        order by cantidad_rentas ASC
        FETCH FIRST 1 ROW ONLY
        )
    ), ALQUILER, CLIENTE
WHERE alquiler.fk_id_cliente = ALQ1
    AND cliente.id_cliente = ALQ1
ORDER BY ALQ1

/*
    CONSULTA # 20
    Mostrar el porcentaje de lenguajes de películas más rentadas de cada ciudad
    durante el mes de julio del año 2005 de la siguiente manera: ciudad,
    lenguaje, porcentaje de renta.
*/
/*
-- cantidad de peliculas rentas con lenguaje ingles de cada pais 
SELECT ciudad.ciudad, count (lenguaje.id_lenguaje)
FROM pais, ciudad, cliente, alquiler, pelicula, detalle_lenguaje, lenguaje 
WHERE lenguaje.lenguaje_pelicula = 'English             '
    AND pais.id_pais = ciudad.fk_id_pais
    AND cliente.fk_id_ciudad = ciudad.id_ciudad
    AND  alquiler.fk_id_cliente = cliente.id_cliente
    AND  alquiler.fk_id_pelicula = pelicula.id_pelicula
    AND pelicula.id_pelicula = detalle_lenguaje.fk_id_pelicula
    AND detalle_lenguaje.fk_id_lenguaje = lenguaje.id_lenguaje
group by  ciudad.ciudad
ORDER BY ciudad.ciudad


-- cantidad de rentas por ciudad
select ciudad.ciudad, COUNT (alquiler.fk_id_cliente) as cantidad_rentas --TAMBIEN SE PUEDE HACER CON COUNT (*), POR QUE LO QUE NOS INTERESA SON LAS TUPLAS
from alquiler, pais, cliente, ciudad
WHERE alquiler.fk_id_cliente = cliente.id_cliente 
    AND cliente.fk_id_ciudad = ciudad.id_ciudad
    AND ciudad.fk_id_pais = pais.id_pais
GROUP BY ciudad.ciudad
order by ciudad.ciudad
*/

SELECT ciudad.ciudad , lenguaje.lenguaje_pelicula, CONCAT (MAXCP *100/MAXCP, ' %') AS PORCENTAJE
FROM 
            (
                SELECT IDCIU1 , MAX( PELID1 ) AS PE1, MAX( ALQID1 ) AS ALQ1 , MAX(LENG1) AS MAXLENG1, MAX(CONTADOR_PELICULA) AS MAXCP
                FROM 
                    (
                -- count de peliculas por nombre y ciudad 
                        SELECT  ciudad.id_ciudad AS IDCIU1, pelicula.id_pelicula AS PELID1 , alquiler.id_alquiler AS ALQID1,lenguaje.id_lenguaje AS LENG1, count (alquiler.id_alquiler) AS CONTADOR_PELICULA
                        FROM pais, ciudad, cliente, alquiler, pelicula, detalle_lenguaje, lenguaje 
                        WHERE 
                            pais.id_pais = ciudad.fk_id_pais
                            AND cliente.fk_id_ciudad = ciudad.id_ciudad
                            AND  alquiler.fk_id_cliente = cliente.id_cliente
                            AND  alquiler.fk_id_pelicula = pelicula.id_pelicula
                            AND pelicula.id_pelicula = detalle_lenguaje.fk_id_pelicula
                            AND detalle_lenguaje.fk_id_lenguaje = lenguaje.id_lenguaje
                            AND  EXTRACT(MONTH FROM alquiler.fecha_renta) = 7
                            AND EXTRACT(YEAR FROM alquiler.fecha_renta) = 2005
                        group by ciudad.id_ciudad, pelicula.id_pelicula, alquiler.id_alquiler, lenguaje.id_lenguaje
                    )
                GROUP BY  IDCIU1

            ),CIUDAD, LENGUAJE 
WHERE ciudad.id_ciudad = IDCIU1
    AND lenguaje.id_lenguaje = MAXLENG1
GROUP BY ciudad.ciudad , lenguaje.lenguaje_pelicula , MAXCP , MAXCP
ORDER BY ciudad.ciudad , lenguaje.lenguaje_pelicula

























-- OTRO 

SELECT ciudad.ciudad , lenguaje.lenguaje_pelicula, CONCAT (MAXCP *100/MAXCP2, ' %') AS PORCENTAJE
FROM 
            (
                SELECT IDCIU1 , MAX( PELID1 ) AS PE1, MAX( ALQID1 ) AS ALQ1 , MAX(LENG1) AS MAXLENG1, MAX(CONTADOR_PELICULA) AS MAXCP
                FROM 
                    (
                -- count de peliculas por nombre y ciudad 
                        SELECT  ciudad.id_ciudad AS IDCIU1, pelicula.id_pelicula AS PELID1 , alquiler.id_alquiler AS ALQID1,lenguaje.id_lenguaje AS LENG1, count (alquiler.id_alquiler) AS CONTADOR_PELICULA
                        FROM pais, ciudad, cliente, alquiler, pelicula, detalle_lenguaje, lenguaje 
                        WHERE 
                            pais.id_pais = ciudad.fk_id_pais
                            AND cliente.fk_id_ciudad = ciudad.id_ciudad
                            AND  alquiler.fk_id_cliente = cliente.id_cliente
                            AND  alquiler.fk_id_pelicula = pelicula.id_pelicula
                            AND pelicula.id_pelicula = detalle_lenguaje.fk_id_pelicula
                            AND detalle_lenguaje.fk_id_lenguaje = lenguaje.id_lenguaje
                            AND  EXTRACT(MONTH FROM alquiler.fecha_renta) = 7
                            AND EXTRACT(YEAR FROM alquiler.fecha_renta) = 2005
                        group by ciudad.id_ciudad, pelicula.id_pelicula, alquiler.id_alquiler, lenguaje.id_lenguaje
                    )
                GROUP BY  IDCIU1
            ),
            (
                SELECT IDCIU2 , MAX( PELID2 ) AS PE2, MAX( ALQID2) AS ALQ2 , MAX(LENG2) AS MAXLENG2, MAX(CONTADOR_PELICULA2) AS MAXCP2 
                FROM 
                    (
                    SELECT ciudad.id_ciudad AS IDCIU2, pelicula.id_pelicula AS PELID2, alquiler.id_alquiler AS ALQID2 , lenguaje.id_lenguaje AS LENG2 ,count (alquiler.id_alquiler) AS CONTADOR_PELICULA2
                        FROM pais, ciudad, cliente, alquiler, pelicula, detalle_lenguaje, lenguaje 
                        WHERE 
                            pais.id_pais = ciudad.fk_id_pais
                            AND cliente.fk_id_ciudad = ciudad.id_ciudad
                            AND  alquiler.fk_id_cliente = cliente.id_cliente
                            AND  alquiler.fk_id_pelicula = pelicula.id_pelicula
                            AND pelicula.id_pelicula = detalle_lenguaje.fk_id_pelicula
                            AND detalle_lenguaje.fk_id_lenguaje = lenguaje.id_lenguaje
                            AND  EXTRACT(MONTH FROM alquiler.fecha_renta) = 7
                            AND EXTRACT(YEAR FROM alquiler.fecha_renta) = 2005
                        group by ciudad.id_ciudad, pelicula.id_pelicula, alquiler.id_alquiler , lenguaje.id_lenguaje
                    )
                GROUP BY IDCIU2 
            ), CIUDAD, CLIENTE, LENGUAJE , ALQUILER
            
WHERE IDCIU1 = IDCIU2
    AND PE1 = PE2
    AND ALQ1 = ALQ2
    AND MAXLENG2 = MAXLENG1
    AND ciudad.id_ciudad = IDCIU1
    AND ciudad.id_ciudad = IDCIU2
    AND cliente.id_cliente = PE2
    AND cliente.id_cliente = PE1
    AND alquiler.id_alquiler = ALQ1
    AND alquiler.id_alquiler = ALQ2
    AND lenguaje.id_lenguaje = MAXLENG2
    AND lenguaje.id_lenguaje = MAXLENG1
GROUP BY ciudad.ciudad , lenguaje.lenguaje_pelicula , MAXCP , MAXCP2
ORDER BY ciudad.ciudad , lenguaje.lenguaje_pelicula
