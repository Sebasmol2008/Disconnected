/* ======================================================================
 *  MODO 1 — CUATRO PAREDES   (pantallas 20 a 39)
 *
 *  draw() llama a modo1() en cada frame mientras "pantalla" esté entre
 *  20 a 39. Aquí dentro irá un if por cada pantalla del modo, igual que
 *  en draw(): if (pantalla == ...) { ... } else { if (...) { ... } }
 * ====================================================================== */

void modo1() {
  background(0);   // por ahora, pantalla negra (aquí irá la historia)
  botonVolver(60, 1000);   // para poder regresar a elegir historia
}
