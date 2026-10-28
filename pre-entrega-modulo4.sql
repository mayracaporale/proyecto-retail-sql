


-- CONSULTA 1: RENTABILIDAD POR CATEGORIA
-- Problema de negocio:
-- Identificar las categorias que generan mayores ingresos
-- por ventas y superan el umbral definido de $50.000.
-- Nota: se calcula ingreso por ventas, no ganancia neta,
-- porque el conjunto de datos no incluye costos de productos.









SELECT
    c.nombre_categoria AS categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * v.precio_unitario) AS ingreso_total
FROM ventas AS v
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS c
    ON p.id_categoria = c.id_categoria
GROUP BY
    c.id_categoria,
    c.nombre_categoria
HAVING SUM(v.cantidad * v.precio_unitario) > 50000
ORDER BY ingreso_total DESC;






-- CONSULTA 2: Clientes sin compras
-- Objetivo: identificar clientes registrados que todavía
-- no realizaron ninguna compra.

SELECT
    c.id_cliente,
    c.nombre,
    c.apellido,
    COALESCE(COUNT(v.id_venta), 0) AS cantidad_compras
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre,
    c.apellido
HAVING COUNT(v.id_venta) = 0
ORDER BY c.apellido, c.nombre;






-- CONSULTA 3: Producto más comprado por cliente
-- Objetivo: identificar qué producto compró cada cliente
-- con mayor frecuencia y cuándo realizó su última compra.

WITH ComprasPorProducto AS (
    SELECT
        c.id_cliente,
        c.nombre,
        c.apellido,
        p.id_producto,
        p.nombre AS producto,
        COUNT(v.id_venta) AS veces_comprado,
        SUM(v.cantidad) AS unidades_compradas
    FROM clientes AS c
    INNER JOIN ventas AS v
        ON c.id_cliente = v.id_cliente
    INNER JOIN productos AS p
        ON v.id_producto = p.id_producto
    GROUP BY
        c.id_cliente,
        c.nombre,
        c.apellido,
        p.id_producto,
        p.nombre
),
RankingProductos AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY id_cliente
            ORDER BY
                veces_comprado DESC,
                unidades_compradas DESC,
                id_producto ASC
        ) AS posicion
    FROM ComprasPorProducto
),
UltimaCompra AS (
    SELECT
        id_cliente,
        MAX(fecha_venta) AS ultima_fecha_compra
    FROM ventas
    GROUP BY id_cliente
)
SELECT
    r.nombre + ' ' + r.apellido AS cliente,
    r.producto,
    r.veces_comprado,
    r.unidades_compradas,
    u.ultima_fecha_compra
FROM RankingProductos AS r
INNER JOIN UltimaCompra AS u
    ON r.id_cliente = u.id_cliente
WHERE r.posicion = 1
ORDER BY cliente;
