-- ══════════════════════════════════════════════════════════
-- DESCRIPCIÓN DE PRODUCTOS
-- Corre esto en el SQL Editor de Supabase
-- ══════════════════════════════════════════════════════════

-- 1. Columna para guardar la descripción de cada pieza
alter table inventario add column if not exists descripcion text;

-- 2. Actualizar la vista pública para que también muestre la descripción
create or replace view catalogo_publico as
select id, nombre, tipo, material, talla, precio, cant, imagen_url, descripcion
from inventario
where cant > 0;

grant select on catalogo_publico to anon;
grant select on catalogo_publico to authenticated;
