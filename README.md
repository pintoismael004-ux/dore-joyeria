# DORÉ JOYERÍA — Sistema de gestión y catálogo

## Archivos

- `joyeria.html` — sistema interno: login, dashboard, ventas, inventario, caja, créditos, nómina y ajustes.
- `catalogo.html` — catálogo público para clientes + panel de administrador (en `catalogo.html#admin`) para agregar/editar/eliminar piezas y subir fotos.
- `sql/` — scripts para configurar la base de datos en Supabase, **en este orden**:
  1. `schema.sql` — crea las tablas del negocio (inventario, ventas, caja, créditos, nómina, config).
  2. `seguridad_rls.sql` — activa Supabase Auth real y las reglas de seguridad por rol (administrador/vendedor).
  3. `catalogo_setup.sql` — crea la vista pública del catálogo y carga los productos iniciales.
  4. `fotos_setup.sql` — habilita fotos de producto (columna, bucket de almacenamiento y permisos).

Ambos archivos `.html` ya están conectados al mismo proyecto de Supabase (mismas tablas), así que un cambio hecho desde cualquiera de los dos se refleja en el otro.

## Cómo editar el proyecto desde aquí en adelante

1. Clona este repositorio en tu computador.
2. Ábrelo con VS Code.
3. Edita `joyeria.html` o `catalogo.html` directamente (son archivos HTML autocontenidos — todo el código vive en un solo archivo, no hay que instalar nada ni correr `npm install`).
4. Para ver los cambios, simplemente abre el archivo `.html` con doble clic, o usa la extensión **Live Server** de VS Code (clic derecho → "Open with Live Server").
5. Cuando quede como quieres, sube los cambios a GitHub (`git add`, `git commit`, `git push` — o con el panel de "Source Control" de VS Code).

## Nota sobre seguridad

Los archivos `.html` contienen la URL de Supabase y la "anon key" en texto plano. Esto es intencional y seguro: el acceso real a los datos está protegido por las reglas de seguridad (RLS) del paso 2, no por ocultar esa clave. Aun así, es buena práctica mantener este repositorio como **privado** en GitHub.
