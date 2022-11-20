clear all;

global n = 50;
global j = 1;
global mapa = zeros(50, 50);
global alpha1 = 5;
global alpha2 = 2;

global depredadores = struct();
global presas = struct();

global poblacionDepredadores=1;
global poblacionPresas=1;

global condicionesDepredadores = [0, 3; 0.5, 0.6]
global valorPDep1 = 1.9
global valorPDep2=-1.31
global vectorPDep1 = [1, 0.38]
global vectorPDep2 = [1, -0.262]

global condicionesPresas = [0, 5; 0.5, 0.6]
global valorPPresa1 = 1.56
global valorPPresa2=-0.96
global vectorPPresa1 = [1, 0.52]
global vectorPPresa2 = [1, -0.32]

function p = calcularPoblacion(n, valorP1, valorP2, vectorP1, vectorP2)
    global alpha1;
    global alpha2;

    if (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2)(1,1) >= 0 && (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2)(1,2) >= 0
        p = (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2);

    elseif (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2)(1,1) < 0 && (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2)(1,2) >= 0
        p = (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2);
        p(1,1) = 0;

    elseif (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2)(1,1) >= 0 && (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2)(1,2) < 0
        p = (valorP1^n) * (alpha1 * vectorP1 + ((valorP2 / valorP1)^n) * alpha2 * vectorP2);
        p(1,2) = 0;

    else
        p = [0, 0];
    endif

endfunction

#Creacion de depredadores
function crearDepredador()
    global depredadores;
    global poblacionDepredadores;

    depredadores(poblacionDepredadores).posicionX = int64(rand() * 40 + 2);
    depredadores(poblacionDepredadores).posicionY = int64(rand() * 40 + 2);
    depredadores(poblacionDepredadores).direccionMovimiento = 1;

    poblacionDepredadores++;
    #depredadores(size(depredadores, 1)).direccionMovimiento = 1;
endfunction

#Creacion de presas
function crearPresa()
    global presas;
    global poblacionPresas;

    presas(poblacionPresas).posicionX = int64(rand() * 40 + 2);
    presas(poblacionPresas).posicionY = int64(rand() * 40 + 2);
    presas(poblacionPresas).direccionMovimiento = 1;

    poblacionPresas++;
    #presas(size(presas, 1)).direccionMovimiento = 1;
endfunction

function muerte(vectorCriatura, cantidad, contadorPoblacional)
global depredadores
global presas
global poblacionDepredadores
global poblacionPresas

    i = 1;
    while i < cantidad
        vectorCriatura(1) = [];
        contadorPoblacional--;
        i++;
    endwhile
endfunction


function dibujarPantalla(instante)
    global presas;
    global poblacionPresas;
    global depredadores;
    global poblacionDepredadores;
    global comidas;
    global mapa;
    global k;
    global j;

    #Muestra las presas que no se han comido
    while j < columns(presas)
        presaActual = presas(j);
        #Si se toca alguno de los "bordes" del mapa, se lleva de nuevo al interior de este
        if presaActual.posicionX <= 2 || presaActual.posicionX >= 48 || presaActual.posicionY <= 2 || presaActual.posicionY >= 48

            if presaActual.posicionX <= 2
                presaActual.posicionX += 2;
            endif

            if presaActual.posicionX >= 48
                presaActual.posicionX -= 2;
            endif

            if presaActual.posicionY <= 2
                presaActual.posicionY += 2;
            endif

            if presaActual.posicionY >= 48
                presaActual.posicionY -= 2;
            endif

        endif

        #Si la posicion de ha definido (aleatoriamente) en 1, la presa se mueve hacia arriba
        if presaActual.direccionMovimiento == 1
            presaActual.posicionY +=1;
        endif

        #Si la posicion de ha definido (aleatoriamente) en 2, la presa se mueve hacia la derecha
        if presaActual.direccionMovimiento == 2
            presaActual.posicionX +=1;
        endif

        #Si la posicion de ha definido (aleatoriamente) en 3, la presa se mueve hacia abajo
        if presaActual.direccionMovimiento == 3
            presaActual.posicionY -=1;
        endif

        #Si la posicion de ha definido (aleatoriamente) en 4, la presa se mueve hacia la izquierda
        if presaActual.direccionMovimiento == 4
            presaActual.posicionX -=1;
        endif
        #Se recalcula (aleatoriamente) la direccion de movimiento
        presaActual.direccionMovimiento = int64(rand() * 4 + 1);
        #Se actualiza el valor de la presa(global) al de la presa actual(local)
        presas(j) = presaActual;
        #Se pinta la presa como un punto blanco en el mapa
        mapa(presaActual.posicionY, presaActual.posicionX) = 255;
        j += 1;
    endwhile
    j = 1;
    #for i = 1:columns(depredadores) - muertos
    while k < columns(depredadores)
        depredadorActual = depredadores(k);
        #Se verifica que el depredador no toque los limites del mapa
        if depredadorActual.posicionX <= 2 || depredadorActual.posicionX >= 48 || depredadorActual.posicionY <= 2 || depredadorActual.posicionY >= 48

            if depredadorActual.posicionX <= 2
                depredadorActual.posicionX +=2;
            endif

            if depredadorActual.posicionX >= 48
                depredadorActual.posicionX -= 2;
            endif

            if depredadorActual.posicionY <= 2
                depredadorActual.posicionY += 2;
            endif

            if depredadorActual.posicionY >= 48
                depredadorActual.posicionY -= 2;
            endif

        endif

        #Si la direccion se calcula (aleatoriamente) en 1, se mueve hacia arriba
        if depredadorActual.direccionMovimiento == 1
            depredadorActual.posicionY +=1;
        endif

        #Si la direccion se calcula (aleatoriamente) en 2, se mueve hacia la derecha
        if depredadorActual.direccionMovimiento == 2
            depredadorActual.posicionX +=1;
        endif

        #Si la direccion se calcula (aleatoriamente) en 3, se mueve hacia abajo
        if depredadorActual.direccionMovimiento == 3
            depredadorActual.posicionY -=1;
        endif

        #Si la direccion se calcula (aleatoriamente) en 4, se mueve hacia la izquierda
        if depredadorActual.direccionMovimiento == 4
            depredadorActual.posicionX -=1;
        endif

        #Se recalcula la direccion de movimiento
        depredadorActual.direccionMovimiento = int64(rand() * 4 + 1);
        #Se actualiza el valor de depredador actual
        depredadores(k) = depredadorActual;
        #Se pinta el depredador en el mapa como un punto gris
        mapa(depredadorActual.posicionY, depredadorActual.posicionX) = 50;
        k += 1;

    endwhile

    #Se cambia el color del punto de negro a gris
    k = 1;
    mapa = uint8(mapa);
    subplot(1, 2, 2)
    imshow(mapa);
    pause(0.001);

    #Despues de un tiempo, se borran las presas y depredadores del mapa para actualizar sus posiciones
    for i = 1:columns(presas)
        presaActual = presas(i);
        mapa(presaActual.posicionY, presaActual.posicionX) = 0;
    endfor

    for i = 1:columns(depredadores)

        depredadorActual = depredadores(i);
        mapa(depredadorActual.posicionY, depredadorActual.posicionX) = 0;
    endfor

endfunction

ii = 1;

while ii < n
    nDepredadores = sum(calcularPoblacion(ii, valorPDep1, valorPDep2, vectorPDep1, vectorPDep2)) - size(depredadores,2);
    nPresas = sum(calcularPoblacion(ii, valorPPresa1, valorPPresa2, vectorPPresa1, vectorPPresa2)) - size(presas,2);

    if nPresas < 0 || nDepredadores < 0

        if nPresas < 0
            muerte(presas, abs(nPresas),poblacionPresas);
        endif

        if nDepredadores < 0
            muerte(depredadores, abs(nDepredadores),poblacionDepredadores);
        endif

    endif

    if nPresas > 0 || nDepredadores > 0

        if nPresas > 0

            for i = 1:nPresas
                crearPresa();
            endfor

        endif

        if nDepredadores > 0

            for i = 1:nDepredadores
                crearDepredador();
            endfor

        endif

    endif

    for i = 1:8
        crearPresa();
    endfor

    for i = 1:10
        crearDepredador();
    endfor

    dibujarPantalla(ii);

    ii++
    poblacionPresas
    poblacionDepredadores
endwhile
