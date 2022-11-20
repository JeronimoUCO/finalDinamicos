global n = 50
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

    poblacionDepredadores++;
    #depredadores(size(depredadores, 1)).direccionMovimiento = 1;
endfunction

#Creacion de presas
function crearPresa()
    global presas;
    global poblacionPresas;

    presas(poblacionPresas).posicionX = int64(rand() * 40 + 2);
    presas(poblacionPresas).posicionY = int64(rand() * 40 + 2);

    poblacionPresas++;
    #presas(size(presas, 1)).direccionMovimiento = 1;
endfunction

function muerte(vectorCriatura, cantidad,contadorPoblacional)
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

    nPresas
    nDepredadores
    size(depredadores,2)
    size(presas,2)

    ii++
endwhile
