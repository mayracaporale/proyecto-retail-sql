
-- PROYECTO RETAIL
-- Motor: Microsoft SQL Server
-- Objetivo: crear tablas, insertar datos y practicar UPDATE y DELETE.

-- 1. Crear la base de datos
IF DB_ID('retail_project') IS NULL
BEGIN
    CREATE DATABASE retail_project;
END;
GO

USE retail_project;
GO

-- 2. Crear tabla de clientes
IF OBJECT_ID('dbo.clientes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.clientes (
        id_cliente INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        apellido VARCHAR(100) NOT NULL,
        email VARCHAR(150) NOT NULL UNIQUE,
        edad INT NOT NULL,
        CONSTRAINT CK_clientes_edad
            CHECK (edad >= 18 AND edad <= 110)
    );
END;
GO

-- 3. Crear tabla de productos
IF OBJECT_ID('dbo.productos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.productos (
        id_producto INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        categoria VARCHAR(50) NOT NULL,
        precio DECIMAL(10,2) NOT NULL,
        stock INT NOT NULL,
        CONSTRAINT CK_productos_precio CHECK (precio > 0),
        CONSTRAINT CK_productos_stock CHECK (stock >= 0)
    );
END;
GO

-- 4. Crear tabla de ventas con claves foráneas
IF OBJECT_ID('dbo.ventas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ventas (
        id_venta INT IDENTITY(1,1) PRIMARY KEY,
        id_cliente INT NOT NULL,
        id_producto INT NOT NULL,
        cantidad INT NOT NULL,
        fecha_venta DATE NOT NULL,
        precio_unitario DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_ventas_clientes
            FOREIGN KEY (id_cliente)
            REFERENCES dbo.clientes(id_cliente),
        CONSTRAINT FK_ventas_productos
            FOREIGN KEY (id_producto)
            REFERENCES dbo.productos(id_producto),
        CONSTRAINT CK_ventas_cantidad CHECK (cantidad > 0),
        CONSTRAINT CK_ventas_precio CHECK (precio_unitario > 0)
    );
END;
GO

-- 5. Insertar cinco registros iniciales por tabla
BEGIN TRY
    BEGIN TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM dbo.clientes)
    BEGIN
        INSERT INTO dbo.clientes
            (nombre, apellido, email, edad)
        VALUES
            ('Lucia', 'Gomez', 'lucia.gomez@email.com', 29),
            ('Mateo', 'Perez', 'mateo.perez@email.com', 35),
            ('Sofia', 'Ramirez', 'sofia.ramirez@email.com', 42),
            ('Tomas', 'Fernandez', 'tomas.fernandez@email.com', 24),
            ('Valentina', 'Lopez', 'valentina.lopez@email.com', 31);
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.productos)
    BEGIN
        INSERT INTO dbo.productos
            (nombre, categoria, precio, stock)
        VALUES
            ('Teclado inalambrico', 'Accesorios', 18500.00, 40),
            ('Mouse optico', 'Accesorios', 9500.00, 75),
            ('Monitor 24 pulgadas', 'Monitores', 185000.00, 18),
            ('Notebook 15 pulgadas', 'Computacion', 850000.00, 10),
            ('Soporte para notebook', 'Accesorios', 22000.00, 30);
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.ventas)
    BEGIN
        INSERT INTO dbo.ventas
            (id_cliente, id_producto, cantidad,
             fecha_venta, precio_unitario)
        VALUES
            (1, 1, 1, '2026-02-01', 18500.00),
            (2, 2, 2, '2026-02-03', 9500.00),
            (3, 3, 1, '2026-02-05', 185000.00),
            (4, 5, 1, '2026-02-07', 22000.00),
            (5, 4, 1, '2026-02-09', 850000.00);
    END;

    -- 6. Ver precios de Accesorios antes de actualizarlos
    SELECT id_producto, nombre, categoria, precio
    FROM dbo.productos
    WHERE categoria = 'Accesorios';

    -- 7. Actualizar precios de productos de Accesorios
    UPDATE dbo.productos
    SET precio =
        CASE nombre
            WHEN 'Teclado inalambrico' THEN 19425.00
            WHEN 'Mouse optico' THEN 9975.00
            WHEN 'Soporte para notebook' THEN 23100.00
            ELSE precio
        END
    WHERE categoria = 'Accesorios'
      AND nombre IN (
          'Teclado inalambrico',
          'Mouse optico',
          'Soporte para notebook'
      );

    -- 8. Verificar los precios después del UPDATE
    SELECT id_producto, nombre, categoria, precio
    FROM dbo.productos
    WHERE categoria = 'Accesorios';

    -- 9. Insertar una venta temporal de prueba
    DECLARE @id_venta_prueba INT;

    INSERT INTO dbo.ventas
        (id_cliente, id_producto, cantidad,
         fecha_venta, precio_unitario)
    VALUES
        (1, 1, 1, '2026-02-10', 18500.00);

    SET @id_venta_prueba = CONVERT(INT, SCOPE_IDENTITY());

    -- 10. Comprobar la venta antes de eliminarla
    SELECT *
    FROM dbo.ventas
    WHERE id_venta = @id_venta_prueba;

    -- 11. Eliminar solamente la venta temporal
    DELETE FROM dbo.ventas
    WHERE id_venta = @id_venta_prueba;

    -- 12. Comprobar que la venta ya no existe
    SELECT *
    FROM dbo.ventas
    WHERE id_venta = @id_venta_prueba;

    COMMIT TRANSACTION;
    PRINT 'Proceso completado correctamente.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

-- 13. Consultas finales para verificar las tres tablas
SELECT * FROM dbo.clientes;
SELECT * FROM dbo.productos;
SELECT * FROM dbo.ventas;
GO
