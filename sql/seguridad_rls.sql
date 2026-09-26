-- ══════════════════════════════════════════════════════════
-- NIVEL 3 · SEGURIDAD COMPLETA — Supabase Auth + RLS por rol
-- Corre esto en el SQL Editor DESPUÉS de haber creado ya las
-- tablas del negocio (el schema.sql original).
-- ══════════════════════════════════════════════════════════

-- 1. Tabla de perfiles: guarda el rol de cada usuario autenticado
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  usuario text,
  permiso text not null default 'vendedor' check (permiso in ('administrador','vendedor'))
);
alter table profiles enable row level security;
create policy "ver mi propio perfil" on profiles for select using (auth.uid() = id);
create policy "actualizar mi propio perfil" on profiles for update using (auth.uid() = id);

-- 2. Trigger: cuando se crea un usuario en Supabase Auth,
--    se le crea automáticamente su fila en profiles
--    (con rol "vendedor" por defecto — el admin se ajusta a mano, ver paso 6)
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, usuario, permiso)
  values (new.id, split_part(new.email,'@',1), 'vendedor');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 3. Función helper: ¿el usuario que hace la petición es administrador?
create or replace function public.es_admin()
returns boolean as $$
  select exists(
    select 1 from public.profiles
    where id = auth.uid() and permiso = 'administrador'
  );
$$ language sql security definer stable;

-- 4. Reactivar RLS en las tablas del negocio (antes estaba desactivado)
alter table inventario enable row level security;
alter table ventas     enable row level security;
alter table caja       enable row level security;
alter table creditos   enable row level security;
alter table nomina     enable row level security;
alter table config     enable row level security;

-- 5. Reglas: cualquier usuario logueado (autenticado) puede leer,
--    crear y actualizar; SOLO un administrador puede borrar.
--    config (ajustes) solo la puede tocar un administrador.

-- INVENTARIO
create policy "inv_select" on inventario for select using (auth.role()='authenticated');
create policy "inv_insert" on inventario for insert with check (auth.role()='authenticated');
create policy "inv_update" on inventario for update using (auth.role()='authenticated');
create policy "inv_delete" on inventario for delete using (public.es_admin());

-- VENTAS
create policy "ventas_select" on ventas for select using (auth.role()='authenticated');
create policy "ventas_insert" on ventas for insert with check (auth.role()='authenticated');
create policy "ventas_delete" on ventas for delete using (public.es_admin());

-- CAJA
create policy "caja_select" on caja for select using (auth.role()='authenticated');
create policy "caja_insert" on caja for insert with check (auth.role()='authenticated');
create policy "caja_delete" on caja for delete using (public.es_admin());

-- CRÉDITOS
create policy "creditos_select" on creditos for select using (auth.role()='authenticated');
create policy "creditos_insert" on creditos for insert with check (auth.role()='authenticated');
create policy "creditos_update" on creditos for update using (auth.role()='authenticated');
create policy "creditos_delete" on creditos for delete using (public.es_admin());

-- NÓMINA
create policy "nomina_select" on nomina for select using (auth.role()='authenticated');
create policy "nomina_insert" on nomina for insert with check (auth.role()='authenticated');
create policy "nomina_update" on nomina for update using (auth.role()='authenticated');
create policy "nomina_delete" on nomina for delete using (public.es_admin());

-- CONFIG (ajustes del negocio) — solo administradores
create policy "config_select" on config for select using (auth.role()='authenticated');
create policy "config_update" on config for update using (public.es_admin());

-- ══════════════════════════════════════════════════════════
-- 6. ÚLTIMO PASO (a mano, no es SQL):
--    a) Ve a Authentication → Users → "Add user" y crea a
--       juanramos con su correo real y contraseña. Activa
--       "Auto Confirm User" para que no necesite verificar el correo.
--    b) Ve a Table Editor → profiles, busca la fila que se creó
--       automáticamente para juanramos, y cambia su columna
--       "permiso" de 'vendedor' a 'administrador'.
-- ══════════════════════════════════════════════════════════
