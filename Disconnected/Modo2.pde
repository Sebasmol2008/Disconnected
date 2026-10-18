/* ======================================================================
 *  MODO 2 — EN VIVO   (pantallas 40 a 59)
 *
 *  draw() llama a modo2() en cada frame mientras "pantalla" esté entre
 *  40 a 59. Aquí dentro irá un if por cada pantalla del modo, igual que
 *  en draw(): if (pantalla == ...) { ... } else { if (...) { ... } }
 * ====================================================================== */

void modo2() {
  background(0);   // por ahora, pantalla negra (aquí irá la historia)
  botonVolver(60, 1000);   // para poder regresar a elegir historia
}
