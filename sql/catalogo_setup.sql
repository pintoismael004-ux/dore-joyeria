-- ══════════════════════════════════════════════════════════
-- CATÁLOGO WEB: vista pública + productos iniciales
-- Corre esto en el SQL Editor de Supabase (DESPUÉS de haber
-- corrido ya schema.sql y seguridad_rls.sql)
-- ══════════════════════════════════════════════════════════

-- 1. Vista pública: expone solo lo que un cliente debe ver
--    (nombre, tipo, material, talla, precio, cantidad).
--    NO expone el precio de costo (pc) ni el origen del stock.
--    Como la vista no tiene RLS propio, ignora el RLS de la
--    tabla "inventario" y puede leerla cualquiera (incluso sin
--    iniciar sesión) — así funciona el catálogo público.
create view catalogo_publico as
select id, nombre, tipo, material, talla, precio, cant
from inventario
where cant > 0;

grant select on catalogo_publico to anon;
grant select on catalogo_publico to authenticated;

-- 2. Productos iniciales
insert into inventario (nombre, tipo, material, talla, cant, precio, pc, origen) values
('COQUETA (11B #3)','Anillo','Oro 18k',null,1,270000,0,'inicial'),
('UN CARRIL (5B #4)','Anillo','Oro 18k',null,1,210000,0,'inicial'),
('4B #4 + 6 NEO','Pulsera','Oro 18k',null,1,125000,0,'inicial'),
('0010 (3B #5 LILA)','Pulsera','Oro 18k',null,1,170000,0,'inicial'),
('0015 (3B #4 + 4NEO)','Pulsera','Oro 18k',null,1,130000,0,'inicial'),
('0020 (2B #4 + 2B #5)','Pulsera','Oro 18k',null,1,200000,0,'inicial'),
('0025 (4B #5 + 6NEO)','Pulsera','Oro 18k',null,1,300000,0,'inicial'),
('0030','Pulsera','Oro 18k',null,1,500000,0,'inicial'),
('3 CARRILES (20B #4 + 10B #5)','Pulsera','Oro 18k',null,1,1553000,0,'inicial'),
('4B #4','Pulsera','Oro 18k',null,1,80000,0,'inicial'),
('4B #4 + 5 NEOPRENO','Pulsera','Oro 18k',null,1,200000,0,'inicial'),
('ADN (3B #4 + 4 NEOPRE)','Pulsera','Oro 18k',null,1,150000,0,'inicial'),
('ADN (7B #3 + 6 NEO)','Pulsera','Oro 18k',null,1,190000,0,'inicial'),
('ADN (7B #3 + 6 NEOPRE)','Pulsera','Oro 18k',null,1,190000,0,'inicial'),
('BABY (4B #3)','Pulsera','Oro 18k',null,1,120000,0,'inicial'),
('COMBO DE AMOR Y AMISTAD','Pulsera','Oro 18k',null,1,170000,0,'inicial'),
('ELEGAN','Pulsera','Oro 18k',null,1,93000,0,'inicial'),
('PULSERA (3B #3)','Pulsera','Oro 18k',null,1,65000,0,'inicial'),
('PULSERA CON NEOPRENO','Pulsera','Oro 18k',null,1,240000,0,'inicial'),
('PULSERA CON NEOPRENO + DIJE','Pulsera','Oro 18k',null,1,820000,0,'inicial');
