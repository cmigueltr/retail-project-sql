# retail-project-sql

Script inicial de PostgreSQL para crear clientes, productos y ventas, aplicar restricciones y cargar datos de ejemplo.

Cómo ejecutarlo:

1. Crear una base de datos llamada retail_project.
2. Conectarse a esa base desde pgAdmin, DBeaver o psql.
3. Abrir y ejecutar el archivo script.sql completo.
4. Comprobar los tres resultados de SELECT COUNT(*) al final.
   
Desde la terminal, si se utiliza psql:
psql -U postgres -d retail_project -f script.sql

Qué incluye
- Claves primarias en las tres tablas.
- Email único y no nulo, con una validación básica de formato.
- Precio mayor que cero y stock no negativo.
- Dos claves foráneas en ventas, con ON DELETE RESTRICT.
- Cantidad de venta mayor que cero.
- Inserts dentro de BEGIN y COMMIT.
- UPDATE y DELETE con WHERE, precedidos por consultas de revisión.
- 
Resultado esperado
Al finalizar: 5 clientes, 5 productos y 5 ventas.
