
-- =============================================
-- PROYECTO RETAIL - SQL SERVER
-- Pre-entrega: Tablas, restricciones y datos
-- =============================================

-- 1. CREAR LA BASE DE DATOS
IF DB_ID('retail_project') IS NULL
BEGIN
    CREATE DATABASE retail_project;
END;
GO

USE retail_project;
GO

-- 2. CREAR TABLA CLIENTES
IF OBJECT_ID('dbo.clientes', 'U') IS NULL
BEGIN
    CREATE TABLE clientes (
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

-- 3. CREAR TABLA PRODUCTOS
IF OBJECT_ID('dbo.productos', 'U') IS NULL
BEGIN
    CREATE TABLE productos (
        id_producto INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        categoria VARCHAR(50) NOT NULL,
        precio DECIMAL(10,2) NOT NULL,
        stock INT NOT NULL,
        CONSTRAINT CK_productos_precio
            CHECK (precio > 0),
        CONSTRAINT CK_productos_stock
            CHECK (stock >= 0)
    );
END;
GO

-- 4. CREAR TABLA VENTAS AL FINAL
IF OBJECT_ID('dbo.ventas', 'U') IS NULL
BEGIN
    CREATE TABLE ventas (
        id_venta INT IDENTITY(1,1) PRIMARY KEY,
        id_cliente INT NOT NULL,
        id_producto INT NOT NULL,
        cantidad INT NOT NULL,
        fecha_venta DATE NOT NULL,
        precio_unitario DECIMAL(10,2) NOT NULL,

        CONSTRAINT FK_ventas_clientes
            FOREIGN KEY (id_cliente)
            REFERENCES clientes(id_cliente),

        CONSTRAINT FK_ventas_productos
            FOREIGN KEY (id_producto)
            REFERENCES productos(id_producto),

        CONSTRAINT CK_ventas_cantidad
            CHECK (cantidad > 0),

        CONSTRAINT CK_ventas_precio
            CHECK (precio_unitario > 0)
    );
END;
GO

-- 5. CARGA INICIAL Y MANTENIMIENTO
BEGIN TRY
    BEGIN TRANSACTION;

    -- CLIENTES: cinco registros iniciales
    IF NOT EXISTS (SELECT 1 FROM clientes)
    BEGIN
        INSERT INTO clientes
            (nombre, apellido, email, edad)
        VALUES
            ('Lucia', 'Gomez', 'lucia.gomez@email.com', 29),
            ('Mateo', 'Perez', 'mateo.perez@email.com', 35),
            ('Sofia', 'Ramirez', 'sofia.ramirez@email.com', 42),
            ('Tomas', 'Fernandez', 'tomas.fernandez@email.com', 24),
            ('Valentina', 'Lopez', 'valentina.lopez@email.com', 31);
    END;

    -- PRODUCTOS: cinco registros iniciales
    IF NOT EXISTS (SELECT 1 FROM productos)
    BEGIN
        INSERT INTO productos
            (nombre, categoria, precio, stock)
        VALUES
            ('Teclado inalambrico', 'Accesorios', 18500.00, 40),
            ('Mouse optico', 'Accesorios', 9500.00, 75),
            ('Monitor 24 pulgadas', 'Monitores', 185000.00, 18),
            ('Notebook 15 pulgadas', 'Computacion', 850000.00, 10),
            ('Soporte para notebook', 'Accesorios', 22000.00, 30);
    END;

    -- VENTAS: cinco registros iniciales
    IF NOT EXISTS (SELECT 1 FROM ventas)
    BEGIN
        INSERT INTO ventas
            (id_cliente, id_producto, cantidad,
             fecha_venta, precio_unitario)
        VALUES
            (1, 1, 1, '2026-02-01', 18500.00),
            (2, 2, 2, '2026-02-03', 9500.00),
            (3, 3, 1, '2026-02-05', 185000.00),
            (4, 5, 1, '2026-02-07', 22000.00),
            (5, 4, 1, '2026-02-09', 850000.00);
    END;

    -- 6. UPDATE: actualizar precios de Accesorios
    -- Los valores quedan definidos para evitar
    -- aumentarlos repetidamente al ejecutar el script.
    UPDATE productos
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

    -- 7. DELETE: crear y eliminar una venta de prueba
    DECLARE @id_venta_prueba INT;

    INSERT INTO ventas
        (id_cliente, id_producto, cantidad,
         fecha_venta, precio_unitario)
    VALUES
        (1, 1, 1, '2026-02-10', 18500.00);

    SET @id_venta_prueba = SCOPE_IDENTITY();

    DELETE FROM ventas
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

-- 8. CONSULTAS DE VERIFICACION
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;
GO
