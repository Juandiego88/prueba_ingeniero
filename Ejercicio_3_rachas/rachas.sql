create database prueba2;
use prueba2;

CREATE TABLE HISTORIA (
    identificacion VARCHAR(30),
    corte_mes VARCHAR(15),
    saldo BIGINT
);

CREATE TABLE retiros (
	identificacion VARCHAR(30),
    fecha_retiro VARCHAR(15)
);

WITH rango_fechas AS (
    SELECT
        hist.identificacion,
        MAX(STR_TO_DATE(hist.corte_mes, '%d/%m/%Y')) AS fecha_maxima,
        MIN(STR_TO_DATE(hist.corte_mes, '%d/%m/%Y')) AS fecha_minima
    FROM historia hist
    GROUP BY hist.identificacion
),
cambio_fecha AS (
    SELECT 
        identificacion,
        STR_TO_DATE(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                fecha_retiro, 'ene', 'Jan'), 'feb', 'Feb'), 'mar', 'Mar'), 'abr', 'Apr'),
                'may', 'May'), 'jun', 'Jun'), 'jul', 'Jul'), 'ago', 'Aug'),
                'sep', 'Sep'), 'oct', 'Oct'), 'nov', 'Nov'), 'dic', 'Dec'),
            '%d-%b-%y'
        ) AS fecha_retiro
    FROM retiros
),
-- Se revisa que los id que están en retirados tengan una historia  
retirados AS (

    SELECT 
        r.identificacion,
        r.fecha_retiro AS fecha_maxima
    FROM cambio_fecha r
    WHERE r.identificacion IN (SELECT identificacion FROM rango_fechas)
),
-- Reemplazamos la fecha máxima solo si hay coincidencia con retirados
max_min AS (
	SELECT 
		rf.identificacion,
		CASE 
			WHEN rt.fecha_maxima IS NOT NULL THEN rt.fecha_maxima
			ELSE rf.fecha_maxima
		END AS fecha_maxima,
		rf.fecha_minima
	FROM rango_fechas rf
	LEFT JOIN retirados rt
	ON rf.identificacion = rt.identificacion
),
-- Se filtran los registros que sean mayores a la fecha máxima , que es la fecha de retiro en los casos que se tenga
historia_filtrada AS (
	SELECT 
		h.identificacion,
		STR_TO_DATE(h.corte_mes, '%d/%m/%Y') AS fecha_corte,
		h.saldo
	FROM prueba2.historia h
	INNER JOIN max_min mm
		ON h.identificacion = mm.identificacion
	WHERE STR_TO_DATE(h.corte_mes, '%d/%m/%Y') <= mm.fecha_maxima
),
-- Se clasifican los registros , sin rellenar los meses faltantes
clasificacion AS (
    SELECT 
        hf.identificacion,
        hf.fecha_corte,
        hf.saldo,
        CASE 
            WHEN hf.saldo >= 0 AND hf.saldo < 300000 THEN 'N0'
            WHEN hf.saldo >= 300000 AND hf.saldo < 1000000 THEN 'N1'
            WHEN hf.saldo >= 1000000 AND hf.saldo < 3000000 THEN 'N2'
            WHEN hf.saldo >= 3000000 AND hf.saldo < 5000000 THEN 'N3'
            WHEN hf.saldo >= 5000000 THEN 'N4'
        END AS clasificacion
    FROM historia_filtrada hf
),
seq AS (
    -- Genera una secuencia de números , desde 0 a 35, 3 años 
    SELECT n FROM (
        SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
        SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
        SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
        SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL
        SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL
        SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL
        SELECT 24 UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL
        SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30 UNION ALL SELECT 31 UNION ALL
        SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35 
    ) num
),
-- Se crean y se clasifican los meses faltantes entre la fecha mínima y la máxima 
meses_faltantes AS (
    SELECT 
        mm.identificacion,
        DATE_ADD(mm.fecha_minima, INTERVAL seq.n MONTH) AS fecha_corte,
        0 AS saldo,
        'N0' AS clasificacion
    FROM max_min mm
    CROSS JOIN seq
    WHERE DATE_ADD(mm.fecha_minima, INTERVAL seq.n MONTH) <= mm.fecha_maxima
      AND DATE_ADD(mm.fecha_minima, INTERVAL seq.n MONTH) NOT IN (
          SELECT fecha_corte FROM historia_filtrada 
          WHERE historia_filtrada.identificacion = mm.identificacion
      )
),
clasificacion_completa AS (
	SELECT * FROM clasificacion
	UNION ALL
	SELECT * FROM meses_faltantes
	ORDER BY identificacion, fecha_corte
), 
filtro_fecha AS (
    SELECT 
        identificacion,
        fecha_corte,
        saldo,
        clasificacion
    FROM clasificacion_completa
    WHERE fecha_corte <= '2025-01-01' -- fecha donde se quiera parar 
),
-- Se añade un índice a cada registro 
indice AS (
    SELECT 
        identificacion,
        fecha_corte,
        saldo,
        clasificacion,
        ROW_NUMBER() OVER (PARTITION BY identificacion ORDER BY fecha_corte) AS fila
    FROM filtro_fecha
),
-- Se ordenan las rachas por clasificación con el cálculo de los índices 
clasificacion_consecutiva AS (
    SELECT 
        identificacion,
        fecha_corte,
        saldo,
        clasificacion,
        fila,
        fila - ROW_NUMBER() OVER (PARTITION BY identificacion, clasificacion ORDER BY fecha_corte) AS grupo
    FROM indice
),
-- Se cuenta el número de meses de racha con ayuda del cálculo hecho anteriormente llamado con alias de "grupo"
filtro_racha AS (
    SELECT 
        identificacion,
        clasificacion AS nivel,
        MIN(fecha_corte) AS fecha_inicio,
        MAX(fecha_corte) AS fecha_fin,
        COUNT(*) AS racha
    FROM clasificacion_consecutiva
    GROUP BY identificacion, clasificacion, grupo
    HAVING COUNT(*) >= 1
),
-- Se le asigna un índice a las rachas para saber cual es la mayor y se ordena por fecha final de manera descendiente para que queden ordenadas como se espera
racha_maxima AS (
    SELECT 
        identificacion,
        nivel,
        racha,
        fecha_fin,
        ROW_NUMBER() OVER (
            PARTITION BY identificacion 
            ORDER BY racha DESC,fecha_fin DESC
        ) AS ranking
    FROM filtro_racha
)
SELECT 
    identificacion,
    racha,
    nivel,
    fecha_fin
FROM racha_maxima
WHERE ranking = 1;