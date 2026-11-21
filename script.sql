-- Proyecto RETAIL | PostgreSQL
-- Ejecutar dentro de una base de datos previamente creada: retail_project

-- 1. Tablas independientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(25),
    CONSTRAINT chk_clientes_email
        CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_productos_precio CHECK (precio > 0),
    CONSTRAINT chk_productos_stock CHECK (stock >= 0)
);

-- 2. Tabla dependiente: se crea después de clientes y productos
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    fecha_venta DATE NOT NULL DEFAULT CURRENT_DATE,
    cantidad INTEGER NOT NULL,
    observaciones VARCHAR(200),
    CONSTRAINT fk_ventas_clientes FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_productos FOREIGN KEY (id_producto)
        REFERENCES productos (id_producto) ON DELETE RESTRICT,
    CONSTRAINT chk_ventas_cantidad CHECK (cantidad > 0)
);

-- 3. Carga inicial dentro de una transacción explícita
BEGIN;

INSERT INTO clientes (nombre, email, telefono) VALUES
('Ana Pérez', 'ana.perez@email.com', '11-4000-1001'),
('Bruno Gómez', 'bruno.gomez@email.com', '11-4000-1002'),
('Carla Díaz', 'carla.diaz@email.com', '11-4000-1003'),
('Diego López', 'diego.lopez@email.com', '11-4000-1004'),
('Elena Ruiz', 'elena.ruiz@email.com', '11-4000-1005');

INSERT INTO productos (nombre, precio, stock) VALUES
('Notebook 15 pulgadas', 850000.00, 12),
('Mouse inalámbrico', 18500.00, 50),
('Teclado mecánico', 72000.00, 25),
('Monitor 24 pulgadas', 210000.00, 10),
('Auriculares', 45000.00, 30);

-- Cinco ventas reales y una venta temporal de prueba
INSERT INTO ventas (id_cliente, id_producto, fecha_venta, cantidad, observaciones) VALUES
(1, 1, '2026-11-01', 1, 'Venta mostrador'),
(2, 2, '2026-11-02', 2, 'Compra web'),
(3, 3, '2026-11-03', 1, 'Retiro en local'),
(4, 4, '2026-11-04', 1, 'Compra web'),
(5, 5, '2026-11-05', 1, 'Venta mostrador'),
(1, 2, '2026-11-06', 1, 'REGISTRO DE PRUEBA - ELIMINAR');

-- 4. UPDATE masivo: revisar primero las filas afectadas
SELECT id_producto, nombre, precio
FROM productos
WHERE nombre IN ('Mouse inalámbrico', 'Auriculares');

UPDATE productos
SET precio = ROUND(precio * 1.05, 2)
WHERE nombre IN ('Mouse inalámbrico', 'Auriculares');

-- 5. DELETE: revisar primero el registro de prueba
SELECT id_venta, id_cliente, id_producto, observaciones
FROM ventas
WHERE observaciones = 'REGISTRO DE PRUEBA - ELIMINAR';

DELETE FROM ventas
WHERE observaciones = 'REGISTRO DE PRUEBA - ELIMINAR';

COMMIT;

-- 6. Verificación final: deben quedar 5 registros en cada tabla
SELECT COUNT(*) AS total_clientes FROM clientes;
SELECT COUNT(*) AS total_productos FROM productos;
SELECT COUNT(*) AS total_ventas FROM ventas;
