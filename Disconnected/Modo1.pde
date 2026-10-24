/* ======================================================================
 *  MODO 1 — CUATRO PAREDES   (pantallas 20 a 39)
 *
 *  draw() llama a modo1() en cada frame mientras "pantalla" esté entre
 *  20 a 39. Aquí dentro irá un if por cada pantalla del modo, igual que
 *  en draw(): if (pantalla == ...) { ... } else { if (...) { ... } }
 * ====================================================================== */

 //=============================VARIABLES DEL MODO 1=============================
 //---------------------------Imagenes---------------------------
 PImage cuarto1, cuarto2, cuarto3;      //Fondos del cuarto representando sus respectivas fases. 
 PImage minijuegobase1, tutorialbase1, tutorialbase2; //Fondos del minijuego base y del tutorial del minijuego base.
 PImage cajaDialogo;                   //Caja de dialogo donde se verá el dialogo de los personajes

 PImage pizza, lata, buzo, bolsa, botella;   //Los 5 objetos de basura que iran en el minijuego 2. 

 PImage rayo1, rayo2, rayo3;             //Diferentes iconos de rayos para la "racha"
 PImage globo, globobrillante;           //Globo de los mensajes: Normal(No esta seleccionado) e iluminado(Esta seleccionado)
 PImage avisoR;                          //El aviso de "Presiona R" que aparece cuando hay 3 mensajes negativos o mas en la pantalla

 PImage[] Barrabienestar = new PImage[11]; //cuando i = 0 --> Muestra la imagen de Bienestar con 10%, cuando i = 9, muestra la de 100%

//============================MUSICA============================
//----------------------------Musica de fondo----------------------------
SoundFile ambientemodo1;   //Luvia, teclado, mouse clickeando y notificaciones de telefono como el sonido ambiente en que se desarrollaran las primeras escenas.
SoundFile musicaMinijuegoBase;  //La musica del minijuego base(El de los mensajes)
 
//----------------------------Efectos de sonido----------------------------
SoundFile sonidoLetra;     //El sonidito como de "teclado" que acompañara al texto que se producira cuando los personajes hablen(Sirve para los 3 modos)
SoundFile sonidoError;     //El sonidito que sonará cuando el jugador se equivoque de tecla en el minijuego base(error leve dependiendo de la tecla)
SoundFile sonidoRayo;      //El sonidito que sonará cuando el rayo de la racha cambie.
SoundFile sonidoGolpe;     //El sonidito que sonará cuando un mensaje negativo golpee a Leo(o cuando pierda vida por llevar varios errores leves)
SoundFile sonidoPositivo;  //El sonidito que sonará cuando el jugador capture un mensaje positivo.
SoundFile sonidoBloqueo;   //El sonidito que sonará cuando el jugador bloquee un mensaje negativo.
SoundFile sonidoVictoria;  //El sonido que sonará si el jugador supera el minijuego base 1.
SoundFile sonidoGameover;  //El sonido que sonará si el jugador pierde el minijuego base 1(Bienestar = 0 manda a la pantalla de Game over)

//---------------------------Variables relacionadas al Dialogo(Sirven para los 3 modos)---------------------------
int linea = 0;             //En que linea de la conversación vamos
int   letra = 0;          //Cuantas letras de la frase se ven, la idea es que suba la cantidad de letras visibles con los frames que pasan.
boolean lineaTerminada = false; //Indica cuando puede aparecer la señal de "Presiona Enter para continuar". Si esta en false, se esta escribiendo aun la linea de dialogo.

//---------------------------Tiempo---------------------------
int inicioPantalla = 0;     //Indica el momento en que se entra a la pantalla con millis().

//---------------------------Minijuego Base 1: Frases ---------------------------
//Los 3 arreglos(listas) de frases del minijuego. El Juego las recibe en su constructor y se las pasa a cada globo.
//Las frases son cortas para que quepan dentro del globo.
String[] negativosM1 = {"Eres un desastre", "Desinstala, no sirves", "Te voy a reportar", "Por tu culpa perdemos",
                        "Juegas fatal", "Inútil", "Sal del juego ya"};                       //Insultos del equipo de Leo.
String[] positivosM1 = {"Te extraño, Leo", "Eres mi mejor amigo", "Te quiero mucho, hijo",
                        "Estoy orgullosa de ti", "Cuenta conmigo, Leo", "Aquí estoy para ti"};  //Mensajes de su mamá y de Sofía.
String[] neutrosM1   = {"Skins al 50%", "Nueva temporada", "Evento diario activo", "Mantenimiento a las 3 a.m.",
                        "Recompensa diaria", "Pase de batalla nuevo"};                       //Spam del juego.

//---------------------------Minijuego base 1: objetos---------------------------
Avatar leo;        //El personaje del minijuego: el punto hacia donde viajan los mensajes.
Juego juego1;      //El minijuego base del Modo 1.

//---------------------------Estado del modo 1---------------------------
int bienestar = 70;   //De 0 a 100 y de 10 en 10, es como la "vida" del jugador, si es igual a 0, significa "Game Over"
//Bienestar arranca en 70 porque Leo desde un principio no esta bien, lleva 3 dias encerrado en su cuarto y eso es nocivo para cualquier persona.
boolean pizzaRecogida = false, lataRecogida = false, buzoRecogido = false, bolsaRecogida = false, botellaRecogida = false;
//En los booleanos de arriba: False --> Sigue la basura en el piso.  True --> Se recogió la basura.



//===========================CARGA DE TODO EL MODO 1===========================
//Esta funcion se llamará una vez desde Setup, y se hace con el fin de tener las cosas separadas y no mezclar los modos de juego.
void cargarModo1() {
  //Fondos(Se hace con la misma funcion antes vista): 
  cuarto1 = cargarFondo("fondos/cuarto1.jpg");
  cuarto2 = cargarFondo("fondos/cuarto2.jpg");
  cuarto3 = cargarFondo("fondos/cuarto3.jpg");
  tutorialbase1  = cargarFondo("fondos/tutorialminijuegobase1.jpg");
  tutorialbase2 = cargarFondo("fondos/tutorialminijuegobase2.jpg");
  minijuegobase1 = cargarFondo("fondos/minijuegobase1.jpg");

  //Caja de dialogo(Es una imagen y se dibujará encima del fondo):
  cajaDialogo = loadImage("objetos/caja_dialogo.png");
  cajaDialogo.resize(int(1680*escalaX), 0);  //El int(...) es para que la multiplicacion de un valor entero(resize necesita enteros)
  //El 0 en resize(..., 0) hace que el ancho se redimensione a 1680*escalaX y la altura se redimensione de manera proporcional(Lo hace processing automaticamente con el 0)

  //Basura(Para el minijuego 2): 
  //Como las imagenes son muy grandes, los objetos se cargaran y achicaran al 40% de su tamaño original con resize.
  pizza   = loadImage("objetos/pizza.png");
  pizza.resize(int(pizza.width * 0.4 * escalaX), 0);
  lata    = loadImage("objetos/lata.png");
  lata.resize(int(lata.width * 0.4 * escalaX), 0);
  buzo    = loadImage("objetos/buzo.png");
  buzo.resize(int(buzo.width * 0.4 * escalaX), 0);
  bolsa   = loadImage("objetos/bolsa.png");
  bolsa.resize(int(bolsa.width * 0.4 * escalaX), 0);
  botella = loadImage("objetos/botella.png");
  botella.resize(int(botella.width * 0.4 * escalaX), 0); 

  //Rayos de la racha: Los 3 se cargaran y achicaran puesto que las imagenes son muy grandes.
  rayo1 = loadImage("objetos/rayo1.png");
  rayo1.resize(int(rayo1.width * 0.22 * escalaX), 0); 
  rayo2 = loadImage("objetos/rayo2.png");
  rayo2.resize(int(rayo2.width * 0.22 * escalaX), 0); 
  rayo3 = loadImage("objetos/rayo3.png");     
  rayo3.resize(int(rayo3.width * 0.22 * escalaX), 0);   

  //Globos de los mensajes del minijuego base: Los 2 se cargan y se achican porque son muy grandes.
  globo = loadImage("objetos/globo.png");
  globo.resize(int(420*escalaX), 0);
  globobrillante = loadImage("objetos/globo_brillo.png");
  globobrillante.resize(int(420*escalaX), 0);

  //El png que aparecera cuando se pueda presionar la R:
  avisoR = loadImage("objetos/avisoR.png");
  avisoR.resize(int(800*escalaX), 0);  //La imagen original es muy grande, asi que se reduce a que ocupe 800 pixeles de ancho.

  //Objetos del minijuego base 1: se crean UNA sola vez, al jugar o reintentar,
  //juego1.empezar() los reinicia, así que no hace falta volver a crearlos.
  leo = new Avatar(960, 480);                                     //Primero el avatar (el pecho de Leo, en el centro) --> Hacia donde iran los mensajes.
  juego1 = new Juego(leo, negativosM1, positivosM1, neutrosM1);   //Después el juego, que necesita al avatar y las frases.

  //Barras del bienestar: Como son 10 imagenes, para ahorrar lineas y agilizar el proceso, lo haremos con un for directamente.
  //Aprovecharemos que tienen nombres MUY similares sus archivos para hacer un "atajo" con un ciclo for.
  for( int i = 0; i < 10; i = i + 1){
    Barrabienestar[i+1] = loadImage("objetos/bienestar" + ((i+1)*10) + ".png");
    Barrabienestar[i+1].resize(int(500*escalaX),0);
  }

  //Sonidos:
  ambientemodo1 = new SoundFile(this, "audio/musica_ambiente_modo_1.mp3");
  musicaMinijuegoBase = new SoundFile(this, "audio/musica_minijuegobase.mp3");
  sonidoLetra = new SoundFile(this, "audio/tecla.wav");
  sonidoError = new SoundFile(this, "audio/sfx_error.wav");
  sonidoRayo = new SoundFile(this, "audio/sfx_rayo.wav");
  sonidoGolpe = new SoundFile(this, "audio/sfx_golpe.wav");
  sonidoPositivo = new SoundFile(this, "audio/sfx_positivo.wav");
  sonidoBloqueo = new SoundFile(this, "audio/sfx_bloqueo.wav");
  sonidoVictoria = new SoundFile(this, "audio/sfx_victoria.wav");
  sonidoGameover = new SoundFile(this, "audio/sfx_gameover.wav");
}

//FUNCIONES AUXILIARES PARA modo1():
//Esta funcion pone la pantalla en negra y un texto que aparece poco a poco contando los dias de la semana que faltan para el cumpleaños de Sofia
void tarjetaDia(String dia, String frase, int nueva) {
  background(0);
  int tiempo = millis() - inicioPantalla;   //tiempo guarda los milisegundos desde que se entró a esta pantalla.
  float opacidad = map(tiempo, 0, 1000, 0, 255);   //Recordemos que map(...) convierte el tiempo (0 a 1000 ms) en opacidad (0 a 255) --> Durara aproximadamente un segundo en aparecer el mensaje visible.
  opacidad = constrain(opacidad, 0, 255);          //Recordemos que constrain(...) limita a la opacidad para que no suba de 255(Si no lo hacemos, seguira subiendo con el map)

  textAlign(CENTER, CENTER);
  fill(255, opacidad);                                  //Color del texto que va apareciendo(Blanco = 255, recordemos que es escala de grises)
  escribir(dia, 960, 480, titulo56);
  fill(127, 231, 255, opacidad);                        //La frase se dibuja cian, siguiendo la estetica del juego.
  escribir(frase, 960, 580, texto44);

  if(tiempo > 3500){
    cambiarPantalla(nueva);
  }
}

//==================== DIÁLOGO(SE USAN ESTAS FUNCIONES EN LOS 3 MODOS) ====================
/* Cómo funciona:
   - Cada vez que alguien habla, se llama a hablar() con su número de turno.
   - Solo se dibuja la frase cuyo turno coincide con "linea" (el turno en el que va la conversación).
   - draw() pasa por aquí 60 veces por segundo; cada 2 frames aparece una letra más,
     y así parece que la frase se escribe sola.
   - Aquí el "ciclo" es el mismo draw(), y la variable "letra" hace de "i". */


//Esta funcion dibuja una frase de la conversación, pero SOLO si es su turno.
//turno = número de la frase (0, 1, 2...)--- quien = nombre (en mayúsculas y sin tilde),
//frase = lo que dice ---- r, g, b = color del nombre (igual que en fill(r, g, b)). --> Se puede usar para representar a personajes "Buenos" o "Malos"
void hablar(int turno, String quien, String frase, int r, int g, int b) {
  if(linea != turno){
    return;   //No es su turno, asi que no se dibuja nada y con return sale inmediatamente de la función.
  }

  //Se dibuja la caja de diálogo:
  image(cajaDialogo, 120*escalaX, 650*escalaY);

  if(letra < frase.length()){ //Para que se escriba la frase, las letras mostradas deben ser menores a las letras de la frase completa. 
    if(frameCount % 2 == 0){   //Cada 2 frames se dibuja una letra más.
      letra = letra + 1; 
      efecto(sonidoLetra);      //Cada vez que se escribe una letra, suena el efecto de sonido de "tecla".
    }
    lineaTerminada = false;    //Todavía se está escribiendo la frase. 
  }else{
    letra = frase.length();    //Ya se ve toda la frase y no se escribe más nada. 
    lineaTerminada = true;     //Cambia a true porque ya termina la linea, es como un "semaforo" a usar en el futuro.
  }
  //Se dibuja el nombre, con su color, dentro de la placa pequeña.
  textAlign(LEFT, TOP);
  fill(r, g, b);
  escribir(quien, 292, 795, titulo30);

  //Se escribe la frase desde el principio hasta la posicion de la letra con substring(0, letra) 
  fill(255);  //Se escribe en blanco
  textFont(texto44);
  //Con 4 números como parametros, text() escribe dentro de un rectángulo y salta de línea solo al llegar a ese ancho(al llegar a 1520 px).
  text(frase.substring(0, letra), 206*escalaX, 867*escalaY, 1500*escalaX, 150*escalaY);

  //Cuando la frase está completa, un triangulito va a parpadear cada medio segundo, indicando que ya se completo y que se presione "ENTER" para continuar. 
  if(lineaTerminada && (frameCount / 30) % 2 == 0){
    fill(255);
    triangle(1680*escalaX, 1001*escalaY, 1710*escalaX, 1001*escalaY, 1695*escalaX, 1019*escalaY);
    //El triangulo en processing se dibuja uniendo 3 puntos --> triangle( x1, y1, x2, y2, x3, y3);
  }
}


//Escribe "PRESIONA ENTER PARA CONTINUAR" junto al triangulito, cuando la frase ya terminó.
//Se llama solo en la PRIMERA escena de cada modo, para que el jugador aprenda y lo intuya.
void ayudaEnter() {
  if(lineaTerminada){
    textAlign(RIGHT, CENTER);
    fill(200, 210, 225);
    escribir("PRESIONA ENTER PARA CONTINUAR", 1660, 1010, titulo30);
  }
}


//Cuando la conversación llega a "turnoFinal" ya no hay mas frases, por lo que pasa a otra pantalla.
void finDialogo(int turnoFinal, int nueva) {
  if(linea == turnoFinal){
    cambiarPantalla(nueva);
  }
}


//Se llama al presionar ENTER en una pantalla con diálogo.
void avanzarDialogo() {
  if(lineaTerminada){
    linea++;      //La frase ya estaba completa: siguiente turno.
    letra = 0;    //La nueva frase empieza a escribirse desde la letra 0.
  }else{
    letra = 999; //La frase se estaba escribiendo y ENTER hace que se termine de escribir instantaneamente.
  }
}

//Esta función dibuja los objetos que todavía no se han recogido. Los números son la esquina de arriba a la izquierda de cada objeto.
void dibujarBasura() {
  if(!pizzaRecogida){
    image(pizza, 1180*escalaX, 500*escalaY);
  }
  if(!lataRecogida){
    image(lata, 860*escalaX, 640*escalaY);
  }
  if(!buzoRecogido){
    image(buzo, 1400*escalaX, 720*escalaY);
  }
  if(!bolsaRecogida){
    image(bolsa, 1020*escalaX, 700*escalaY);
  }
  if(!botellaRecogida){
    image(botella, 1620*escalaX, 560*escalaY);
  }
}

//Esta funcion dibuja la barra de bienestar arriba a la derecha, se debe ver durante todo el modo menos en las tarjetas de los dias.
void dibujarBarra() {
  if(bienestar > 0){
    image(Barrabienestar[bienestar / 10], 1380*escalaX, 30*escalaY);
  }
}

//Esta funcion dibuja el "rayito" de la racha del minijuego base, que cambia entre mayor sea la racha.
void dibujarRacha() {
  if(juego1.racha <= 7){
    image(rayo1, 50*escalaX, 30*escalaY);
  }else{
    if(juego1.racha <= 15){
      image(rayo2, 50*escalaX, 30*escalaY);
    }else{
      image(rayo3, 50*escalaX, 30*escalaY);
    }
  }
  textAlign(LEFT, CENTER);
  fill(255);
  escribir("x" + juego1.racha, 200, 100, titulo40);
}

//Esta funcion dibuja y controla el minijuego base 1(Pantalla 25). Se ejecuta en cada frame.
void minijuegoBase1(){
  leo.danoRecibido(minijuegobase1);   //Dibuja basicamente el fondo, ya sea normal, o con el efecto de temblor y destello rojo si a leo lo acaban de golpear.
  juego1.dibujarAvisoR();             //Este metodo dibuja el aviso "PRESIONA R"(Solo aparece con 3 negativos o mas)
  juego1.actualizar();                //Este metodo lanza globos nuevos, los mueve, revisa choques y los dibuja.
  dibujarBarra();                     //Este metodo dibuja a la barra de bienestar arriba a la derecha
  dibujarRacha();                     //Este metodo dibuja la racha arriba a la izquierda.
  //Estos mensajes se dibujan en "orden", siguiendo un dibujo por capas donde la barra del bienestar y la interfaz de la racha se dibujan por encima de todo.

  //El tiempo que le queda al jugador para que se acabe el minijuego se dibujara arriba en el centro.
  int restante = 60 - juego1.tiempo() / 1000;  //juego1.tiempo / 1000 cambia el valor de tiempo de millis() a segundos.
  textAlign(CENTER, CENTER);                   //Se escribirá tomando a (x, y) como el centro.
  fill(255);                                   //Color blanco. 
  escribir("" + restante, 960, 80, titulo48);  //"" + numero lo vuelve texto.

  //Ahora se evaluan las 2 posibilidades para que el juego se acabe:
  if(bienestar <= 0){   //Si se queda sin bienestar, directamente pierde y se va a la pantalla de Game over.
    efecto(sonidoGameover);
    cambiarPantalla(90);      
  }else{
    if(juego1.terminado()){   //Si logra terminar el juego (tiempo > 60s) entonces gana el juego y pasa a la siguiente pantalla.
      efecto(sonidoVictoria);
      cambiarPantalla(4);
    }
  }
  
}
//===========================modo1(): EL "DIRECTOR" DEL MODO===========================
//draw() llama a modo1() cuando pantalla está entre 20 y 39. Aquí se elige qué pantalla dibujar.
//Las pantallas grandes llaman a su función; las escenas de diálogo se escriben aquí mismo.
void modo1() {
  if(pantalla == 20){
    tarjetaDia("LUNES", "Faltan 5 días para el cumpleaños de Sofía", 21);
  }else{
    if(pantalla == 21){
      //Escena 1 — El pozo. Cada vez que alguien habla es una llamada a hablar() (4 turnos: 0, 1, 2 y 3).
      //Colores: ToxicBoy99 en rojo, Leo en cian, Mamá en amarillo pastel.
      image(cuarto1, 0, 0);
      dibujarBasura();

      hablar(0, "TOXICBOY99", "¡Bro, eres un desastre! Si perdemos esta de ascenso, te reporto masivamente para que te baneen la cuenta.", 255, 90, 90);
      hablar(1, "MAMA", "Leo, hijo, ¿vas a cenar hoy? Llevas tres días sin salir de ese cuarto. Me tiene preocupada no verte la cara.", 255, 233, 160);
      hablar(2, "LEO", "¡Ma, estoy en una partida competitiva! ¡No tiene pausa, ahorita salgo!", 127, 231, 255);
      hablar(3, "MAMA", "Ah, y llamó Sofía: el sábado celebra su cumpleaños en el parque, a las 4. Dice que esta vez no le falles.", 255, 233, 160);
      hablar(4, "LEO", "Sí, sí, claro que voy... Faltan cinco días, hay tiempo.", 127, 231, 255);
      finDialogo(5, 22);

      ayudaEnter();        //Solo en esta escena, por ser la primera del modo.
      dibujarBarra();
    }else{
      if(pantalla == 22){
        tarjetaDia("MIENTRAS TANTO...", "En la partida, el chat no para de escribir y Leo tiene que decidir qué responder...", 23); //Aprovecharemos esta funcion para mostrar la transicion hacia el minijuego base 1. 
      }else{
        if(pantalla == 23){
          image(tutorialbase1, 0, 0);  //Pantalla de tutorial 1 --> Se explican los controles. ENTER pasa a la pantalla de tutorial 2. 
        }else{
          if(pantalla == 24){
            image(tutorialbase2, 0, 0); //Pantalla de tutorial 2 --> Se explican las dinamicas del juego relacionadas al bienestar
            //ENTER pasa al minijuego, ESC vuelve a la pantalla de tutorial 1
          }else{
            if(pantalla == 25){
              minijuegoBase1();    //Se llama a la funcion del minijuego base(Los mensajes)
            }
          }
        }
      }
    }
  }
}
