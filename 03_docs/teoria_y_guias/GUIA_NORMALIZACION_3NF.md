# 📘 Manual de Ingeniería: Normalización de Datos (3NF)

La normalización no es un capricho académico; es la técnica para evitar que tu base de datos pese 500GB cuando debería pesar 50GB.

## El Proceso Mental (Algoritmo de Normalización)

Estudia el archivo `raw_sales_dump.csv` y aplica estas reglas:

### Paso 1: Identificar Entidades (Objetos del Mundo Real)
Mira las columnas. ¿De qué hablan?
* `Cliente_Nombre`, `Cliente_Email`, `Cliente_Direccion` -> Hablan de **PERSONAS**.
* `Producto_Desc`, `Categoria`, `Precio` -> Hablan de **COSAS A LA VENTA**.
* `Sucursal`, `Ciudad` -> Hablan de **LUGARES**.
* `Fecha`, `Cantidad` -> Hablan de **EVENTOS (Transacciones)**.

**Acción:** Cada uno de estos grupos debe ser una TABLA separada.

### Paso 2: Eliminar Redundancias (2NF y 3NF)
Regla de oro: **"No repitas texto"**.

* *Caso:* Si "Laptop Gamer" aparece 1,000 veces en el CSV...
* *Solución:* Crea una tabla `Productos` donde "Laptop Gamer" aparezca **una sola vez** con ID 101. En la tabla de ventas, solo escribes `101`.

* *Caso:* Si tienes `Sucursal_Nombre` y `Sucursal_Ciudad`...
* *Análisis:* La ciudad depende de la sucursal. Si la sucursal "Norte" siempre está en "Bogotá", no repitas "Bogotá" en cada venta.
* *Solución:* Tabla `Sucursales` (ID, Nombre, Ciudad).

### Paso 3: Establecer Relaciones (FK)
La tabla `Ventas` será tu tabla de hechos (Fact Table). En lugar de texto, contendrá las llaves foráneas:
* `ClienteID` (apunta a Clientes)
* `ProductoID` (apunta a Productos)
* `SucursalID` (apunta a Sucursales)

---
### Checklist para tu DDL
1.  [ ] ¿Cada tabla tiene una PK (`Identity`)?
2.  [ ] ¿Usaste `VARCHAR` para texto y `DECIMAL` para dinero?
3.  [ ] ¿Si borro un cliente, la base de datos me lo impide si tiene ventas? (Constraint FK).
