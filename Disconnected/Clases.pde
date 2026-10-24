/* ======================================================================
   CLASES DEL JUEGO (En este caso, vamos a tratar las clases del minijuego base)
   Contexto rapido: 
   Una CLASE es un "molde": dice qué datos tiene una cosa (atributos) y
   qué sabe hacer (con métodos = funciones dentro de la clase). Con "new" se
   crea un OBJETO a partir del molde.
    Estas son las clases recomendadas y que piden en el documento del laboratorio:
     Mensaje -> cada globo que viaja hacia el personaje.
     Avatar  -> el personaje del centro (Leo, Mateo o Sofía).
     Juego   -> el minijuego completo: guarda los 10 mensajes en un
                ARREGLO, el tiempo, la racha, los errores y la R.

   Cada modo crea su propio Avatar y su propio Juego con sus frases, así
   que el MISMO código sirve para las tres historias.

   Dentro de una clase se pueden usar las variables globales del juego
   (bienestar, globo, escalaX...), porque en Processing todas las
   pestañas forman un solo programa.
   ====================================================================== */

//=============================== MENSAJE ===============================
class Mensaje {
//-----------------------------Aqui iran los atributos: ------------------------
float x, y;      //Donde está el mensaje ahora
float velocidad; //Cuantos pixeles avanza en cada frame que pasa
int tipo;        //Hay 3 tipos ---> 0 = Negativo, 1 = Positivo, 2 = Neutro
String texto;    //Lo que dice el globo del mensaje
boolean activo;  //true = se muestra en pantalla, false = No se muestra en la pantalla.

//-----------Constructor: se ejecuta al hacer "new Mensaje()" -------------------
Mensaje() {
    activo = false;    //Esto es lo unico "fijo" para todos los mensajes que se vayan a crear, todos empiezan apagados, el juego los prende cuando los necesita. 
}

//-----------Metodos--------------
/*El siguiente metodo inicia el globo en un borde al azar, con un tipo y una frase(de un arreglo) al azar.
  Empieza en un borde de la pantalla al azar(Puede ser abajo, a la derecha o a la izquierda, pero arriba no porque arriba va el hud de bienestar, racha, etc..) y
  la idea es que el mensaje viaje del borde hacia el personaje que esta en el centro.*/
void iniciar(float vel, String[] negativos, String[] positivos, String[] neutros){
    int lado = int(random(3));   //random(3) da un numero cualquiera entre 0 y 2.999, hacemos que sea entero con int() para que de 0, 1 o 2.
    if(lado == 0){   //Si lado = 0, entonces aparece en el lado izquierdo
        x = -120;    //Aparece un poco afuera de la pantalla, el centro aparece afuera para que se vea como va entrando poco a poco en la pantalla.
        y = random(300, 1000);    
    }else{
        if(lado == 1){     //Si lado = 1, entonces aparece en el lado derecho.
            x = 2040;      //Aparece nuevamente algo afuera de la pantalla. 2040 = 1920 + 120
            y = random(300,1000); 
        }else{
            x = random(200, 1720);  //Si lado = 2, entonces aparece en algun lugar aleatorio abajo de la pantalla.
            y = 1180;               //Aparece algo afuera de la pantalla. 1180 = 1080 + 100.
        }
    }

    tipo = int(random(3));    //Los mensajes pueden ser de 3 tipos, negativos, positivos o neutros.
    //Se elige una frase al azar de la lista de su tipo. 
    if(tipo == 0) {  //Si tipo = 0 entonces toma los mensajes de un arreglo de mensajes negativos, arreglo que luego se definira dependiendo del modo de juego
    texto = negativos[int(random(negativos.length))];   //En arreglos, el .lenght, toma la cantidad de elementos de ese arreglo, en este caso, se refiere a la cantidad de frases.
    }else{
        if(tipo == 1) { //Si tipo = 1 entonces toma los mensajes de un arreglo de mensajes positivos.
            texto = positivos[int(random(positivos.length))];
        }else{
            texto = neutros[int(random(neutros.length))];
        }
    }

velocidad = vel;  
activo = true;      //Una vez habiendo configurado el texto a escribir y la posicion de aparicion, finalmente el mensaje aparece en pantalla.
}
  //Este metodo arroja la distancia del globo de mensaje a un punto (se usa para saber la distancia entre el mensaje rodante y el personaje que esta en el medio)
  //Con esto, se puede saber si esta cerca, si lo toca o no, etc..
  float distancia(float metaX, float metaY) {
    return dist(x, y, metaX, metaY); //dist(x1, y1, x2, y2) es una funcion de processing que calcula la distancia entre 2 puntos.
  }
//Este metodo hace que el mensaje avance en linea recta y de manera proporcional hacia el punto
//(metaX y metaY son los puntos donde esta el personaje)
void mover(float metaX, float metaY){
    float d = distancia(metaX, metaY);  //Llamamos al metodo de arriba.
  //((metaX - x) / d) es la "dirección" y proporcion a la que se movera el mensaje en la componente x.
  //Multiplicado por la velocidad, calcula cuanto se movera en cada frame.
  x = x + (metaX - x) / d * velocidad;
  y = y + (metaY - y) / d * velocidad;   
}

//Este metodo dibuja el globo con su texto. brillante = true si es el que esta mas cerca(responde a las teclas)
void dibujar(boolean brillante){
    imageMode(CENTER);    //Para que (x, y) sea el CENTRO del globo y no su esquina.
    if(brillante){
        image(globobrillante, x*escalaX, y*escalaY);
    }else{
        image(globo, x*escalaX, y*escalaY);
    }
    imageMode(CORNER);   //Se devuelve a la configuracion normal para no dañar las demas imagenes que se dibujen.

    fill(0); //El texto se dibujará con color negro sobre el globo blanco. 
    textAlign(CENTER, CENTER); 
    escribir(texto, x, y - 5, texto26);   //Ligeramente hacia arriba con y - 5, porque el globo tiene la "colita" abajo.
    }
}

//=============================== AVATAR ===============================
class Avatar{    //Por ahora una clase algo "simbolica" y sujeta a cambios, ya que realmente tiene pocas propiedades y sus atributos son especificamente para el minijuego base.
    float x, y;        //Los puntos x y y donde se encuentra el personaje, son el punto hacia donde llegan los mensajes.
    int inicioGolpe;   //Guarda el valor de millis() en el instante en que el personaje recibe un golpe.
   //(Importante para hacer una animación de temblor y destello rojo cuando el personaje reciba daño)

   Avatar(float px, float py){
    x = px;
    y = py;
    inicioGolpe = 0;
   }

   //Este metodo se llama cuando un mensaje negativo lo alcanza o cuando se equivoca o cuando acumula 2 errores leves. 
   void golpe() {
    inicioGolpe = millis();
   }
   
   //Este metodo devuelve si estamos en los primeros 150 ms desde que el personaje recibio un golpe.
   boolean golpeado(){
    return millis() - inicioGolpe < 150;
   }

   //Este metodo se llama cuando el personaje acaba de recibir un golpe y se encuentra en ese rango de esos 150 ms,
   //el fondo tiembla y se pinta un destello rojo encima(solo por ese tiempo). Si no, dibuja el fondo normal.
   void danoRecibido(PImage fondo){
    if(golpeado()){
        background(0);           //Para que se vea negra la parte de atras del fondo al rodarla.
        image(fondo, random(-8, 8) * escalaX, random(-8, 8) * escalaY);  //El fondo se mueve unos pixeles al azar en cada frame (generando el efecto de "temblor").
        noStroke();             //Quita los bordes del rectangulo rojo que se dibujara en toda la pantalla 
        fill(255, 0, 0, 80);        //Se hace el destello con un rectangulo rojo con opacidad 80 de 255 (destello).
        rect(0, 0, width, height);  //El rectangulo ocupa toda la pantalla
    }else{
        image(fondo, 0, 0);       //Sin golpe: el fondo sigue normal.
    }
   }
}

//=============================== JUEGO ===============================
class Juego {
    //----------Atributos-----------
    Mensaje[] mensajes = new Mensaje[10];      //Arreglo con las 10 "casillas" donde se guardan los globos de mensajes.
    //No se crean globos nuevos cada vez que sale uno: estos 10 se crean UNA sola vez (en el constructor) y se reusan.
    Avatar avatar;               //El personaje de este modo.
    String[] negativos, positivos, neutros; //Las frases de este modo (se crean en la pestaña de cada modo).
    int inicio;              //millis() en el que empezó el minijuego (para saber cuándo termina). Recordemos que el minijuego va a durar 60 segundos.
    int ultimoMensaje;       //millis() del último globo creado (para que salgan con un tiempo de distancia).
    int racha;               //Aciertos seguidos.
    int errores;             //Errores leves acumulados (2 acumulados = -10 de bienestar).
    float radioAnillo = 850; //Solo los globos dentro de este círculo invisible responden a las teclas(Se iluminan y se pueden reaccionar frente a las teclas)
    float latido = 1;            //Tamaño actual del aviso "PRESIONA R" (1 = tamaño normal). Crece y se encoge para que parezca que "late"--> Esto es para que se vea mas estetico.
    float cambioLatido = 0.006;  //Cuánto cambia el tamaño en cada frame. Si es positivo crece, si es negativo se encoge(El hecho de ser negativo o positivo se determinara en la funcion)

    //---------- Constructor ----------
    Juego(Avatar a, String[] neg, String[] pos, String[] neu) {  //Solo se ponen otros nombres para no repetir los mismos de los atributos pero se refieren todos a lo mismo.
    avatar = a;
    negativos = neg;
    positivos = pos;
    neutros = neu;
    //OJO: "new Mensaje[10]" solo crea las 10 CASILLAS vacías (null).
    //Hay que crear cada objeto, uno por uno:
    for (int i = 0; i < 10; i++) {
      mensajes[i] = new Mensaje();  //Esto hace que tengamos de forma predeterminada 10 "globos" apagados, y que usemos ese arreglo como base para el minijuego, solo cambiando los datos de cada casilla cada vez.
        }
    } 
    
    //---------- Métodos ----------
    //Este metodo deja todo listo para jugar. Se llama una vez al entrar a la pantalla del minijuego,
    //(o otra vez si el jugador reintenta despues de un game over). 
    void empezar(){
        for(int i = 0; i < 10; i = i + 1){
            mensajes[i].activo = false;   //Todos los globos salen apagados(La pantalla empieza sin mostrar mensajes)
        }
        inicio = millis();          //El reloj del minijuego(de 60 segundos) arranca a partir de este valor.
        ultimoMensaje = millis();  //El primer globo saldrá despues de este valor en millis.
        racha = 0;
        errores = 0;
    }

    //Este metodo devuelve cuantos milisegundos lleva el minijuego desde que se inició.
    int tiempo(){
        return millis() - inicio;
    }

    //Este metodo devuelve true cuando ya pasaron los 60 segundos: el jugador sobrevivió en ese caso.
    boolean terminado(){
        return tiempo() >= 60000;
    }

    //Este metodo devuelve el numero de fase del minijuego en que se encuentra:
    //Fase 1, 2 o 3: La dificultad va a subir cada 20 segundos.
    int fase() {  //De 0 a 19,9 segundos --> fase 1. De 20 a 39,9 s --> fase 2; de 40s en adelante ..> fase 3.
        return constrain(tiempo() / 20000 + 1, 1, 3); //La funcion constrain() es nativa de processing y 
        //evita que pase de 3 la variable fase(por si sigue corriendo el tiempo)
    }

    //Este metodo devuelve la casilla del globo encendido mas cercano al personaje que esté dentro del anillo.
    //o -1 si no hay ninguno. El globo que se encuentre en ese rango es el que se ilumina y el unico al que afectan B y C.
    int masCercano() {
        int casillaElegida = -1;              //Todavía no hay ningun mensaje/casilla elegido.
        float menorDistancia = radioAnillo;           //Arranca en el borde del anillo: lo que esté más lejos no cuenta.
        for (int i = 0; i < 10; i++) {
            if (mensajes[i].activo && mensajes[i].distancia(avatar.x, avatar.y) < menorDistancia) {
                menorDistancia = mensajes[i].distancia(avatar.x, avatar.y);   //Toma un globo de mensaje y le asigna "menorDistancia" 
                //si el globo esta adentro del radioAnillo y es el globo de mensaje mas cerca al avatar, lo guarda en esta variable y se actualiza cada frame. 
                casillaElegida = i; //Guarda el numero de casilla del globo mas cercano
            }
        }
        return casillaElegida;  //Devuelve el numero de casilla del globo mas cercano
    }

    //Este metodo evalua lo que pasa cuando un globo alcanza al personaje sin que el jugador reaccionara.
    void llego(Mensaje m) {
        m.activo = false;                    //Si llega al personaje, el globo desaparece (su casilla queda libre).
        if (m.tipo == 0) {                   //Negativo que no se bloqueó: le hace daño.
            bienestar = bienestar - 10;
            avatar.golpe();                  //Activa el temblor y el destello rojo.
            efecto(sonidoGolpe);             //Suena el efecto de sonido de "Golpe"
            racha = 0;                       //La racha se reinicia
        } else {
            if (m.tipo == 1) {               //Positivo que no se contestó: no quita bienestar, pero rompe la racha.
                racha = 0;                     
            }
        }                                    //Neutro (tipo 2): no pasa nada, estaba bien dejarlo pasar.
        bienestar = constrain(bienestar, 0, 100);   //La funcion constrain() es nativa de processing y hace que la variable "bienestar" nunca baje de 0 ni pase de 100.
    }
    
    //Este metodo se llama una vez por frame desde la pantalla del minijuego y hace 2 cosas:
    //1 --> Lanza un globo nuevo si ya pasó el tiempo de espera entre globos.
    //2 --> Mueve, revisa y dibuja los globos encendidos.
    void actualizar(){
        //Esta parte del metodo es encargado del apartado 1. 
        int espera = 1750 - fase() * 350;
        //El tiempo de espera entre globos baja con la fase: fase 1 --> 1400 ms. fase 2 --> 1050 ms. fase 3 --> 700 ms.
        if(millis() - ultimoMensaje > espera){  //Evalua si ya pasó el tiempo de espera --> Se enciende otro mensaje. 
            for(int i = 0; i < 10; i = i + 1){  
                if(!mensajes[i].activo){  //Toma a la primera casilla de globo de mensaje que este "apagada"
                mensajes[i].iniciar(2 + fase() * 1.5, negativos, positivos, neutros);
                //La velocidad aumenta segun la fase --> fase 1 = 3,5. fase 2 --> 5. fase 3 --> 6,5.
                ultimoMensaje = millis();    //Se actualiza el valor de "ultimoMensaje" cada que se inicia uno.
                break;   //Ya lanzó un mensaje, asi que se sale del for para no lanzar varios a la vez. 
                }
            }
        }

        //Esta parte del metodo es el encargado del apartado 2.
        //En este apartado se mueven, evaluan y dibujan los mensajes. 
        int elegido = masCercano();       //Toma la casilla del globo mas cercano al avatar(-1 si no hay ninguno en el radio del anillo)
        for(int i = 0; i < 10; i = i + 1) {
            if(mensajes[i].activo){  //Toma solo los mensajes activos para dibujarlos.
                mensajes[i].mover(avatar.x, avatar.y); 
                if(mensajes[i].distancia(avatar.x, avatar.y) < 60){    //Si se cumple esto, el mensaje "Colisiona" porque se acerca mucho al avatar y lo golpea.
                llego(mensajes[i]);
                }else{
                    mensajes[i].dibujar(i == elegido);  //i == elegido da true solo para el mas cercano.
                    //Si es asi, entonces se dibuja brillante, sino, se dibuja normal
                }
            }
        }
    }
    
    //Este metodo cuenta cuantos globos negativos hay encendidos en la pantalla(Para saber si la R se puede usar)
    int contarNegativos(){
        int cuenta = 0;
        for(int i = 0; i < 10; i = i + 1){
            if(mensajes[i].activo && mensajes[i].tipo == 0){ //Si el mensaje es negativo y se esta mostrando en la pantalla, entonces suma para el contador.
                cuenta = cuenta + 1;
            }
        }
        return cuenta;
    }

    //Este metodo dibuja el aviso de "PRESIONA R" con un efecto en el que parece que esta "latiendo" en la parte de arriba, solo si hay 3 o mas negativos en pantalla.
    void dibujarAvisoR(){
        if(contarNegativos() >= 3){
            latido = latido + cambioLatido;    //Cada frame crece(o se encoge un poquito)
            if(latido > 1.06 || latido < 0.94){  //Evalua si llegó al tamaño maximo(106%) o si llegó al tamaño minimo(94%)
                cambioLatido = -cambioLatido;    //Cambia de dirección, si crecia, ahora se encoge, y al reves pasa igual.
            }
            imageMode(CENTER);  //Para que (x, y) sea el centro de la imagen y crezca hacia todos los lados por igual.
            image(avisoR, 960*escalaX, 200*escalaY, avisoR.width*latido, avisoR.height*latido);  //avisoR.width y avisoR.height arrojan el ancho y alto de la imagen guardada en la variable avisoR.
            //Con 5 parametros, image() dibuja la imagen con ese ancho y alto, por eso, el ancho y alto se multiplica por el "latido" en ese frame.
            imageMode(CORNER);  //Se vuelve a poner la configuración predeterminada de processing para no dañar la configuracion de las futuras imagenes.
        }
    }

    //Este metodo se llama cuando el jugador presiona la tecla equivocada sobre el globo elegido (error leve):
    //B sobre un mensaje positivo, o C sobre un mensaje negativo. Los neutros no cuentan: se pueden bloquear o capturar sin consecuencias.
    void errorLeve(){   //Recordemos que se llama cada que se comete un error leve
        errores = errores + 1;   //Se suma la cantidad de errores leves en 1
        racha = 0;           //Se reinicia la racha.
        efecto(sonidoError); //Suena el sonidito de error leve.
        if(errores == 2){   //Si se acumulan 2 errores leves, el jugador pierde bienestar.
            bienestar = bienestar - 10;
            avatar.golpe();         //El segundo error si se siente como un golpe(Se activa el destello y temblor)
            efecto(sonidoGolpe);    //Pierde bienestar asi que suena el sonidito de golpe.
            errores = 0;            //Se reinicia el contador de errores leves a 0.

        }
    }

    //Este metodo se llamará desde keyPressed() con la tecla que se presionó --> juego1.tecla(key)...
    //Se hace con el fin de ahorrar lineas en la funcion de keyPressed() y tener la información mejor organizada.
    void tecla(char k){
        //R: Limpiar
        //Recordemos que R borra TODOS los negativos de la pantalla, pero solo si hay 3 o mas en pantalla. 
        if(k == 'r' || k == 'R'){
            if(contarNegativos() >= 3){
                for(int i = 0; i < 10; i = i + 1){
                    if(mensajes[i].activo && mensajes[i].tipo == 0){  //El for toma a los valores negativos que se muestran en pantalla
                        mensajes[i].activo = false;            //Los toma y los pone en false(los elimina)
                        racha = racha + 1;                     //Cada negativo borrado cuenta como acierto para la racha.
                    }
                }
                efecto(sonidoBloqueo);  //Suena al presionar R.
            }
            return;   //Sale del metodo, con R no se revisa nada mas. 
        }

        //B y C solo actuan sobre el globo elegido(el más cercano dentro del anillo).
        int i = masCercano();   //i toma el valor de la casilla elegida. 
        if(i == -1){
            return;    //Si es -1 es porque no hay ningun globo en el anillo, las teclas no hacen nada.
        }
        Mensaje m = mensajes[i];  //¨m¨ es un apodo para no escribir nuevamente mensajes[i].

        if(k == 'b' || k == 'B'){  //Se presiona el boton de bloquear.
            m.activo = false;     //Se va el mensaje. 
            if(m.tipo == 0){      //Si el mensaje es negativo, entonces es un acierto.
                racha = racha + 1;
                efecto(sonidoBloqueo); 
            }else{
                if(m.tipo == 1){    //Si el mensaje es positivo, entonces fue un error leve.
                    errorLeve(); 
                }      //Si es neutro(tipo 2) no pasa nada, solo se quita el mensaje sin consecuencias. 
            }
        }else{
            if(k == 'c' || k == 'C'){  //Se presiona el boton de capturar( o contestar) mensaje.
                m.activo = false;      //Se va el mensaje.
                if(m.tipo == 1){       //Si era positivo entonces es un acierto, suma bienestar y aumenta la racha.
                    racha = racha + 1;          
                    bienestar = bienestar + 10;
                    efecto(sonidoPositivo);
                }else{
                    if(m.tipo == 0){     //Le contestó a un negativo, es un error leve.
                        errorLeve();
                    }                    //Si es neutro(tipo 2) no pasa nada, solo se quita el mensaje sin consecuencias.
                }
            }
        }
        bienestar = constrain(bienestar, 0, 100);  //La funcion constrain() nativa de processing hace que bienestar no se pase de 100 y no sea menor que 0.
    }
}

