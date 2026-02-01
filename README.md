# Lab Reportes

**Materia:** Base de Datos Avanzadas  
**Actividad:** Lab Reportes - Dashboard con Next.js  
**Autor:** Luis Ali  

---

## Descripción

Dashboard para visualizar reportes SQL. Usa Next.js en el frontend y PostgreSQL con 5 views en el backend. Todo corre con Docker Compose.



## Cómo ejecutar

```bash
git clone https://github.com/Luis-Ali44/Lab_Reportes.git
cd Lab_Reportes
docker compose up --build
```

Abrir **http://localhost:3000**



## Índices

| Índice | Tabla | Columna | Por qué |
|--------|-------|---------|---------|
| `idx_ordenes_usuario_id` | ordenes | usuario_id | JOIN en view_top_users |
| `idx_productos_categoria_id` | productos | categoria_id | JOIN en view_categorias_top |
| `idx_orden_detalles_producto_id` | orden_detalles | producto_id | JOIN en view_analisis_productos |
| `idx_ordenes_status` | ordenes | status | GROUP BY en view_estado_ordenes |
| `idx_ordenes_created_at` | ordenes | created_at | GROUP BY DATE en view_ventas_diarias |

 
En teoria es mas rapido por que en lugar de leer toda la tabla buscadno por ejemplo el id de un usuario, debeira de ir directo si ya conoce su id 
pero al ser una tabla muy pequeña, la base decide leer toda la tabla



