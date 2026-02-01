CREATE ROLE user_app Login password 'qwerty123'; 

grant connect on DATABASE actividad_db TO user_app;

grant usage on schema public to user_app;

-- Primero revocar todos los permisos sobre tablas
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM user_app;

-- Luego otorgar permisos solo sobre las views
GRANT SELECT ON view_top_users TO user_app;
GRANT SELECT ON view_categorias_top TO user_app;
GRANT SELECT ON view_analisis_productos TO user_app;
GRANT SELECT ON view_estado_ordenes TO user_app;
GRANT SELECT ON view_ventas_diarias TO user_app;

