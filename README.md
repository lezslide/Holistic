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

## Datos actuales

La version actual guarda cuentas y reservas en `localStorage`, solamente para probar el flujo en el navegador.

Para que las reservas queden guardadas para todos los usuarios y el admin vea datos reales desde cualquier dispositivo, el siguiente paso es conectar Supabase.

## Supabase pendiente

Datos necesarios:

- URL del proyecto Supabase.
- Anon key publica.
- Login con email y contrasena habilitado.
- Tablas: `profiles`, `classes`, `bookings`.
- Rol admin para la cuenta de Denise.
- Numero real de WhatsApp de la empresa.
