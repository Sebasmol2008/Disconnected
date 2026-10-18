/* ======================================================================
 *  MODO 3 — RASTRO VIRAL   (pantallas 60 a 79)
 *
 *  draw() llama a modo3() en cada frame mientras "pantalla" esté entre
 *  60 a 79. Aquí dentro irá un if por cada pantalla del modo, igual que
 *  en draw(): if (pantalla == ...) { ... } else { if (...) { ... } }
 * ====================================================================== */

void modo3() {
  background(0);   // por ahora, pantalla negra (aquí irá la historia)
  botonVolver(60, 1000);   // para poder regresar a elegir historia
}
