# Proyecto Retail SQL

## Descripción del proyecto

Este proyecto consiste en diseñar y crear una base de datos para un negocio de retail utilizando Microsoft SQL Server. El objetivo es organizar la información de clientes, productos y ventas, aplicando claves primarias, claves foráneas y restricciones para mantener la integridad de los datos.

## Objetivos de aprendizaje

- Crear una base de datos y sus tablas.
- Definir claves primarias y relaciones entre tablas.
- Aplicar restricciones para validar los datos.
- Insertar, actualizar y eliminar registros de forma controlada.
- Utilizar transacciones y consultas `SELECT` para comprobar los resultados.

## Tecnologías utilizadas

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Lenguaje SQL

## Estructura de la base de datos

La base de datos se llama `retail_project` y contiene tres tablas principales:

- **clientes:** almacena nombre, apellido, correo electrónico y edad.
- **productos:** almacena nombre, categoría, precio y stock.
- **ventas:** registra las ventas, relacionando clientes y productos mediante claves foráneas.

## Restricciones implementadas

- Claves primarias para identificar cada registro.
- Claves foráneas para relacionar las ventas con clientes y productos.
- Correo electrónico obligatorio y único para cada cliente.
- Validación de edad entre 18 y 110 años.
- Validación para que los precios sean mayores que cero.
- Validación para que el stock no sea negativo.
- Validación para que la cantidad y el precio unitario de cada venta sean mayores que cero.

## Datos y operaciones

El archivo `retail_project.sql` incluye:

- Creación de la base de datos y las tres tablas.
- Inserción de cinco registros iniciales por tabla.
- Uso de una transacción con `BEGIN TRANSACTION` y `COMMIT`.
- Actualización de precios de productos de la categoría Accesorios.
- Inserción y eliminación controlada de una venta de prueba.
- Consultas `SELECT` para verificar los resultados antes y después de los cambios.

## Decisiones técnicas

Como el proyecto se desarrolla en SQL Server, se utiliza `IDENTITY(1,1)` para generar automáticamente los identificadores de los registros. También se utilizan restricciones `CHECK`, `UNIQUE`, `NOT NULL` y claves foráneas para mantener la consistencia de los datos.

## Cómo ejecutar el proyecto

1. Abrir SQL Server Management Studio.
2. Conectarse a la instancia de SQL Server.
3. Abrir el archivo `retail_project.sql`.
4. Ejecutar el script completo.
5. Revisar los resultados de las consultas de verificación.

## Aprendizajes

Con este proyecto practiqué los conceptos básicos de SQL, la creación de tablas relacionadas, la validación de datos y las operaciones de mantenimiento de una base de datos. También aprendí a utilizar SQL Server Management Studio para ejecutar consultas y comprobar resultados.

## Archivos del repositorio

- `retail_project.sql`: contiene el código SQL del proyecto.
- `README.md`: describe el proyecto, su estructura y los pasos para ejecutarlo.
