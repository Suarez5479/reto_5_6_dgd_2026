/* =========================================================
   DISEÑO RELACIONAL NORMALIZADO (3NF)
   LegacyRetail SA
   ========================================================= */

-- Limpieza previa (orden correcto por FKs)
-- Limpieza segura (orden por dependencias)
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Sucursales;
GO


/* =========================================================
   TABLA: Clientes
   ========================================================= */
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL
);
GO

CREATE TABLE Sucursales (
    SucursalID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ciudad VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Ventas (
    VentaID INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE NOT NULL,
    Cantidad INT NOT NULL,
    ClienteID INT NOT NULL,
    ProductoID INT NOT NULL,
    SucursalID INT NOT NULL,
    CONSTRAINT FK_Venta_Clientes FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    CONSTRAINT FK_Venta_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    CONSTRAINT FK_Venta_Sucursales FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID)
);
GO

DROP TABLE IF EXISTS RawVentas;
GO


SELECT name
FROM sys.tables;

USE LegacyRetail;
GO

----------------------------------------------------
-- 1. LIMPIEZA TOTAL
----------------------------------------------------
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Sucursales;
DROP TABLE IF EXISTS RawVentas;
GO

----------------------------------------------------
-- 2. STAGING
----------------------------------------------------
CREATE TABLE RawVentas (
    Transaccion_ID INT,
    Cliente_Nombre VARCHAR(100),
    Cliente_Email VARCHAR(100),
    Producto VARCHAR(100),
    Categoria VARCHAR(50),
    Sucursal VARCHAR(100),
    Ciudad_Sucursal VARCHAR(100),
    Fecha_Venta DATE,
    Cantidad INT,
    Precio_Unitario DECIMAL(12,2)
);
GO

----------------------------------------------------
-- 3. CARGA CSV
----------------------------------------------------
BULK INSERT RawVentas
FROM '/var/opt/mssql/data/raw_sales_dump.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

----------------------------------------------------
-- 4. TABLAS DIMENSIONALES
----------------------------------------------------
CREATE TABLE Clientes (
    ClienteID INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);
GO

CREATE TABLE Productos (
    ProductoID INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100),
    Categoria VARCHAR(50),
    UNIQUE (Nombre)
);
GO

CREATE TABLE Sucursales (
    SucursalID INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100),
    Ciudad VARCHAR(100),
    UNIQUE (Nombre, Ciudad)
);
GO

----------------------------------------------------
-- 5. TABLA DE HECHOS
----------------------------------------------------
CREATE TABLE Ventas (
    VentaID INT IDENTITY PRIMARY KEY,
    Fecha DATE,
    Cantidad INT,
    Precio_Unitario DECIMAL(12,2),
    ClienteID INT,
    ProductoID INT,
    SucursalID INT,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID)
);
GO

----------------------------------------------------
-- 6. CARGA LIMPIA
----------------------------------------------------

-- CLIENTES (EMAIL ES LA CLAVE)
INSERT INTO Clientes (Nombre, Email)
SELECT DISTINCT
    MAX(LTRIM(RTRIM(Cliente_Nombre))),
    LOWER(LTRIM(RTRIM(Cliente_Email)))
FROM RawVentas
GROUP BY LOWER(LTRIM(RTRIM(Cliente_Email)));
GO

-- PRODUCTOS
INSERT INTO Productos (Nombre, Categoria)
SELECT DISTINCT
    LTRIM(RTRIM(Producto)),
    LTRIM(RTRIM(Categoria))
FROM RawVentas;
GO

-- SUCURSALES
INSERT INTO Sucursales (Nombre, Ciudad)
SELECT DISTINCT
    LTRIM(RTRIM(Sucursal)),
    LTRIM(RTRIM(Ciudad_Sucursal))
FROM RawVentas;
GO

----------------------------------------------------
-- 7. VENTAS (JOIN SEGURO)
----------------------------------------------------
INSERT INTO Ventas (Fecha, Cantidad, Precio_Unitario, ClienteID, ProductoID, SucursalID)
SELECT
    r.Fecha_Venta,
    r.Cantidad,
    r.Precio_Unitario,
    c.ClienteID,
    p.ProductoID,
    s.SucursalID
FROM RawVentas r
JOIN Clientes c
  ON LOWER(LTRIM(RTRIM(r.Cliente_Email))) = c.Email
JOIN Productos p
  ON LTRIM(RTRIM(r.Producto)) = p.Nombre
JOIN Sucursales s
  ON LTRIM(RTRIM(r.Sucursal)) = s.Nombre
 AND LTRIM(RTRIM(r.Ciudad_Sucursal)) = s.Ciudad;
GO

----------------------------------------------------
-- 8. VALIDACIÓN FINAL
----------------------------------------------------
SELECT COUNT(*) AS RawVentas FROM RawVentas;   -- 200
SELECT COUNT(*) AS Clientes FROM Clientes;     -- 21
SELECT COUNT(*) AS Productos FROM Productos;   -- 12
SELECT COUNT(*) AS Sucursales FROM Sucursales; -- 5
SELECT COUNT(*) AS Ventas FROM Ventas;         -- 200
GO

EXEC sp_help Ventas;
