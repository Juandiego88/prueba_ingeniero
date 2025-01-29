# Solución prueba ingeniero de datos - Juan Diego Sánchez Ramos


## Ejercicio 1 - Procesamiento de archivos HTML en Python

## Descripción General

El programa tiene como objetivo recorrer archivos HTML en un directorio o una lista de rutas, encontrar todas las etiquetas `<img>` presentes en el contenido, convertir las imágenes asociadas a Base64 y reemplazar sus referencias en el HTML con la cadena codificada.

---

### Clases y Funciones

#### 1. `HTMLTagExtractor`
Extraer etiquetas `<img>` de un archivo HTML.

##### Métodos:
- **`extract_img_tags(html_content)`**
  - **Descripción:** Busca todas las etiquetas `<img>` en el contenido HTML y devuelve una lista de las fuentes (`src`) encontradas.
  - **Parámetros:**
    - `html_content`: Cadena con el contenido HTML.
  - **Retorno:** Lista de cadenas que representan las rutas de las imágenes.

---

#### 2. `ImageEncoder`
Codificar imágenes a formato Base64.

##### Métodos:
- **`encode_to_base64(img_path)`**
  - **Descripción:** Convierte una imagen a una cadena en formato Base64.
  - **Parámetros:**
    - `img_path`: Ruta de la imagen a codificar.
  - **Retorno:** Cadena que contiene la imagen codificada en Base64.
  - **Excepciones:** Lanza un `ValueError` en caso de que ocurra un error al procesar la imagen.

---
#### 3. `ResultsLogger`
Registrar los resultados del procesamiento de imágenes (éxito o fallo).

##### Métodos:
- **`__init__()`**
  - **Descripción:** Inicializa un diccionario para almacenar los resultados de éxito y fallo.

- **`log_success(html_file, img_src)`**
  - **Descripción:** Registra una imagen procesada con éxito.
  - **Parámetros:**
    - `html_file`: Archivo HTML procesado.
    - `img_src`: Ruta de la imagen procesada.

- **`log_failure(html_file, img_src, error_message)`**
  - **Descripción:** Registra una imagen que no pudo ser procesada.
  - **Parámetros:**
    - `html_file`: Archivo HTML procesado.
    - `img_src`: Ruta de la imagen fallida.
    - `error_message`: Mensaje de error asociado al fallo.

- **`get_results()`**
  - **Descripción:** Devuelve los resultados de éxito y fallo.
  - **Retorno:** Diccionario con claves `success` y `fail`.

---

#### 4. `FileProcessor`
 Procesar archivos HTML, reemplazar rutas de imágenes por datos codificados en Base64 y guardar los resultados en nuevos archivos.

##### Constructor:
- **`__init__(self, extractor, encoder, logger)`**
  - **Descripción:** Inicializa la clase con instancias de `HTMLTagExtractor`, `ImageEncoder` y `ResultsLogger`.

##### Métodos:

- **`process_html_files(input_paths)`**
  - **Descripción:** Procesa una lista de rutas de entrada (archivos o directorios), encuentra imágenes en los archivos HTML y reemplaza las rutas por cadenas Base64.
  - **Parámetros:**
    - `input_paths`: Lista de rutas a archivos o directorios.
  - **Retorno:** Diccionario con los resultados de éxito y fallo.

- **`_get_html_files(input_paths)`**
  - **Descripción:** Obtiene todos los archivos HTML desde las rutas especificadas.
  - **Parámetros:**
    - `input_paths`: Lista de rutas (archivos o directorios).
  - **Retorno:** Lista de rutas a los archivos HTML.

- **`_read_html(html_file)`**
  - **Descripción:** Lee el contenido de un archivo HTML.
  - **Parámetros:**
    - `html_file`: Ruta del archivo HTML.
  - **Retorno:** Cadena con el contenido del archivo.

- **`_process_image(html_file, img_src, html_content)`**
  - **Descripción:** Procesa una imagen específica: verifica si existe, la codifica a Base64 y reemplaza su referencia en el contenido HTML.
  - **Parámetros:**
    - `html_file`: Ruta del archivo HTML.
    - `img_src`: Ruta de la imagen a procesar.
    - `html_content`: Contenido HTML en el que se reemplazará la imagen.
  - **Excepciones:** Registra fallos si la imagen no existe o no se puede procesar.

- **`_save_processed_html(html_file, html_content)`**
  - **Descripción:** Guarda el contenido HTML procesado en un nuevo archivo con el sufijo `.processed.html`.
  - **Parámetros:**
    - `html_file`: Ruta original del archivo HTML.
    - `html_content`: Contenido HTML procesado.

---


### Ejecución Principal
El programa principal inicializa las clases necesarias y procesa los archivos HTML en un directorio.

#### Código Principal:
```python
if __name__ == "__main__":
    extractor = HTMLTagExtractor()
    encoder = ImageEncoder()
    logger = ResultsLogger()
    processor = FileProcessor(extractor, encoder, logger)
    #Ejemplo 
    input_paths = ["html"]  # Directorio o archivos a procesar, para una lista de archivos solo se debe de separar por ","
    results = processor.process_html_files(input_paths)

    print("Procesamiento completo:")
    print("Éxitos:", results['success'])
    print("Fallos:", results['fail'])
```

#### Descripción:
1. Crea instancias de las clases `HTMLTagExtractor`, `ImageEncoder` y `ResultsLogger`.
2. Inicializa un objeto `FileProcessor` con las instancias anteriores.
3. Define las rutas de entrada (directorio o archivos) y procesa los archivos HTML.
4. Imprime los resultados del procesamiento.

---

### Resultados
Los resultados se almacenan en un diccionario con la siguiente estructura:

- **`success`**: Contiene archivos HTML y las imágenes procesadas exitosamente.
- **`fail`**: Contiene archivos HTML y las imágenes que fallaron, junto con los mensajes de error correspondientes.

---

### Ejemplo de Uso

 Pueba_ingeniero_tuya/Ejercicio_1_html/ejercicio1POO.py
 
 Procesamiento completo:
 
 Éxitos: {'html\\images2-download.html': ['html/larch.jpg'], 'html\\images2.html': ['html/larch.jpg', 'html/larch.jpg'], 'html\\index.html': ['html/1.jpg', 'html/2.jpg', 'html/3.jpg', 'html/4.jpg', 'html/5.jpg'], 'html\\sub\\sub1\\images3-download.html': ['html/firefox.png'], 'html\\sub\\sub1\\images3.html': ['html/firefox.png', 'html\\firefox.png']}
 
 Fallos: {'html\\index.html': [('6.jpg', 'File not found'), ('7.jpg', 'File not found'), ('8.jpg', 'File not found'), ('9.png', 'File not found'), ('10.jpg', 'File not found'), ('11.jpg', 'File not found'), ('12.jpg', 'File not found')]}


### NOTA

En el archivo `index.html`, las rutas de las imágenes están configuradas con errores para poder observar el funcionamiento completo. Las imágenes de la `1` a la `5` tienen rutas correctas, pero las imágenes de la `6` a la `12` tienen rutas incorrectas. Es importante verificar las rutas y la ubicación desde donde se ejecuta el script `.py` para evitar errores en la carga de imágenes.

---
## Ejercicio 2 - Preferencias de consumo



## Consideraciones Iniciales

 
Se subieron las tablas a MySQL Workbench exactamente como estaban en el archivo `bd.xlsx`, sin realizar ningún tipo de limpieza previa en los datos. Se asumió que no se tenían permisos para modificar las tablas directamente. Sin embargo, se realizó un único cambio: el nombre de la columna "TIPO TARJETA" en la tabla "CLIENTES" fue modificado a "TIPO_TARJETA", ya que MySQL no aceptaba el espacio en el nombre de la columna.

Para subir las tablas, se utilizó la herramienta Table Data Import Wizard de MySQL Workbench, que permite importar datos a una base de datos MySQL desde archivos en formato CSV o JSON. En este caso, las tablas se convirtieron previamente a formato CSV y luego se subieron de manera individual

---

## Paso 1: Creación de la Base de Datos y Tablas
```sql
CREATE DATABASE prueba;
USE prueba;

CREATE TABLE CLIENTES (
    NOMBRE VARCHAR(20),
    IDENTIFICACIÓN VARCHAR(30),
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

```


---

## Paso 2: Subconsulta - Filtro de Clientes
```sql
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
```
### Explicación
La base de datos entregada presenta varios errores que afectan el análisis de los datos. En primer lugar, la columna "IDENTIFICACION" de la tabla "CLIENTES" contiene valores duplicados para algunos registros, lo que genera ambigüedades al relacionarla con la tabla "TRANSACCIONES". Esto se complica aún más porque en la tabla "TRANSACCIONES" no existe una columna adicional que permita identificar de manera única cada transacción y asociarla al cliente correspondiente.

Como resultado, al realizar cruces entre las tablas "CLIENTES" y "TRANSACCIONES", se generan duplicados en las transacciones, ya que no es posible diferenciar con precisión a cuál cliente pertenece cada registro.

Para mitigar este problema, se decidió filtrar la tabla de clientes antes de realizar cualquier cruce. Las reglas establecidas para este filtro son las siguientes:

1. Estado de la tarjeta: Solo se incluirán clientes cuya tarjeta esté en estado "Activa".
2. Tipo de documento: No se incluirán clientes con documento "DNI", ya que en Colombia no es posible abrir cuentas bancarias solo con este documento.
3. Restricción para pasaportes: Los clientes con documento "Pasaporte" solo se incluirán si poseen una tarjeta de débito y su clasificación es "Personal", ya que las cuentas empresariales no están permitidas con este tipo de documento.

---

## Paso 3: Subconsulta - Filtrar Transacciones
```sql
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
```
### Explicación
Una vez se han filtrado los clientes, se procede a cruzarlos con la tabla de transacciones. Para este cruce, se tienen en cuenta las transacciones cuyo estado sea "Aprobada". Adicionalmente, se incluye una ventana temporal que permite establecer el rango de fechas para realizar la consulta, lo que otorga flexibilidad al análisis.

En el código presentado como ejemplo, se incluyen todas las transacciones sin limitar el rango de fechas, pero esta ventana puede ajustarse según las necesidades del análisis.

Por último, se filtran las transacciones considerando que las categorías de consumo válidas van únicamente del 1 al 60. Cualquier transacción con un código de categoría fuera de este rango se considera un error y es descartada del análisis.

---

## Paso 4: Subconsulta - Número de Transacciones por Categoría
```sql
transacciones_categoria AS(
	SELECT
			trx.IDENTIFICACION,
			trx.CODIGO_CATEGORIA,
			COUNT(1) AS TOTAL_TRANSACCIONES
	FROM transacciones_validas trx
	GROUP BY trx.IDENTIFICACION, trx.CODIGO_CATEGORIA
),
```

---

## Paso 5: Subconsulta - Asignar índice de nivel de preferencia 
```sql
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
```

---

## Paso 6: Subconsulta - Filtrar Niveles de Preferencia
```sql
numero_rank AS (
    SELECT
        cr.IDENTIFICACION,
        cr.CODIGO_CATEGORIA,
        cr.TOTAL_TRANSACCIONES,
        cr.PREFERENCIA_RANK
    FROM categoria_rank cr
    WHERE cr.PREFERENCIA_RANK >= 3
),
```
### Explicación
- En el 'WHERE' de esta consulta se puede modificar el valor, para generar uno o más niveles de preferencia

---

## Paso 7: Subconsulta - Fecha de Última Transacción 
```sql
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
```


---

## Paso 8: Consulta Final
```sql
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
    tv.NOMBRE ASC, ctn.PREFERENCIA_RANK ASC;
```
### Explicación
#### ¿Por qué se utiliza DISTINCT?
- Al unir ultima_transaccion con transacciones_validas, el mismo cliente y categoría pueden aparecer varias veces si hay múltiples transacciones con ese código en tv. Sin embargo, como ut ya identifica una sola transacción por cliente y categoría (la más reciente), solo se necesita un registro por combinación en el resultado final. Usar DISTINCT elimina estos duplicados y garantiza que solo se retorne un registro único por cliente, categoría y última transacción.

# Ejercicio 3 - Rachas


---

## 1. **Creación de Tablas**

```sql
CREATE TABLE HISTORIA (
    identificacion VARCHAR(30),
    corte_mes VARCHAR(15),
    saldo BIGINT
);

CREATE TABLE retiros (
    identificacion VARCHAR(30),
    fecha_retiro VARCHAR(15)
);
```


---

## 2. **Subconsulta: rango_fechas**

```sql
WITH rango_fechas AS (
    SELECT
        hist.identificacion,
        MAX(STR_TO_DATE(hist.corte_mes, '%d/%m/%Y')) AS fecha_maxima,
        MIN(STR_TO_DATE(hist.corte_mes, '%d/%m/%Y')) AS fecha_minima
    FROM historia hist
    GROUP BY hist.identificacion
)
```
- Se cambia el formato de las fecha de corte y se obtiene la fecha más antigua (`fecha_minima`) y la más reciente (`fecha_maxima`) por cada identificación en `HISTORIA`.

---

## 3. **Subconsulta: cambio_fecha**

```sql
cambio_fecha AS (
    SELECT 
        identificacion,
        STR_TO_DATE(
            REPLACE(REPLACE(...), 'dic', 'Dec'),
            '%d-%b-%y'
        ) AS fecha_retiro
    FROM retiros
)
```
- Convierte la columna `fecha_retiro` al formato de fecha utilizando reemplazos para meses abreviados en español a inglés.

---

## 4. **Subconsulta: retirados**

```sql
retirados AS (
    SELECT 
        r.identificacion,
        r.fecha_retiro AS fecha_maxima
    FROM cambio_fecha r
    WHERE r.identificacion IN (SELECT identificacion FROM rango_fechas)
)
```
- Filtra clientes en `RETIROS` que también están en `HISTORIA` ya que existen id en retiros que no tienen historia.
- Se toma la fecha de retiro como la nueva `fecha_maxima` para estos clientes.


---

## 5. **Subconsulta: max_min**

```sql
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
)
```
- Ajusta la fecha máxima de cada identificación. Si el usuario tiene fecha de retiro, se toma como la nueva fecha máxima.

---

## 6. **Subconsulta: historia_filtrada**

```sql
historia_filtrada AS (
    SELECT 
        h.identificacion,
        STR_TO_DATE(h.corte_mes, '%d/%m/%Y') AS fecha_corte,
        h.saldo
    FROM prueba2.historia h
    INNER JOIN max_min mm
        ON h.identificacion = mm.identificacion
    WHERE STR_TO_DATE(h.corte_mes, '%d/%m/%Y') <= mm.fecha_maxima
)
```
- Filtra los registros de la tabla `HISTORIA` que se encuentren dentro del rango de fechas válido (hasta la fecha máxima definida).

---

## 7. **Subconsulta: clasificacion**

```sql
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
)
```
- Clasifica cada registro según el saldo en niveles `N0` a `N4`.

---

## 8. **Subconsulta: seq**

```sql
seq AS (
    SELECT n FROM (
        SELECT 0 AS n UNION ALL SELECT 1 UNION ALL ... UNION ALL SELECT 35 
    ) num
)
```
- Genera una secuencia de números del 0 al 35 para representar 36 meses (3 años).

---

## 9. **Subconsulta: meses_faltantes**

```sql
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
)
```
- Completa los meses faltantes entre la fecha mínima y la fecha máxima con valores predeterminados (`saldo = 0`, `clasificacion = 'N0'`).

---

## 10. **Subconsulta: clasificacion_completa**

```sql
clasificacion_completa AS (
	SELECT * FROM clasificacion
	UNION ALL
	SELECT * FROM meses_faltantes
	ORDER BY identificacion, fecha_corte
)
```
- Combina la información de `clasificacion` con los meses faltantes, ordenándolos por identificación y fecha.

---

## 11. **Subconsulta: filtro_fecha**

```sql
filtro_fecha AS (
    SELECT 
        identificacion,
        fecha_corte,
        saldo,
        clasificacion
    FROM clasificacion_completa
    WHERE fecha_corte <= '2025-01-01'
)
```
- Filtra los registros hasta una fecha específica.

---

## 12. **Subconsulta: indice**

```sql
indice AS (
    SELECT 
        identificacion,
        fecha_corte,
        saldo,
        clasificacion,
        ROW_NUMBER() OVER (PARTITION BY identificacion ORDER BY fecha_corte) AS fila
    FROM filtro_fecha
)
```
- Asigna un número secuencial a cada registro según la fecha de corte dentro de cada identificación.

---

## 13. **Subconsulta: clasificacion_consecutiva**

```sql
clasificacion_consecutiva AS (
    SELECT 
        identificacion,
        fecha_corte,
        saldo,
        clasificacion,
        fila,
        fila - ROW_NUMBER() OVER (PARTITION BY identificacion, clasificacion ORDER BY fecha_corte) AS grupo
    FROM indice
)
```
- Agrupa clasificaciones consecutivas utilizando una diferencia entre filas y ROW_NUMBER().
- El valor grupo nos permite separar las rachas y ver cuándo cambian las clasificaciones.

---

## 14. **Subconsulta: filtro_racha**

```sql
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
)
```
- Calcula las rachas consecutivas para cada nivel de clasificación.
- En "HAVING COUNT(*) >= n" se puede seleccionar aquellas rachas que sean mayores o iguales a un número específico

---

## 15. **Subconsulta: racha_maxima**

```sql
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
```
- Obtiene la racha más larga para cada identificación.
- Las rachas iguales ya quedan ordenadas por fecha descendiente.

---

## 16. **Consulta Final**

```sql
SELECT 
    identificacion,
    racha,
    nivel,
    fecha_fin
FROM racha_maxima
WHERE ranking = 1;
```
- Devuelve la racha más larga de cada identificación junto con su nivel y fecha final.



