/* ======================================================================
 *  DIS(CONNECTED) — Alternative Studios
 *
 *  Pestañas:
 *    Disconnected        -> variables generales, setup(), funciones de ayuda GENERALES y draw()
 *    Pantallas           -> intro, menú, opciones, créditos y elegir historia (lo que se DIBUJA)
 *    Controles           -> teclado y mouse: keyPressed(), mouseReleased() y sus ayudantes
 *    Modo1, Modo2, Modo3 -> una pestaña por historia o modo de juego
 *
 *  Números de pantalla (variable "pantalla"):
 *    0        = Intro (logo del estudio + pantalla de título)
 *    1        = Menú principal
 *    2        = Opciones
 *    3        = Créditos
 *    4        = Elegir historia
 *    5 a 19   = libres (para pantallas generales nuevas)
 *    20 a 39  = Modo 1: CUATRO PAREDES   (empieza en la 20)
 *    40 a 59  = Modo 2: EN VIVO          (empieza en la 40)
 *    60 a 79  = Modo 3: RASTRO VIRAL     (empieza en la 60)
 *    Se reservan 20 pantallas para cada modo, por si se necesitan más adelante.
 *    La idea es usar muchas menos, pero si se necesitan más, ya están reservadas.
 *
 *  Todas las posiciones están pensadas en una pantalla de 1920 x 1080 y se
 *  multiplican por escalaX / escalaY para que el juego se vea igual en
 *  cualquier pantalla. TEMPORALMENTE se habilitará la opción de TAB, que muestra
 *  los FPS y las coordenadas del mouse.
 * ====================================================================== */

import processing.sound.*;  //Esta línea trae la librería de sonido de Processing (la que nos da SoundFile).

// ======================================================================
//  VARIABLES GLOBALES
//  Se declaran aquí arriba, fuera de cualquier función, para que TODAS
//  las funciones (de todas las pestañas) puedan leerlas y cambiarlas.
// ======================================================================

//--------------------------------Variables de pantalla, escala y transición de pantallas-----------------------------
int pantalla = 0;        //Número de la pantalla actual: esta variable es la que decide qué se muestra en cada momento.
float escalaX, escalaY;  //Variables de escala para que el juego se vea igual y funcione bien en todas las pantallas.
float Degradado = 0;     //Opacidad del degradado a negro en la transición entre pantallas (0 = transparente, 255 = todo negro).
int Introinicio = -1;    //Guarda el valor de millis() en el momento en que arrancó la intro (con millis() - Introinicio se sabe cuánto tiempo ha pasado). -1 = la intro todavía no ha empezado.
boolean vercoordenadas = false; //Define si se ven o no las coordenadas con TAB (por defecto no se muestran).
boolean sobreBoton = false;     //true si en esta foto el mouse está sobre algún botón (para cambiar el cursor a la manito).

//--------------------------Imágenes--------------------------
//A continuación, las variables que guardarán imágenes:
PImage fondoLogo, fondoTitulo, fondoMenu, fondoOpciones, fondoCreditos, fondoModos, fondoGameover;

//--------------------------Fuentes (tipos de letra)--------------------------
/* Usaremos mucho esto, ya que en lo máximo posible generaremos
   casi todo el texto del juego con las funciones que nos
   proporciona Processing para esto. Aclaraciones a tener en cuenta:
   - PFont es el tipo de variable que guarda una fuente YA con un tamaño.
     Cada tamaño se crea una sola vez en setup(). Si constantemente
     usáramos textSize() para cambiar el tamaño, Processing tendría que
     rehacer la fuente todo el tiempo, y eso suele trabar mucho el juego
     (hablo desde la experiencia).
   - El número del nombre de cada variable de fuente es el tamaño de la fuente
     (los píxeles son pensados en 1920 x 1080). */
PFont titulo56, titulo48, titulo40, titulo30; //Usan la fuente "Press Start 2P": títulos y botones (mayúsculas sin tilde).
PFont texto44, texto40, texto36, texto26;     //Usan la fuente "VT323": textos largos y subtítulos (sí acepta tildes).

//--------------------------Sonido--------------------------
SoundFile musica;   //Variable que guardará la música de fondo del juego en las pantallas de inicio.
int Volmusica = 5;  //Volumen de la música de fondo (se puede cambiar de 0 a 10 en Opciones).
int Volefectos = 5; //Volumen de los efectos de sonido (se puede cambiar de 0 a 10 en Opciones).


// ======================================================================
//  SETUP()
//  Processing la ejecuta UNA sola vez, al arrancar el juego.
//  Aquí se prepara la pantalla y se carga TODO (imágenes, fuentes y música).
// ======================================================================
void setup() {
  fullScreen();   //Pantalla completa (usa JAVA2D, el dibujador que Processing trae por defecto).
  noSmooth();     //Desactiva el suavizado de bordes, para que el pixel art se vea nítido y no borroso.
  frameRate(60);  //draw() se repetirá 60 veces por segundo, para que el juego se vea fluido.

  escalaX = width / 1920.0;   //Escala horizontal: el ancho real de la pantalla comparado con 1920.
  escalaY = height / 1080.0;  //Escala vertical: el alto real de la pantalla comparado con 1080.

  /* Fondos: se cargan con la función cargarFondo() (está escrita justo debajo de setup),
  que carga cada imagen y la ajusta al tamaño de la pantalla al mismo tiempo. */
  fondoLogo     = cargarFondo("fondos/logo.jpg");
  fondoTitulo   = cargarFondo("fondos/titulo.jpg");
  fondoMenu     = cargarFondo("fondos/fondomenu.jpg");
  fondoOpciones = cargarFondo("fondos/fondoopciones.jpg");
  fondoCreditos = cargarFondo("fondos/fondocreditos.jpg");
  fondoModos    = cargarFondo("fondos/fondomodos.jpg");
  fondoGameover = cargarFondo("fondos/gameover.jpg");
  for(int i = 0; i < 3; i++){
  fondoModoEncima[i] = cargarFondo("fondos/fondomodos" + (i + 1) + ".jpg");   //i = 0 carga fondomodos1, i = 1 fondomodos2, i = 2 fondomodos3 --> Es una manera mas facil y dinamica de cargar los fondos al momento de elegir la historia.
  }

  //Fuentes: creamos las fuentes; el tamaño se multiplica por escalaY.
  titulo56 = createFont("fuentes/PressStart2P-Regular.ttf", 56*escalaY);
  titulo48 = createFont("fuentes/PressStart2P-Regular.ttf", 48*escalaY);
  titulo40 = createFont("fuentes/PressStart2P-Regular.ttf", 40*escalaY);
  titulo30 = createFont("fuentes/PressStart2P-Regular.ttf", 30*escalaY);
  texto44 = createFont("fuentes/VT323-Regular.ttf", 44*escalaY);
  texto40 = createFont("fuentes/VT323-Regular.ttf", 40*escalaY);
  texto36 = createFont("fuentes/VT323-Regular.ttf", 36*escalaY);
  texto26 = createFont("fuentes/VT323-Regular.ttf", 26*escalaY);

  cargarModo1();

  //Música: cargamos la música del juego.
  musica = new SoundFile(this, "audio/musica.mp3"); //Carga la música de fondo de las pantallas de inicio.
  musica.loop();     //La empieza a reproducir y la repite cada vez que termina.
  aplicarVolumen();  //Le pone el volumen inicial (la función está escrita justo debajo de setup).
}


// ======================================================================
//  FUNCIONES QUE USA SETUP()
// ======================================================================

//Carga una imagen y la ajusta al tamaño de la pantalla. Devuelve la imagen con los ajustes aplicados.
PImage cargarFondo(String nombrearchivo) {
  PImage img = loadImage(nombrearchivo);  //Carga la imagen desde la carpeta data.
  img.resize(width, height);              //La estira al tamaño exacto de la pantalla, para que se vea bien en cualquier pantalla.
  return img;                             //Devuelve la imagen cargada y ajustada.
}

/*Aplica el volumen elegido en Opciones a la música.
amp() recibe un número de 0.0 (silencio) a 1.0 (volumen máximo). */
void aplicarVolumen() {
  musica.amp(Volmusica / 10.0);
  ambientemodo1.amp(Volmusica / 10.0);
  musicaMinijuegoBase.amp(Volmusica / 10.0);
}

void efecto(SoundFile sonido){ //Se llama esta funcion cada que se quiera usar algun efecto de sonido.
  sonido.play(1.0, Volefectos / 10.0);  //Hace que suene el efecto respetando el volumen puesto en "Volefectos"
}

/* ======================================================================
   FUNCIONES DE AYUDA QUE USA EL DRAW 
   Algunas partes del codigo tienden a repetirse mucho, por lo que aqui, veremos 
   esas mismas partes resumidas como funciones que se podran llamar en el draw
   cuando se necesiten. Esto hace que el codigo sea mas limpio y entendible.
   ====================================================================== */

void cambiarPantalla(int nuevapantalla) { //Esta funcion cambia la pantalla con un degradado.
    pantalla = nuevapantalla; //Se realiza el cambio de pantalla.
    Degradado = 255; //Se activa el degradado que empieza en negro y se va aclarando en dibujartransicion()

    if(nuevapantalla >= 20 && musica.isPlaying()) {  //"musica" solo suena en las pantallas generales(0 a 19)
        musica.stop();    //entramos a un modo, "musica" se detiene
    }else{
        if(nuevapantalla < 20 && !musica.isPlaying()) {
            musica.loop(); //Volvemos al menu, asi que arranca otra vez a sonar la musica. 
        }
    }
    if(nuevapantalla >= 20 && nuevapantalla <= 24){  //Si se encuentra en alguna de estas pantallas, suena la musica ambiente del modo 1.
        if(!ambientemodo1.isPlaying()){
            ambientemodo1.loop();
            aplicarVolumen();
        }
    }else{
        ambientemodo1.stop();   //Al salir de esas pantallas, se quita la musica. 
    }
    linea = 0;      //Estas son variables de dialogo y deben reiniciarse cada que se cambia de pantalla. (Modos de juego)
    letra = 0;
    lineaTerminada = false;
    inicioPantalla = millis();   //Guarda cuando empezó esta pantalla(Lo usan algunas pantallas del modo 1)

    if(nuevapantalla == 20){  //Al entrar a este modo, se reinician todas las variables relacionadas al modo. 
    bienestar = 70;
    pizzaRecogida = false;
    lataRecogida = false;
    buzoRecogido = false;
    bolsaRecogida = false;
    botellaRecogida = false;
    }
    if(nuevapantalla == 25){   //En la pantalla del minijuego suena su propia música.
        if(!musicaMinijuegoBase.isPlaying()){
            musicaMinijuegoBase.loop();
            aplicarVolumen();
        }
    }else{
        musicaMinijuegoBase.stop();   //En cualquier otra pantalla (Como la del Game over) se apaga.
    }

}

void dibujartransicion(){  //Dibuja un rectangulo negro sobre toda la pantalla que se aclara poco a poco(Para la transicion entre pantallas)
    if(Degradado > 0){
        noStroke();  //Para quitar el borde
        fill(0, Degradado);  //El 0 es que esta negro(en escala de grises) y ademas, empieza totalmente opaco(Con la opacidad como degradado en 255)
        rect(0, 0, width, height);  //rectangulo del tamaño de toda la pantalla.
        Degradado = Degradado - 15; //Mientras que la condicion se cumple, va a hacerse mas transparente y claro frame a frame.  
    }
}

boolean mouseEncima(float x1, float y1, float x2, float y2) {  //Esta funcion calcula si el mouse esta en una area especifica. 
    if(mouseX >= x1*escalaX && mouseX <= x2*escalaX && mouseY >= y1*escalaY && mouseY <= y2*escalaY) {  //Evalua si el mouse se encuentra en esa zona.
        sobreBoton = true;   //avisa que el mouse esta sobre algo que se puede tocar (draw() pone la manito)
        return true;   //el booleano devuelve "true" si el mouse se encuentra ahi y false si no se encuentra ahi.
    }else{
        return false;
    }
}

void rectE(float x, float y, float w, float h) {  //Igual que la funcion de processing de rect(), pero esta las escala sola, ayuda a no tener que hacer la multiplicación cada vez que queramos dibujar un rectangulo.
    rect(x*escalaX, y*escalaY, w*escalaX, h*escalaY);
}

void escribir(String texto, float x, float y, PFont fuente){ //Escribe un texto en coordenadas de 1920 x 1080, con la fuente que se le pase como parametro.
    textFont(fuente);  //Se le pasa la fuente que se quiere usar(recordemos que ya trae su tamaño)
    text(texto, x*escalaX, y*escalaY);  //Se escribe el texto en las coordenadas escaladas.
}

void botonVolver(float x, float y) { //El boton "VOLVER", se usara en varias pantallas. Recibe la posicion del texto (x, y), ej: botonVolver(60, 1000) = abajo a la izquierda.
    volverEncima = mouseEncima(x - 20, y - 40, x + 340, y + 40);  //guarda si el mouse esta encima del boton "VOLVER" (para cambiar el color del boton y para que funcione el click)
    textAlign(LEFT, CENTER);  //El texto empieza en x y queda centrado en y.
    if(volverEncima)  {
        fill(127, 231, 255); //Se pone el boton de color cian si el mouse está encima.
    } else{
        fill(200, 210, 225); //Se mantiene gris claro si el mouse no está encima.
    }
    escribir("< VOLVER", x, y, titulo30);
}

void dibujarCoordenadas(){ //Herramienta TEMPORAL para ver los fps y la posicion del mouse tanto en los pixeles reales, como en las coordenadas de 1920x1080.
    int xjuego = int(mouseX / escalaX); //Asi se pasan las coordenadas de la pc de cada uno, a 1920x1080, se usa la operacion contaria a la usada anteriormente.
    int yjuego = int(mouseY / escalaY); //El int(...) quita los decimales.
    String info = "FPS: " + int(frameRate) + "   |   Pantalla: " + mouseX + ", " + mouseY + "   |   Juego (1920x1080): " + xjuego + ", " + yjuego;

    textFont(texto26);
    textAlign(LEFT,TOP);
    noStroke();
    fill(0, 210); //fondo negro casi opaco
    rect(10, 10, textWidth(info) + 20, 36); //"textWidth()" arroja el ancho del texto escrito en "info", arroja un float con la medida de pixeles de ancho.
    fill(255, 230, 0);  //Para escribir el texto con un color amarillento
    text(info, 20, 14);
}

/* ======================================================================
   DRAW
   ======================================================================*/
void draw(){
    sobreBoton = false;  //Cada foto empieza suponiendo que el mouse no esta sobre ningun boton.

    if(pantalla == 0){
        pantallaIntro();
    }else{
        if(pantalla == 1){
            pantallaMenu();
        }else{
            if(pantalla == 2){
                pantallaOpciones();
            }else{
                if(pantalla == 3){
                    pantallaCreditos();
                }else{
                    if(pantalla == 4){
                        pantallaModos();
                    }else{
                        if(pantalla >= 20 && pantalla < 40) {
                            modo1();
                        }else{
                            if(pantalla>=40 && pantalla < 60){
                                modo2();
                            }else{
                                if(pantalla >= 60 && pantalla < 80){
                                    modo3();
                                }else{
                                    if(pantalla == 90){
                                        pantallaGameover();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    dibujartransicion();  //Esta funcion solo se activa cuando se cambia de pantalla(Degradado > 0)
    if(vercoordenadas){   //Si se presiona TAB, entonces se muestran las coordenadas
        dibujarCoordenadas();
    }


    if(pantalla>= 20 && pantalla <= 25){
        noCursor();   //En estas pantallas del modo de juego 1 no se usa el mouse, asi que se esconde.
    //Cursor: si en esta foto alguna pantalla encontro el mouse sobre un boton (mouseEncima() puso sobreBoton = true),
    //se muestra la manito; si no, la flecha normal.
    }else{
        if(sobreBoton){
            cursor(HAND);    //manito
        }else{
            cursor(ARROW);   //flecha normal
        }
    }
}



