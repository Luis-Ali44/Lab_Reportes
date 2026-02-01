-- View 1: view_top_users
CREATE INDEX  IF NOT EXISTS  idx_ordenes_usuario_id
ON ordenes(usuario_id);

--View 2: view_categorias_top
CREATE INDEX IF NOT EXISTS idx_productos_categoria_id
ON productos(categoria_id);

--View 3: view_analisis_productos
CREATE INDEX IF NOT EXISTS idx_orden_detalles_producto_id
ON orden_detalles(producto_id);

--View 4: view_estado_ordenes
CREATE INDEX IF NOT EXISTS idx_ordenes_status
ON ordenes(status);

--View 5: view_ventas_diarias
CREATE INDEX IF NOT EXISTS idx_ordenes_created_at
ON ordenes(created_at); 