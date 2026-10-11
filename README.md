# Proyecto Retail SQL

# Descripción del proyecto

Este proyecto consiste en el diseño y la creación de una base de datos para un negocio de retail, utilizando SQL Server. El objetivo es organizar la información de clientes, productos y ventas, aplicando claves primarias, claves foráneas y restricciones para mantener la integridad de los datos.

# Tecnologías utilizadas

- SQL Server
- SQL Server Management Studio (SSMS)
- Lenguaje SQL

# Estructura de la base de datos

La base de datos se llama `retail_project` y contiene tres tablas principales:

- **clientes:** almacena el nombre, apellido, correo electrónico y edad de cada cliente.
- **productos:** almacena el nombre, categoría, precio y stock de los productos.
- **ventas:** registra las ventas realizadas, relacionando clientes y productos mediante claves foráneas.

# Restricciones implementadas

Se incorporaron las siguientes restricciones para garantizar la calidad de los datos:

- Claves primarias para identificar cada registro.
- Claves foráneas para relacionar las ventas con clientes y productos.
- Correo electrónico único y obligatorio para cada cliente.
- Validación de edad de los clientes.
- Validación para que los precios sean mayores que cero.
- Validación para que el stock no sea negativo.
- Validación para que la cantidad y el precio unitario de cada venta sean mayores que cero.

# Datos y operaciones

El archivo `retail_project.sql` incluye:

- Creación de la base de datos y las tres tablas.
- Inserción de datos iniciales de clientes, productos y ventas.
- Uso de una transacción para ejecutar las operaciones de carga y mantenimiento.
- Actualización de precios de productos de la categoría Accesorios.
- Inserción y eliminación controlada de una venta de prueba.
- Consultas `SELECT` para verificar los datos.

# Cómo ejecutar el proyecto

1. Abrir SQL Server Management Studio.
2. Conectarse a la instancia de SQL Server.
3. Abrir el archivo `retail_project.sql`.
4. Ejecutar el script completo.
5. Revisar los resultados de las consultas de verificación.



