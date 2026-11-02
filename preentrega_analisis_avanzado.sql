-- ==========================================================
-- PRE-ENTREGA: ANALISIS AVANZADO CON WINDOW FUNCTIONS
-- Base de datos: retail_project
-- Motor: SQL Server
-- NOTA: La base contiene ventas originales y datos simulados.
-- ==========================================================

USE retail_project;
GO

-- 1. CTE: VENTAS MENSUALES
-- Agrupa las ventas por mes y categoria.

WITH ventas_mensuales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(v.fecha_venta),
            MONTH(v.fecha_venta),
            1
        ) AS mes,
        p.categoria,
        SUM(v.cantidad * v.precio_unitario) AS total_ventas
    FROM ventas AS v
    INNER JOIN productos AS p
        ON v.id_producto = p.id_producto
    GROUP BY
        DATEFROMPARTS(
            YEAR(v.fecha_venta),
            MONTH(v.fecha_venta),
            1
        ),
        p.categoria
),

-- 2. CTE: METRICAS_VENTANA
-- Calcula ranking mensual y ventas acumuladas por categoria.

metricas_ventana AS (
    SELECT
        mes,
        categoria,
        total_ventas,

        RANK() OVER (
            PARTITION BY mes
            ORDER BY total_ventas DESC
        ) AS ranking_categoria,

        SUM(total_ventas) OVER (
            PARTITION BY categoria
            ORDER BY mes
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS ventas_acumuladas

    FROM ventas_mensuales
),

-- 3. CTE: PROMEDIO_CATEGORIA
-- Calcula el promedio mensual disponible por categoria.

promedio_categoria AS (
    SELECT
        categoria,
        AVG(total_ventas) AS promedio_historico
    FROM ventas_mensuales
    GROUP BY categoria
)

-- 4. SELECT FINAL
-- Compara las ventas mensuales con el promedio historico.

SELECT
    CONVERT(CHAR(7), m.mes, 120) AS mes_venta,
    m.categoria,
    m.total_ventas,
    m.ranking_categoria,
    m.ventas_acumuladas,
    pc.promedio_historico,

    CASE
        WHEN m.total_ventas >= pc.promedio_historico
            THEN 'Exitoso'
        ELSE 'Bajo el promedio'
    END AS resultado_ventas

FROM metricas_ventana AS m
INNER JOIN promedio_categoria AS pc
    ON m.categoria = pc.categoria

ORDER BY
    m.mes,
    m.ranking_categoria;