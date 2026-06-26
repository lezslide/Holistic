# Denise Studio

Web publica para Denise Studio, con secciones de clases, instructores, eventos, WhatsApp, cuenta de alumno, reservas y panel de administracion.

## Deploy en Vercel

Este proyecto se publica como sitio estatico.

- Framework preset: `Other`
- Root directory: `./`
- Build command: vacio
- Output directory: vacio o `.`
- Variables de entorno: ninguna por ahora

Cada push a `main` dispara un nuevo deploy en Vercel.

## Supabase

La web ya esta conectada a este proyecto:

- URL: `https://juvojjajjmtrifzxdeub.supabase.co`
- Key publica: configurada en `index.html`

Antes de probar reservas reales, abrir Supabase y ejecutar el contenido de `supabase-schema.sql` en SQL Editor.

Pasos:

1. Ir a Supabase > SQL Editor.
2. Crear un query nuevo.
3. Pegar todo el contenido de `supabase-schema.sql`.
4. Ejecutar.
5. Crear una cuenta desde la web con el email real de Denise.
6. Volver a SQL Editor y ejecutar:

```sql
update public.profiles
set role = 'admin'
where email = 'EMAIL_DE_DENISE';
```

Si Auth pide confirmar email, desactivar temporalmente "Confirm email" en Authentication > Providers > Email, o confirmar el correo antes de iniciar sesion.

## URLs de Auth en Supabase

En Supabase > Authentication > URL Configuration:

- Site URL: `https://denise-yoga.vercel.app`
- Redirect URLs:
  - `https://denise-yoga.vercel.app`
  - `https://denise-yoga.vercel.app/**`

Si aparece `localhost` en los mails o redirecciones, cambiar estos campos y guardar.
