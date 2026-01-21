USE LegacyRetail;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT
    c.Nombre AS Cliente,
    p.Nombre AS Producto
FROM Clientes c
CROSS JOIN Productos p;
GO

SELECT
    c.Nombre AS Cliente,
    p.Nombre AS Producto,
    v.Fecha,
    v.Cantidad
FROM Ventas v
INNER JOIN Clientes c
    ON v.ClienteID = c.ClienteID
INNER JOIN Productos p
    ON v.ProductoID = p.ProductoID;
GO

-- Conteo cartesiano
SELECT COUNT(*) AS Total_Cross
FROM Clientes c
CROSS JOIN Productos p;
GO

-- Conteo real
SELECT COUNT(*) AS Total_Inner
FROM Ventas;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
