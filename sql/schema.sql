-- ══════════════════════════════════════════════════════════
-- ESQUEMA PARA EL SISTEMA DE LA JOYERÍA
-- Copia y pega TODO esto en Supabase → SQL Editor → Run
-- ══════════════════════════════════════════════════════════

create table inventario (
  id bigint generated always as identity primary key,
  nombre text not null,
  tipo text not null,
  material text not null,
  talla text,
  cant int not null default 0,
  precio numeric not null default 0,
  pc numeric not null default 0,
  origen text default 'nuevo',
  created_at timestamptz default now()
);

create table ventas (
  id bigint generated always as identity primary key,
  fecha text,
  vendedor text,
  cliente text,
  ref text,
  tipo text,
  material text,
  cant int,
  precio_unit numeric,
  total numeric,
  forma_pago text,
  canal text,
  created_at timestamptz default now()
);

create table caja (
  id bigint generated always as identity primary key,
  fecha text,
  tipo text,
  descripcion text,
  monto numeric,
  forma_pago text,
  created_at timestamptz default now()
);

create table creditos (
  id bigint generated always as identity primary key,
  fecha text,
  cliente text,
  telefono text,
  ref text,
  cant int,
  precio_total numeric,
  saldo numeric,
  valor_cuota numeric,
  num_cuotas int,
  cuotas_pagadas int default 0,
  forma_pago text,
  notas text,
  estado text default 'Pendiente',
  created_at timestamptz default now()
);

create table nomina (
  id bigint generated always as identity primary key,
  fecha text,
  empleado text,
  periodo_inicio text,
  periodo_fin text,
  dias_trabajados int,
  valor_dia numeric,
  salario_base numeric,
  comisiones numeric,
  deducciones numeric,
  total numeric,
  forma_pago text,
  notas text,
  estado text default 'Pendiente',
  created_at timestamptz default now()
);

create table config (
  id bigint generated always as identity primary key,
  gastos_fijos jsonb default '[]',
  deuda_proveedor numeric default 0,
  meta_piezas int default 30,
  fecha_corte text,
  ganancia_por_pieza numeric default 30000,
  saldo_efectivo numeric default 0,
  saldo_banco numeric default 0,
  fecha_saldo text
);
insert into config default values;

-- ══════════════════════════════════════════════════════════
-- PERMISOS: la app usa la "anon key" directamente desde el
-- navegador (igual que South Tenis). Para que funcione sin
-- tener que armar un backend aparte, desactivamos el RLS
-- (Row Level Security) en estas tablas.
--
-- ⚠️ IMPORTANTE: esto significa que cualquiera que tenga tu
-- URL + anon key podría leer/escribir estos datos directamente
-- a la API, sin pasar por el login de la app. El login de la
-- app protege la INTERFAZ, no la base de datos. Para un negocio
-- pequeño manejado por personas de confianza esto suele ser
-- aceptable, pero si más adelante quieres reforzarlo, dímelo y
-- te ayudo a configurar políticas RLS reales.
-- ══════════════════════════════════════════════════════════
alter table inventario disable row level security;
alter table ventas disable row level security;
alter table caja disable row level security;
alter table creditos disable row level security;
alter table nomina disable row level security;
alter table config disable row level security;
