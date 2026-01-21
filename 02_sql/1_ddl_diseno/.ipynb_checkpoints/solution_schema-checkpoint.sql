/*
RETO PARTE A: DISEÑO DEL ESQUEMA RELACIONAL
Estudiante: Karen Juliana Suárez Cruz
Fecha: Enero 2026
*/

-- =======================================================
-- 1. TABLAS MAESTRAS
-- =======================================================

-- ======================
-- TABLA CLIENTE
-- ======================
CREATE TABLE Cliente (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

-- ======================
-- TABLA PRODUCTO
-- ======================
CREATE TABLE Producto (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL
);

-- ======================
-- TABLA SUCURSAL
-- ======================
CREATE TABLE Sucursal (
    SucursalID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ciudad VARCHAR(100) NOT NULL
);

-- =======================================================
-- 2. TABLA TRANSACCIONAL
-- =======================================================

-- ======================
-- TABLA VENTA
-- ======================
CREATE TABLE Venta (
    VentaID INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE NOT NULL,
    Cantidad INT NOT NULL,

    ClienteID INT NOT NULL,
    ProductoID INT NOT NULL,
    SucursalID INT NOT NULL,

    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (ClienteID)
        REFERENCES Cliente(ClienteID),

    CONSTRAINT FK_Venta_Producto FOREIGN KEY (ProductoID)
        REFERENCES Producto(ProductoID),

    CONSTRAINT FK_Venta_Sucursal FOREIGN KEY (SucursalID)
        REFERENCES Sucursal(SucursalID)
);
