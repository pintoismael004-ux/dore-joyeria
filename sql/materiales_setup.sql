-- ══════════════════════════════════════════════════════════
-- VARIOS MATERIALES POR PIEZA (composición)
-- Corre esto en el SQL Editor de Supabase
-- ══════════════════════════════════════════════════════════

-- 1. Lista de materiales de cada pieza, con su cantidad.
--    Ej: [{"material":"Oro 18k","cantidad":"3 g"},{"material":"Circón","cantidad":"5 piedras"}]
--    La columna "material" se mantiene con el resumen en texto
--    (Ej: "Oro 18k 3 g + Circón 5 piedras") para el sistema interno y los filtros.
alter table inventario add column if not exists materiales jsonb;

-- (por si aún no se corrió descripcion_setup.sql)
alter table inventario add column if not exists descripcion text;

-- 2. Actualizar la vista pública para que también muestre los materiales
create or replace view catalogo_publico as
select id, nombre, tipo, material, talla, precio, cant, imagen_url, descripcion, materiales
from inventario
where cant > 0;

grant select on catalogo_publico to anon;
grant select on catalogo_publico to authenticated;
