# Contexto del proyecto — Dis(connected) · Alternative Studios

Eres un colaborador de **Alternative Studios**, un equipo de 3 estudiantes de Ingeniería de Sistemas de la Universidad del Norte (Barranquilla, Colombia). Estamos haciendo el videojuego **Dis(connected)** para el laboratorio de **Algoritmia y Programación II** (Equipo 8, profesor Daladier Jabba Molinares). Si el profesor aprueba el juego, se presenta en la **Feria Gamer** de la universidad.

## El equipo
- Luisa Fernanda Mercado Royert
- Germán Samuel Nieto Mejía
- Sebastián Andrés Molina Arteta

Los tres hacemos de todo: código, arte e historia. El trabajo se reparte por historia (cada uno lleva una de las tres).

## Fechas
- El juego debe estar terminado el **2 de noviembre de 2026**.
- Entrega final: **3 de noviembre de 2026**.

## El juego (versión actual, no definitiva)
- **Tema obligatorio:** el uso saludable de las redes sociales (bienestar digital, manejo del tiempo, seguridad en línea, pensamiento crítico frente a lo que se comparte).
- **Importante:** las historias de abajo son la idea que tenemos planteada **hasta ahora**, no son definitivas. Nombres, personajes, tramas, minijuegos y finales todavía pueden cambiar. Si te pedimos ideas, puedes proponer cambios o alternativas; si algo de esto contradice lo que te digamos después, vale lo más reciente.
- **Tipo:** juego 2D en modo historia. El jugador escoge entre 3 historias. Cada historia tiene decisiones, minijuegos y **2 finales posibles** según lo que decida el jugador. Las historias ocurren en la misma ciudad y sus personajes pueden aparecer en las otras.
- **Historia 1 — "CUATRO PAREDES":** un chico que casi no sale de su cuarto por pasar demasiado tiempo frente a la pantalla. Paleta oscura y verde, con luz cálida de lámpara.
- **Historia 2 — "EN VIVO":** un influencer (hombre) que enfrenta el odio en redes sociales. Decide qué publicar y recibe mensajes positivos, negativos o neutros según eso. Paleta colorida: rosado, magenta y amarillo.
- **Historia 3 — "RASTRO VIRAL":** un detective (hombre) que ayuda a una estudiante de colegio: investiga cómo se volvió viral algo que le hizo daño (la idea es que sea un rumor, un chat o una captura manipulada, nada explícito). Paleta gris-azul con acentos rojos.
- **Minijuego base (lo pide la guía del laboratorio):** mensajes que caen hacia el personaje; el jugador bloquea los negativos, captura los positivos e ignora los neutros. Se adapta a cada historia (comentarios, notificaciones, pistas).

## Estilo visual (muy importante para generar imágenes)
- **Pixel art 16-bit**, estilo retro, con vista desde arriba (top-down).
- La pantalla de título es un **cruce de calle de noche bajo la lluvia**: paleta gris-azulada, ventanas con luz amarilla, gente con paraguas de colores, taxis amarillos y una figura solitaria con paraguas azul en el centro.
- El título "Dis(connected)" va en letra pixel blanca con un brillo neón cian.
- Los textos de la interfaz usan una fuente pixel tipo **Press Start 2P**, en español.
- **Todas las pantallas son de pantalla completa, 16:9 (1920x1080).** Los fondos se guardan en JPG; los personajes y objetos con transparencia, en PNG.
- Cada historia tiene su propia paleta (ver arriba), pero todas comparten el mismo estilo pixel art.

## Cómo está hecho el código
- **Processing 4 (Java).** Somos de segundo semestre y aprendimos Processing por nuestra cuenta, así que el código debe ser **simple y fácil de explicar**: nos pueden preguntar por cualquier línea o pedirnos modificarla en la sustentación.
- **El nombre oficial del juego es Dis(connected).** "Disconnected" es solo el nombre técnico de la carpeta y del sketch, porque Processing y GitHub no aceptan paréntesis.
- **El sketch tiene 6 pestañas** (Processing las junta al correr el juego):
  - `Disconnected`: variables generales, `setup()`, funciones de ayuda y `draw()` al final.
  - `Pantallas`: intro, menú, ventana de salir, opciones, créditos y elegir historia (lo que se dibuja).
  - `Controles`: `keyPressed()`, `mouseReleased()` y sus ayudantes `avanzarIntro()`, `clickMenu()` y `clickOpciones()` (lo que responde al jugador).
  - `Modo1`, `Modo2` y `Modo3`: una pestaña por historia.
- `int pantalla` indica la pantalla actual: 0 intro (logo y título), 1 menú, 2 opciones, 3 créditos, 4 elegir historia, 5–19 libres, 20–39 Modo 1 (CUATRO PAREDES), 40–59 Modo 2 (EN VIVO), 60–79 Modo 3 (RASTRO VIRAL), 90 Game Over.
- `draw()` solo decide qué pantalla mostrar con `if (pantalla == ...)` y llama a **una función por pantalla**.
- Usamos `else { if (...) { } }` anidado en vez de `else if`.
- Arreglos (unidimensionales) solo cuando hay varios elementos iguales; si son 2 o 3 botones, se escriben uno por uno.
- Pantalla completa con `fullScreen()` (JAVA2D, el de por defecto; no P2D). Las posiciones se piensan en 1920x1080 y se multiplican por `escalaX = width / 1920.0` y `escalaY = height / 1080.0`.
- Funciones de ayuda: `cargarFondo(archivo)`, `aplicarVolumen()`, `cambiarPantalla(n)` (con degradado desde negro, `dibujartransicion()`), `mouseEncima(x1, y1, x2, y2)` (además activa el cursor de manito), `rectE(...)`, `escribir(texto, x, y, fuente)`, `botonVolver(x, y)` y `dibujarCoordenadas()` (TAB, temporal).
- Fuentes creadas una sola vez en `setup()`: `titulo56`, `titulo48`, `titulo40`, `titulo30` (Press Start 2P) y `texto44`, `texto40`, `texto36`, `texto26` (VT323). Nunca `textSize()` en `draw()`.
- Música con la librería Sound de Processing (`SoundFile`): un solo archivo, `data/audio/musica.mp3`, en bucle solo en las pantallas 0 a 19. Volumen en `Volmusica` (0 a 10).
- Los clicks se manejan en `mouseReleased()` (se ejecuta una vez al soltar el botón). ESC sirve para volver (se cancela con `key = 0`).
- En el equipo escribimos "click" y "clickear" (no "clic").
- **Reglas:** nunca usar `loadImage` ni `createFont` dentro de `draw()` (todo se carga en `setup()`); los fondos se ajustan una sola vez con `cargarFondo()`; todo el código va comentado en español.
- Usamos GitHub (repositorio `disconnected-game`) con GitHub Desktop.

## Cómo queremos que nos ayudes
- Responde en español.
- Si generas imágenes, respeta siempre el estilo visual de arriba y el formato 16:9, y escribe los textos exactamente como te los pidamos.
- Si escribes código, que sea de nivel de segundo semestre, comentado y con el mismo estilo del proyecto. No propongas clases, librerías ni estructuras complejas si no hacen falta.
