create database prueba;
use prueba;

CREATE TABLE CLIENTES (
    NOMBRE VARCHAR(20),
    IDENTIFICACIÓN VARCHAR(30) ,
    TIPO_DOCUMENTO VARCHAR(10),
    CLASIFICACION VARCHAR(15),
    TIPO_TARJETA VARCHAR(10),
    FEÇHA_APERTURA_TARJETA VARCHAR(15),
    ESTADO_TARJETA VARCHAR(10)
);

CREATE TABLE TRANSACCIONES (
    IDENTIFICACION VARCHAR(30),
    ID_TRANSACCION INT,
    FECHA_TRANSACCION VARCHAR(15),
    CODIGO_CATEGORIA INT,
    ESTADO VARCHAR(15),
    VALOR_COMPRA DECIMAL(5,2)
);

CREATE TABLE CATEGORIAS_CONSUMO (
    CODIGO_CATEGORIA VARCHAR(30),
    NOMBRE_CATEGORIA VARCHAR (15),
    CIUDAD VARCHAR(10),
    DEPARTAMENTO VARCHAR(20)
);

WITH filtro_clientes AS (
	SELECT 
	*
	FROM 
    prueba.clientes
	WHERE 
		ESTADO_TARJETA = 'Activa' 
		AND TIPO_DOCUMENTO != 'DNI'
		AND (TIPO_DOCUMENTO != 'Pasaporte' 
		OR (TIPO_DOCUMENTO = 'Pasaporte' AND TIPO_TARJETA = 'Débito' AND CLASIFICACION = 'Personal'))
),
-- Filtrar transacciones, solo las aprobadas y en la fecha deseada y que el código de categoría este entre 1 y 60
transacciones_validas AS(	
    SELECT 
			trx.IDENTIFICACION,
			trx.CODIGO_CATEGORIA,
			trx.FECHA_TRANSACCION,
			cli.NOMBRE,
			cli.TIPO_DOCUMENTO,
			cli.TIPO_TARJETA,
			cli.CLASIFICACION,
			cli.FEÇHA_APERTURA_TARJETA AS FECHA_APERTURA_TARJETA,
            cli.ESTADO_TARJETA
	FROM prueba.transacciones trx
	INNER JOIN filtro_clientes cli 
	ON trx.IDENTIFICACION = cli.IDENTIFICACIÓN
	WHERE trx.ESTADO = 'Aprobada' 
    AND STR_TO_DATE(trx.FECHA_TRANSACCION, '%d/%m/%Y') BETWEEN '2004-05-10' AND '2023-06-01'
    AND trx.CODIGO_CATEGORIA BETWEEN 1 AND 60
),
-- Numero de transacciones por categoría y id 
transacciones_categoria AS(
	SELECT 
			trx.IDENTIFICACION,
			trx.CODIGO_CATEGORIA,
			COUNT(1) AS TOTAL_TRANSACCIONES
	FROM transacciones_validas trx
	GROUP BY trx.IDENTIFICACION, trx.CODIGO_CATEGORIA
),
categoria_rank AS(
	SELECT 
			trxc.IDENTIFICACION,
			trxc.CODIGO_CATEGORIA,
			trxc.TOTAL_TRANSACCIONES,
			ROW_NUMBER() OVER (
				PARTITION BY trxc.IDENTIFICACION 
				ORDER BY trxc.TOTAL_TRANSACCIONES DESC
			) AS PREFERENCIA_RANK
	FROM transacciones_categoria trxc
),
-- Filtro para niveles de preferencia
numero_rank AS (
    SELECT 
        cr.IDENTIFICACION,
        cr.CODIGO_CATEGORIA,
        cr.TOTAL_TRANSACCIONES,
        cr.PREFERENCIA_RANK
    FROM categoria_rank cr
    WHERE cr.PREFERENCIA_RANK >= 3
),
-- Fecha de la última transacción por categoría preferida
ultima_transaccion AS (
    SELECT 
        numr.IDENTIFICACION,
        numr.CODIGO_CATEGORIA,
        MAX(trxv.FECHA_TRANSACCION) AS ULTIMA_FECHA
    FROM numero_rank numr
    INNER JOIN transacciones_validas trxv 
        ON numr.IDENTIFICACION = trxv.IDENTIFICACION
        AND numr.CODIGO_CATEGORIA = trxv.CODIGO_CATEGORIA
    GROUP BY numr.IDENTIFICACION, numr.CODIGO_CATEGORIA
)
SELECT DISTINCT

    ut.IDENTIFICACION,
    tv.NOMBRE,
    tv.TIPO_DOCUMENTO,
    tv.TIPO_TARJETA,
    tv.CLASIFICACION,
    ut.CODIGO_CATEGORIA,
    cc.NOMBRE_CATEGORIA,
    ut.ULTIMA_FECHA,
    ctn.PREFERENCIA_RANK AS NIVEL_PREFERENCIA
FROM ultima_transaccion ut
INNER JOIN transacciones_validas tv 
    ON ut.IDENTIFICACION = tv.IDENTIFICACION
INNER JOIN prueba.categorias_consumo cc 
    ON ut.CODIGO_CATEGORIA = cc.CODIGO_CATEGORIA
INNER JOIN numero_rank ctn
    ON ut.IDENTIFICACION = ctn.IDENTIFICACION
    AND ut.CODIGO_CATEGORIA = ctn.CODIGO_CATEGORIA
ORDER BY 
    tv.NOMBRE ASC,ctn.PREFERENCIA_RANK ASC
    
