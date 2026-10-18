/* ======================================================================
   CONTROLES
   Todo lo del teclado y el mouse: keyPressed(), mouseReleased() y las
   funciones que usan (avanzarIntro, clickMenu, clickOpciones).
   Las variables que se leen aquí (opcionEncima, volverEncima, etc.)
   están declaradas en la pestaña Pantallas; como son globales, se
   pueden usar desde cualquier pestaña.
   ======================================================================

   ======================================================================
   TECLADO Y MOUSE
   keyPressed() y mouseReleased() son funciones de Processing: nosotros
   solo escribimos qué hacen, y Processing las llama SOLAS cuando se
   presiona una tecla o se suelta el botón del mouse (una vez por click).
   ====================================================================== */

   void keyPressed() {  //Esta funcion actua cuando se presiona un tecla.
      if(key == ESC) {  //Processing de fabrica, cierra el juego cuando se presiona ESC. Nosotros queremos que ESC sea como un "Volver"
         key = 0;        //Cuando lo presiona, le asignamos a key el valor de "0" para que lea 0 y no detecte el "ESC", de esta forma, no lee nada y no se cierra.
      if(pantalla == 1 && confirmarSalida){
         confirmarSalida = false;  //Cierra la ventana de salir.
      } else{
         if(pantalla == 2 ||  pantalla == 3 || pantalla == 4){
            cambiarPantalla(1); //Si presionamos ESC en alguna de las pantallas mencionadas, llevaran a la pantalla 1. 
         }else{
            if(pantalla >= 20){
               cambiarPantalla(4);      //Si presionamos ESC dentro de un modo, llevara a la pantalla de "Elegir historia"(Esta medida es temporal hasta ahora)
            }
         }
      }
      return;  //El "return" aqui es como un "Finaliza la funcion acá", en este caso, se usa ahi porque ya no hay mas nada que comparar con el ESC. 
   }
   
   if(key == TAB){
      vercoordenadas = !vercoordenadas;  //Si era false pasa a true y viceversa.
      return;
   }
   if(pantalla == 0){  //Cualquier tecla en la intro hace avanzar.
      avanzarIntro(); 
   }
}

void mouseReleased(){  //Esta funcion se llama exactamente en el momento en el que el usuario suelta un boton del mouse despues de haberlo presionado.
   if(pantalla == 0) {
      avanzarIntro(); //Se presiona mouse y cambia la pantalla.
   } else{
      if(pantalla == 1) {
         clickMenu();
      }else{
         if(pantalla == 2){
            clickOpciones();
         }else{
            if(pantalla == 3) {
               if(volverEncima){
                  cambiarPantalla(1);  //Volver en los creditos manda al menu. 
               }
            } else{
               if(pantalla == 4) {
                  if(modoEncima != -1) {
                     cambiarPantalla(20 + modoEncima*20);   //Vas al inicio del modo elegido, si es 0, vas a la pantalla 20, si es 1, a la 40 y asi.
                  }else{
                     if(volverEncima){
                        cambiarPantalla(1); 
                     }
                  }
               }else{
                  if(pantalla >= 20 && volverEncima) {
                     cambiarPantalla(4);   //Si estas en un modo de juego y presiones un "volver" te enviara a la pantalla de seleccion de modos(TEMPORAL POR AHORA)
                  }
               }
            }
         }
      }
   }   
}

void avanzarIntro() {  //En la intro: Si el logo no ha terminado, manda directo al titulo, y si esta el titulo, pasa directamente al menu(Al clickear o presionar teclas)
   if(millis() - Introinicio < 3500) {
      Introinicio = millis() - 3500;  //Esta ecuacion "engaña" al reloj, hace como si ya hubieran pasado esos 3.5 segundos.
   }else{
      cambiarPantalla(1);
   }
}

void clickMenu() {  //Click en el menu(o en la ventana salir, si esta abierta)
   if(confirmarSalida){   //Ventana Salir esta abierta
      if(salidaEncima == 0){ 
         exit();   //Recordemos que 0 = SI, por lo que cierra el juego
      }else{
         if(salidaEncima == 1){
            confirmarSalida = false; //NO: cierra la ventana Salir y sigue en el menu
         }
      }
      return;   //Con la ventana abierta no se revisan los otros botones del menú.
   }

   if(opcionEncima == 0) {  //El mouse Clickea el boton de "JUGAR"
      cambiarPantalla(4);   //Se abre la pantalla de "Elegir historia"
   }else{
      if(opcionEncima == 1){  //El mouse Clickea el boton de "OPCIONES"
         cambiarPantalla(2);  //Se abre la pantalla de Opciones
      }else{
         if(opcionEncima == 2){  //El mouse Clickea el boton de "CREDITOS"
            cambiarPantalla(3);  //Se abre la pantalla de Creditos
         }else{
            if(opcionEncima == 3){  //El mouse Clickea el boton de "SALIR"
               confirmarSalida = true;   //Se abre la ventana de "Salir" 
            }
         }
      }
   }
}

void clickOpciones() {  //Click en Opciones, flechas de volumen y boton de "VOLVER"
   if(volverEncima) {   //Si se clickea el boton de volver, se abre la pantalla del menú principal.
      cambiarPantalla(1);  
      return;
   }

   if(filaOpcionEncima == 0) { //0 = Fila de "Musica" 
      Volmusica = constrain(Volmusica + flechaEncima, 0, 10);  //flechaEncima dice si la musica baja, se queda igual, o sube.
      //constrain() es una funcion nativa de processing que limita
      //un valor numerico de forma que que se mantenga dentro de un rango definido.
      //En este caso es de 0 a 10. 
   }else{
      if(filaOpcionEncima == 1) {  //1 = Fila de "Efectos"
         Volefectos = constrain(Volefectos + flechaEncima, 0, 10); 
      }
   }
   aplicarVolumen();  //Para que el cambio se escuche de inmediato
}