-- ══════════════════════════════════════════════════════════
-- FOTOS DE PRODUCTOS
-- Corre esto en el SQL Editor de Supabase
-- ══════════════════════════════════════════════════════════

-- 1. Columna para guardar el link de la foto de cada pieza
alter table inventario add column if not exists imagen_url text;

-- 2. Actualizar la vista pública para que también muestre la foto
create or replace view catalogo_publico as
select id, nombre, tipo, material, talla, precio, cant, imagen_url
from inventario
where cant > 0;

grant select on catalogo_publico to anon;
grant select on catalogo_publico to authenticated;

-- 3. Bucket de almacenamiento donde se guardan las fotos subidas
insert into storage.buckets (id, name, public)
values ('productos','productos', true)
on conflict (id) do nothing;

-- 4. Reglas de acceso a las fotos:
--    cualquiera puede VER las fotos (el catálogo es público),
--    solo un usuario logueado puede SUBIR o CAMBIAR una foto,
--    solo un administrador puede BORRAR una foto.
create policy "productos_publico_select" on storage.objects
  for select using (bucket_id = 'productos');

create policy "productos_autenticado_insert" on storage.objects
  for insert with check (bucket_id = 'productos' and auth.role() = 'authenticated');

create policy "productos_autenticado_update" on storage.objects
  for update using (bucket_id = 'productos' and auth.role() = 'authenticated');

create policy "productos_admin_delete" on storage.objects
  for delete using (bucket_id = 'productos' and public.es_admin());
