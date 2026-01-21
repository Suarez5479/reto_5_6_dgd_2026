# Reto 5 y 6 – LegacyRetail

Este repositorio contiene el desarrollo de los Retos 5 y 6 del diplomado, enfocados en el diseño de bases de datos relacionales normalizadas y el análisis de rendimiento de consultas en SQL Server, utilizando un caso de estudio denominado *LegacyRetail*.

El objetivo principal del proyecto es demostrar la correcta aplicación de la Tercera Forma Normal (3FN) y evidenciar, mediante métricas reales, el impacto que tiene el diseño de la base de datos y la estructura de las consultas sobre el rendimiento del motor de SQL Server.

---

## Objetivos del proyecto

- Normalizar un conjunto de datos desestructurados hasta la Tercera Forma Normal (3FN).
- Diseñar un modelo relacional consistente y con integridad referencial.
- Cargar datos de forma controlada desde una tabla de staging.
- Analizar el impacto de diferentes tipos de consultas sobre el rendimiento del sistema.
- Documentar el proceso técnico y los resultados obtenidos.

---

## Estructura del repositorio

La organización del repositorio es la siguiente:

<img width="339" height="629" alt="image" src="https://github.com/user-attachments/assets/00c38990-c2f5-4ae9-aba4-6f4edc3c1b11" />


---

## Descripción de carpetas

### 01_data
Contiene el archivo de datos original en formato CSV, el cual representa un volcado de ventas sin normalizar. Este archivo fue utilizado como fuente de datos para la carga inicial en la tabla de staging.

### 02_sql
Incluye los scripts SQL desarrollados durante el proyecto, entre ellos:
- Limpieza y eliminación de tablas previas.
- Creación del modelo relacional normalizado a 3FN.
- Inserción de datos limpios en tablas dimensionales y de hechos.
- Consultas utilizadas para el análisis de rendimiento y comparación entre distintos tipos de joins.

### 03_docs
Contiene la documentación del proyecto y los entregables finales:
- Reporte técnico en formato Markdown y PDF.
- Capturas de pantalla que evidencian la ejecución de los scripts y los resultados obtenidos.
- Diagrama Entidad–Relación (DER) del modelo final implementado.

---

## Alcance técnico

El desarrollo del proyecto abarca los siguientes aspectos:

- Normalización del modelo de datos hasta la Tercera Forma Normal (3FN).
- Eliminación de redundancias y dependencias innecesarias.
- Implementación de claves primarias y foráneas para garantizar la integridad referencial.
- Comparación de consultas utilizando `CROSS JOIN` e `INNER JOIN`.
- Evaluación del impacto de cada consulta mediante métricas de lecturas lógicas y tiempo de ejecución usando `SET STATISTICS IO` y `SET STATISTICS TIME`.

---

## Consideraciones y aprendizajes

Durante el desarrollo se identificaron algunas dificultades relacionadas con la carga de datos y la correcta asociación de claves foráneas, las cuales fueron resueltas mediante limpieza de datos y validación previa de relaciones. Asimismo, el análisis de rendimiento permitió evidenciar cómo una consulta mal estructurada puede afectar significativamente el consumo de recursos del motor de base de datos.

Este ejercicio permitió reforzar la importancia de un diseño adecuado desde las primeras etapas del desarrollo, así como la necesidad de analizar el rendimiento de las consultas más allá de su resultado funcional.

---

## Conclusión

El proyecto demuestra que un modelo de datos bien normalizado no solo mejora la organización y consistencia de la información, sino que también tiene un impacto directo en el rendimiento y la eficiencia del sistema. El análisis comparativo de consultas evidencia la relevancia de utilizar correctamente las relaciones entre tablas y de evaluar el comportamiento del motor mediante métricas objetivas.

---

## Autor

Karen Suarez  
Diplomado en Gestión de Datos  
2026

