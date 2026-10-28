


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
