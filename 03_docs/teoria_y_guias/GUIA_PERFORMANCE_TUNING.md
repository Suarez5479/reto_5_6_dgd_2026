# 🚀 Manual de Tuning: Joins y Métricas

En este reto medirás la latencia y el costo de I/O (Input/Output).

## El Enemigo: Producto Cartesiano (CROSS JOIN)
Imagina que tienes 2 mazos de cartas.
* Mazo A: 50 cartas.
* Mazo B: 50 cartas.
Si te pido "Combina cada carta del mazo A con cada carta del mazo B", obtendrás:
`50 x 50 = 2,500 combinaciones`.

Ahora imagina Clientes (10,000) y Productos (5,000).
`10,000 x 5,000 = 50,000,000 de filas`.
SQL Server tiene que generar 50 millones de filas en memoria. Esto es lo que mata al servidor.

## El Aliado: INNER JOIN
El Inner Join es quirúrgico. Solo busca las cartas que coinciden.
"Dame las cartas del Mazo A que tengan el mismo número en el Mazo B".
Resultado: Tal vez solo 50 filas.

## Cómo medir la evidencia (Set Statistics)

En SQL Server, antes de tu consulta, ejecuta:
```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

```

Luego, mira la pestaña **Messages**. Busca esto:

> *Table 'Ventas'. Scan count 1, logical reads 50.*

* **Logical Reads:** Número de páginas de 8KB leídas de la memoria.
* Menos es mejor.
* Un Cross Join tendrá lecturas exponenciales.
* Un Inner Join bien indexado tendrá lecturas lineales o logarítmicas.



**Tu reporte debe mostrar la diferencia abismal entre estos dos números.**
