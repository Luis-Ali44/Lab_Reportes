# Lab Reportes

**Materia:** Base de Datos Avanzadas  
**Actividad:** Lab Reportes - Dashboard con Next.js  
**Autor:** Luis Ali  

---

## Descripción

Dashboard para visualizar reportes SQL. Usa Next.js en el frontend y PostgreSQL con 5 views en el backend. Todo corre con Docker Compose.

### Tablas: 

- **Usuarios** - Clientes registrados
- **Categorías** - Clasificación de productos
- **Productos** - Productos en venta
- **Órdenes** - Pedidos de los usuarios
- **Orden Detalles** - Detalle de cada pedido

---

## Cómo ejecutar

```bash
git clone https://github.com/Luis-Ali44/Lab_Reportes.git
cd Lab_Reportes
docker compose up --build
```

Abrir **http://localhost:3000**

---

## Estructura

```
LapReport/
├── db/
│   ├── 01_schema.sql      # Tablas
│   ├── 02_seed.sql        # Datos de prueba
│   ├── 03_migrate.sql     # Migraciones
│   │                      #Estos 3 .sql los obtuve de als actividades anteriores
│   │
│   ├── 04_reports_vw.sql  # Las 5 views
│   ├── 05_indexes.sql     # Índices
│   └── 06_roles.sql       # Permisos
├── my-app/                
│   └── src/app/
│       ├── api/reports/   
│       ├── vistas/        
│       └── page.tsx       
└── docker-compose.yml
```

---

## Views

### 1. `view_top_users` - Ranking de Clientes

| Característica | Detalle |
|----------------|---------|
| Grain | Un usuario |
| Métricas | Gasto total, órdenes, ticket promedio, posición |
| Funciones | SUM, COUNT, AVG, RANK() OVER |
| Extra | COALESCE para NULLs |

```sql
SELECT * FROM view_top_users WHERE posicion <= 3;
```

---

### 2. `view_categorias_top` - Ingresos por Categoría

| Característica | Detalle |
|----------------|---------|
| Grain | Una categoría |
| Métricas | Ingresos totales, estatus |
| HAVING | Filtra categorías con ingresos > 0 |
| CASE | Clasifica en "Ganancias Altas" o "Normales" |

```sql
SELECT * FROM view_categorias_top ORDER BY ingresos_totales DESC;
```

---

### 3. `view_analisis_productos` - Inventario

| Característica | Detalle |
|----------------|---------|
| Grain | Un producto |
| Métricas | Stock, unidades vendidas, valor |
| CTE | Separa el cálculo de ventas |
| COALESCE | Maneja productos sin ventas |

```sql
SELECT * FROM view_analisis_productos WHERE stock_actual < 50;
```

---

### 4. `view_estado_ordenes` - Estados de Pedidos

| Característica | Detalle |
|----------------|---------|
| Grain | Un estado |
| Métricas | Cantidad, monto acumulado, promedio |
| HAVING | Filtra estados con >= 1 orden |

```sql
SELECT * FROM view_estado_ordenes;
```

---

### 5. `view_ventas_diarias` - Ventas por Día

| Característica | Detalle |
|----------------|---------|
| Grain | Un día |
| Métricas | Total órdenes, ventas, ticket promedio |
| Funciones | COUNT, SUM, AVG, DATE |

```sql
SELECT * FROM view_ventas_diarias ORDER BY fecha_venta DESC LIMIT 7;
```

---

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
---

## Seguridad

### Rol de base de datos

La app usa un usuario con permisos mínimos, no postgres:

```sql
CREATE ROLE user_app LOGIN PASSWORD 'qwerty123';

GRANT CONNECT ON DATABASE actividad_db TO user_app;
GRANT USAGE ON SCHEMA public TO user_app;

-- Sin acceso a tablas, solo a las views
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM user_app;
GRANT SELECT ON view_top_users TO user_app;
GRANT SELECT ON view_categorias_top TO user_app;
GRANT SELECT ON view_analisis_productos TO user_app;
GRANT SELECT ON view_estado_ordenes TO user_app;
GRANT SELECT ON view_ventas_diarias TO user_app;
```



## Funcionalidades

| Reporte | Paginación | Filtros | KPIs |
|---------|------------|---------|------|
| Top Clientes | Sí | - | Gasto total, promedio |
| Categorías | - | Por estatus | Ingresos |
| Productos | Sí | Stock mínimo | Valor inventario |
| Estado Órdenes | - | - | Cantidad por estado |
| Ventas Diarias | Sí | Rango fechas | Ventas totales |


