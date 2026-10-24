/* Aqui van todas las funciones relacionadas a las pantallas principales (intro, menú, opciones, créditos, elegir historia). Lo relacionado al teclado y mouse está en la pestaña Controles.
   Recordemos las pantallas principales:
   intro = 0, menu = 1, opciones = 2, creditos = 3, elegir historia = 4
   
   Idea general de los botones (se repite en todas las pantallas):
     1. La funciones de las pantallas dibujan los botones y, de paso, verifican
        con mouseEncima() cuál está bajo el mouse. Lo guarda en una
        variable global (por ejemplo opcionEncima). Esto para hacer todo mas resumido.
     2. Cuando se suelta el click, Processing llama a mouseReleased(),una funcion nativa
        de Processing que solo mira esa variable para saber qué botón se tocó. */

//===========================================
// VARIABLES DE ESTAS PANTALLAS
//===========================================

//---------------Pantalla del Menú---------------
String[] opcionesMenu = {"JUGAR", "OPCIONES", "CREDITOS", "SALIR"};
//Este arreglo contiene los textos de los botones del menu. 
float[] corrimiento = {0, 0, 0, 0}; //Cuanto se ha corrido cada boton hacia la derecha(cambia cuando el mouse esta sobre un boton)
int opcionEncima = -1;   //Numero del boton bajo el mouse(-1 = ninguno);
boolean confirmarSalida = false;  //Esta variable es verdadera cuando muestra la ventana de "¿Seguro que quieres desconectarte?"
int salidaEncima = -1;   //en esa ventana:  0 = Si, 1 = No, -1 = Ninguno

//---------------Pantalla de opciones---------------
String[] descOpciones = {"Sube o baja el volumen de la música.", "Sube o baja el volumen de los efectos.",}; 
//Este arreglo contiene el texto de ayuda que tendrá la pantalla de opciones, en un arreglo nos ayuda a ahorrar lineas de codigo.
int filaOpcionEncima = -1;  //Fila bajo el mouse, 0 = musica, 1 = efectos, 2 = volver, -1 = ninguna
int flechaEncima = 0;      //Flecha sobre la que esta el mouse al subir o bajar de volumen.
//-1 = flecha de bajar("<"), 1 = flecha de subir(">"), 0 = ninguna

//---------------Pantalla de créditos---------------
// Por ahora no hay variables: los textos de los créditos se agregan cuando el juego esté terminado.

//---------------Pantalla de Elegir historia---------------
int modoEncima = -1;  //Modo de juego seleccionado bajo el mouse(0, 1, 2) o -1 = ninguna
PImage[] fondoModoEncima = new PImage[3];   //Las 3 variantes iluminadas: 0 = Cuatro Paredes, 1 = En Vivo, 2 = Rastro Viral.
boolean volverEncima = false; //boton VOLVER bajo el mouse(se usa en varias pantallas)

//---------------Pantalla de Game over---------------
int gameoverEncima = -1;   //Boton bajo el mouse en la pantalla de Game over. 0 = Reintentar. 1 = Elegir Historia. -1 = Ninguno.

//==================================================================
// PANTALLAS
//==================================================================

void pantallaIntro() { //La que aparece cuando pantalla = 0, sale la intro de "ALTERNATIVE STUDIOS presenta" y luego la pantalla del titulo.
    //La PRIMERA vez que se dibuja la intro, Introinicio todavía vale -1: ahí se arranca el cronómetro.
    if(Introinicio == -1) {
        Introinicio = millis();
    }

    float t = (millis() - Introinicio) / 1000.0; //Con t hallamos el tiempo que ha pasado desde que arrancó la intro(Excluimos los segundos que pasaron en cargar todo)
    //millis() cuenta en milisegundos, al dividir por 1000.0 queda en segundos con decimales.

    if(t < 3.5) { //Los primeros 3.5 segundos mostraran el logo del estudio sobre negro.
        float alfa = 255; //opacidad del logo
        if(t < 1) {  //En el segundo 0 a 1, apenas aparece el logo con un degradado desde negro. 
            alfa = map(t, 0, 1, 0, 255);  //map() es una funcion de processing que funciona asi:
            // map(valor, desdeMin, desdeMax, hastaMin, hastaMax) pasa un número de un rango a otro.
            //funciona para calcular como va a cambiar la opacidad de manera proporcional al tiempo en esos rangos(0-1 en segundos y 0-255 en opacidad, respecto al valor t)
        }else{
            if(t > 2.5) {
                alfa = map(t, 2.5, 3.5, 255, 0); //En el segundo de 2.5 a 3.5, desaparece el logo y se hace negro.
            }
        }
        image(fondoLogo, 0, 0);     //la imagen del logo.
        //Encima, un rectangulo negro que actua en funcion a alfa.
        //El rectangulo es transparente cuando alfa = 255 (se ve el logo) y queda negro sólido cuando alfa = 0 (tapa el logo).
        noStroke();
        fill(0, 255 - alfa);
        rect(0, 0, width, height);
    }else{
        //Despues de haber pasado los 3.5 segundos de la pantalla del logo, viene la pantalla del titulo. 
        image(fondoTitulo, 0, 0);
        float alfa = map(t, 3.5, 5, 0, 255);  //En el segundo de 3.5 a 5, alfa sube de 0 a 255 y el titulo aparece desde negro (igual que el logo).
        if(alfa < 255){   //Solo se dibuja el rectangulo mientras el titulo no se vea completo, para no dibujarlo cuando ya no hace falta (despues del segundo 5, alfa pasa de 255).
            noStroke();
            fill(0, 255 - alfa);   //Igual que en el logo: el negro va al reves de alfa.
            rect(0, 0, width, height);
        }
    }
}

void pantallaMenu(){ //La que aparece cuando pantalla = 1, el menu principal. 
    image(fondoMenu, 0, 0);
    textFont(titulo48);
    textAlign(LEFT, CENTER);
    opcionEncima = -1; //Se asume que el mouse no esta encima de ninguna opcion primero.
    for(int i = 0; i < opcionesMenu.length; i = i + 1){  //for que trabaja con el arreglo visto anteriormente(opcionesMenu)
        float y = 420 + i*115;   //Los botones tienen una diferencia de 115 pixeles entre ellos. 
        boolean encima = !confirmarSalida && mouseEncima(80, y - 45, 660, y + 45);
        //la variable "encima" arroja si el mouse esta encima de un boton?
        //Se hace true si confirmarSalida = false porque cuando la ventana de salir del juego esta abierta, estos botones no se pueden interactuar. 
        if(encima){
            opcionEncima = i;
            corrimiento[i] = corrimiento[i] + (40 - corrimiento[i]) * 0.15;
            //corrimiento[i] es para aplicarle un corrimiento lento y suave al texto de los botones cuando el mouse esta sobre ellos.
            fill(127, 231, 255);  //color cian
            text(">", (50 + corrimiento[i])*escalaX, y*escalaY); //Se escribe la flechita a la izquierda      
        }else{
            corrimiento[i] = corrimiento[i] + (0 - corrimiento[i]) * 0.15; //Quita el corrimiento con la misma suavidad.
            fill(200, 210, 225);   //color gris claro(color predeterminado)
        }
        text(opcionesMenu[i], (100 + corrimiento[i])*escalaX, y*escalaY);
    }
    if(confirmarSalida) {
        ventanaSalir();  //Se dibuja encima del menú la ventana de salir.
    }
}

void ventanaSalir() {  //La funcion asociada con la ventana de "¿Seguro que quieres salir?" encima del menu cuando le damos a la opcion de Salir.
    noStroke();
    fill(0,170);   //Oscurece todo lo de atrás
    rect(0, 0, width, height); 

    //Ahora se crea el recuadro central con borde cian. 
    fill(8, 14, 30, 240); 
    stroke(127,231,255);
    strokeWeight(3*escalaY);
    rectE(560, 380, 800, 320);
    noStroke();
    
    textAlign(CENTER, CENTER);  //Texto que va en el recuadro central.
    fill(255);
    escribir("¿SEGURO QUE QUIERES", 960, 460, titulo30);  
    escribir("DESCONECTARTE?", 960, 510, titulo30);
    salidaEncima = -1; //Se supone primero que el mouse está sobre nada. 
    //Botones SI y NO 
    //Boton SI:
    if(mouseEncima(720, 570, 920, 650)){
        salidaEncima = 0;
        fill(127, 231, 255); //cian si el mouse esta encima. 
    }else{
        fill(170, 180, 195); //gris si no.
    }
    escribir("SI", 820, 610, titulo40);

    //Boton NO: 
    if (mouseEncima(1000, 570, 1200, 650)) {
    salidaEncima = 1;
    fill(127, 231, 255);
  } else {
    fill(170, 180, 195);
  }
  escribir("NO", 1100, 610, titulo40);
}

void pantallaOpciones(){ //La que aparece cuando pantalla = 2, la pantalla de opciones.
  image(fondoOpciones, 0, 0);

  // Arreglos locales (solo existen dentro de esta función) para dibujar las 2 filas con un for.
  String[] nombres = {"MUSICA", "EFECTOS"};  //texto de cada fila
  int[] valores = {Volmusica, Volefectos};   //Volumen actual de cada fila 
  float[] filasY = {360, 470};               //altura (y) de cada fila en la pantalla.                            
//Abajo se asume que el mouse esta encima de nada.
  filaOpcionEncima = -1;  
  flechaEncima = 0;

  for (int i = 0; i < 2; i++) { //for para recorrer los 3 arreglos a la vez. 
    float y = filasY[i];
    boolean filaEncima = mouseEncima(450, y - 45, 1060, y + 45);  //Arroja si el mouse se encuentra encima de la fila.
    if (filaEncima) {
      filaOpcionEncima = i;  //guarda que fila es. 
    }

    // Nombre de la fila
    textAlign(LEFT, CENTER);
    if (filaEncima) {
      fill(127, 231, 255);  // color cian si esta encima. 
    } else {
      fill(220, 230, 240);  // color gris 
    }
    escribir(nombres[i], 470, y, titulo30); 

    // Flechas: se iluminan si el mouse está encima de cada una, devuelven true o false. 
    boolean menos = mouseEncima(745, y - 35, 790, y + 35);   //Flecha menos("<") baja el volumen
    boolean mas   = mouseEncima(1015, y - 35, 1060, y + 35); //Flecha mas (">") sube el volumen
    if (menos) {
      flechaEncima = -1;  //Al hacer click, mouseReleased le suma este numero al volumen(lo resta)
    }
    if (mas) {
      flechaEncima = 1;   //Al hacer click, mouseReleased le suma este numero al volumen(lo suma)
    }
    if (menos) {  //La flecha se pone cian si el mouse esta encima, gris si no. 
      fill(127, 231, 255);
    } else {
      fill(220, 230, 240);
    }
    escribir("<", 755, y, titulo30);
    if (mas) {    //La flecha se pone cian si el mouse esta encima, gris si no. 
      fill(127, 231, 255);
    } else {
      fill(220, 230, 240);
    }
    escribir(">", 1025, y, titulo30);

    // Barra de 10 cuadritos: los primeros "valores[i]" van llenos, el resto transparentes.
    // Ejemplo: volumen 5 -> 5 cuadritos llenos y 5 casi invisibles.
    noStroke();
    for (int j = 0; j < 10; j++) {
      if (j < valores[i]) {  
        fill(127, 231, 255);  //color cian(lleno)
      } else {
        fill(127, 231, 255, 50);   // el cuarto número (50) es la opacidad, cian casi invisible(vacio)
      }
      rectE(800 + j * 21, y - 15, 15, 30);   // cada cuadrito 21 px a la derecha del anterior, ademas, de 15 x 30 cada uno.
    }
  }
  //Botón VOLVER dentro del vidrio y debajo de las filas: 
   botonVolver(470, 740);

  // Descripción de la fila que está bajo el mouse (usa el número de fila como posición del arreglo)
  if (filaOpcionEncima != -1) {   // Se da solo si el mouse está sobre alguna fila
    fill(170, 190, 210);
    escribir(descOpciones[filaOpcionEncima], 470, 620, texto40);
  }
}

void pantallaCreditos(){ //La que aparece cuando pantalla = 3, la pantalla de creditos. Por ahora esta sin nada, los creditos se pondran despues.
    image(fondoCreditos, 0, 0);
  botonVolver(60, 1000);   // para regresar al menú
}

void pantallaModos() {   //La que aparece cuando pantalla = 4, la pantalla de los modos(Elegir Historia)
  //Primero se averigua DÓNDE está el mouse (antes de dibujar, para elegir el fondo correcto)
  modoEncima = -1;                         //-1 = ninguna franja(Se pone el fondo sin nada seleccionado)
  if (mouseEncima(0, 0, 1920, 400)) {     //Franja de arriba: CUATRO PAREDES.
    modoEncima = 0;
  }
  if (mouseEncima(0, 400, 1920, 710)) {    //Franja del medio: EN VIVO.
    modoEncima = 1;
  }
  if (mouseEncima(0, 710, 1920, 1080) && !mouseEncima(0, 950, 430, 1080)) {   //Franja de abajo: RASTRO VIRAL, se excluye la esquina del botón "VOLVER"
    modoEncima = 2;
  }

  //Luego se dibuja: la normal si no hay ninguna, o la variante de esa franja.
  if (modoEncima == -1) {
    image(fondoModos, 0, 0);
  } else {
    image(fondoModoEncima[modoEncima], 0, 0);   //modoEncima vale 0, 1 o 2: justo la casilla del arreglo.
  }

  botonVolver(60, 1000);   //Va en la esquina oscura de abajo a la izquierda.
}

void pantallaGameover(){  //La que aparece cuando pantalla = 90, la pantalla de game over(cuando el bienestar llega a 0)
  image(fondoGameover, 0, 0);  
  gameoverEncima = -1;   //Se supone que el mouse esta encima de ningun boton primero.
  textAlign(CENTER, CENTER);  
  //Se dibuja el mensaje de motivo de perdida en el centro, junto con una "reflexion"
  fill(220, 230, 240);  //Color blanco azulado
  escribir("Tu bienestar llegó a 0.", 960, 420, texto44);
  fill(127, 231, 255);   //Color cian. 
  escribir("Desconectarse a tiempo también es ganar.", 960, 480, texto40);

  //Botones:
  if(mouseEncima(660, 580, 1260, 660)){
    gameoverEncima = 0;  //Encima del boton de "Reintentar"
    fill(127, 231, 255);  //Se ilumina de color cian si el mouse esta encima. 
  }else{
    fill(200, 210, 225);  //Se dibuja gris claro si no.
  }
  escribir("REINTENTAR", 960, 620, titulo40);  
  
  if(mouseEncima(480, 680, 1440 , 760)){
    gameoverEncima = 1;  //Encima del boton de "Elegir historia" --> Vuelve a la pantalla 4.
    fill(127, 231, 255);  //Se ilumina de color cian si el mouse esta encima. 
  }else{
    fill(200, 210, 225);  //Se dibuja gris claro si no.
  }
  escribir("VOLVER A ELEGIR HISTORIA", 960, 720, titulo40); 
}

//Esta funcion es de "auxilio" para cuando alguien quiera reintentar el minijuego base nuevamente:
void reintentar(){  //Por ahora esta en una fase temporal, ya que inicializa las variables del modo 1 por ahora. 
  bienestar = 70;   //El bienestar con el que arranca el modo 1.
  juego1.empezar();
  cambiarPantalla(25);  
}



