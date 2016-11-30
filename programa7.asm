; Se ingresa una matriz de NxM componentes. La computadora
; la muestra girada 90˚ en sentido antihorario.
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola direccionada en MinGW\bin):
; 1) nasm -f win32 programa7.asm --PREFIX _
; 2) gcc programa7.obj -o programa7.exe
; 3) programa7
;


        global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!



section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)

cadena:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)

indice:     
        resb    4                ; indice

numFilas:           resb    4
numColumnas:        resb    4
indiceF:            resb    4
indiceC:            resb    4
filLen:             resb    4
matriz:             resd    256


section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)

textoDeFilas:          
        db    "Ingrese cuantas filas: ", 0  ;

textoDeColumnas:          
        db    "Ingrese cuantas columnas: ", 0  ;

textoIngreso:          
        db    "Ingrese el valor de la Fila %d Columna %d: ", 0  ;

textoMatrizOriginal:          
        db    "Matriz original: ", 0  ;

textoMatrizRotada:          
        db    "Matriz rotada: ", 0  ;

  



section .text                    ; SECCION DE LAS INSTRUCCIONES
 
leerCadena:                      ; RUTINA PARA LEER UNA CADENA USANDO GETS
        push cadena
        call gets
        add esp, 4
        ret

leerNumero:                      ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret
    
mostrarCadena:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadena
        push fmtString
        call printf
        add esp, 8
        ret

mostrarNumero:                   ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        ret

mostrarCaracter:                 ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
        push dword [caracter]
        push fmtChar
        call printf
        add esp, 8
        ret

mostrarSaltoDeLinea:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit   

mostrarMensajeFilas:
        push dword textoDeFilas
        push fmtString
        call printf
        add esp, 8
        ret 

mostrarMensajeColumnas:
        push dword textoDeColumnas
        push fmtString
        call printf
        add esp, 8
        ret  

mostrarMensajeIngreso:
        push dword textoIngreso
        push fmtString
        call printf
        add esp, 16
        ret  

mostrarMensajeMatrizOriginal:
        push dword textoMatrizOriginal
        push fmtString
        call printf
        add esp, 8
        ret  

mostrarMensajeMatrizRotada:
        push dword textoMatrizRotada
        push fmtString
        call printf
        add esp, 8
        ret  

  
_start:
main:
    mov dword [indiceC], 0         ; indiceC = 0
    mov dword [indiceF], 0         ; indiceF = 0
pedirNumFilas:
    call mostrarMensajeFilas
    call leerNumero
    mov ecx, [numero]
    cmp ecx, 0                      ; Que no sea cero, sino vuelvo a pedir
    je pedirNumFilas
    mov [numFilas], ecx
pedirNumColumnas:
    call mostrarMensajeColumnas
    call leerNumero
    mov ecx, [numero]
    cmp ecx, 0                      ; Que no sea cero, sino vuelvo a pedir
    je pedirNumColumnas
    mov [numColumnas], ecx
    ; se pone esi en 0 (va a ser el indice durante la carga de la matriz)
    xor esi,esi
ingresar:
; se toma el valor de la columna + 1
    mov eax, dword [indiceC]
    inc eax
    push eax
; se toma el valor de la fila + 1
    mov eax, dword [indiceF]
    inc eax
    push eax
    push dword textoIngreso
    call printf
    add esp,12
; se introduce el valor en la matriz
    call leerNumero
    mov ecx, [numero]
    mov dword [matriz+esi], ecx
; se incrementa el contador de columnas y el índice
    add esi, 4
    inc dword [indiceC]
    mov eax, [indiceC]
; si todavía no se llenaron todas las columnas, 
; se ingresa el siguiente número de la fila.
    cmp eax, [numColumnas]
    jne ingresar
; si se terminó con la fila, se resetea la columna y se pasa a la
; siguiente fila.
    mov dword [indiceC], 0
    inc dword [indiceF]
    mov eax, [indiceF]
; si todavía hay más filas, se siguen ingresando valores.
    cmp eax, [numFilas]
    jne ingresar
    call mostrarSaltoDeLinea
    xor esi, esi
matrizOriginal:
    call mostrarMensajeMatrizOriginal
    call mostrarSaltoDeLinea
    mov dword [indiceF], 0
imprimirColumnas:
    mov ecx, [matriz+esi]            ; posición de la matriz a mostrar
    mov [numero], ecx
    call mostrarNumero
    add esi, 4                       ; indice de la matriz se desplaza 4 bytes
    inc dword [indiceC]             ; se incrementa la columna
    mov eax, [indiceC]               ; si ya se imprimieron todas las columnas
    cmp eax, [numColumnas]
    jne imprimirColumnas
siguienteFila:
    call mostrarSaltoDeLinea
    mov dword [indiceC], 0           ; se vuelve la columna a 0
    inc dword [indiceF]             ; se incrementa la fila
    mov eax, [indiceF]               ; si todavia no se llego al final de la fila
    cmp eax, [numFilas]                 ; se sigue recorriendo la matriz
    jne imprimirColumnas
    call mostrarSaltoDeLinea
    xor esi,esi
matrizRotada:
    call mostrarMensajeMatrizRotada
    call mostrarSaltoDeLinea
    mov dword [indiceF], 0           ; columna, y recorrer por filas y luego por columnas.
    mov eax, [numColumnas]              ; Por eso se pone el indiceF=0 y indiceC en el total
    mov dword [indiceC], eax         ; de columnas que haya.
    mov eax, 4                       ; Se calcula auxiliarmente la longitud de la fila en
    mov ebx, [numColumnas]              ; bytes, multiplicando la cantidad máxima de columnas
    mul ebx                         ; por bytes que ocupan los datos, en este caso, 4 bytes.
    mov [filLen], eax                ; Y se aplica el siguiente calculo:
siguienteValor:                     ;           "Matriz[indiceF][indiceC]"
    mov esi, [indiceC]               ; elemento = ptrMatriz + indiceF * filLen + indiceC * 4 (bytes)
    dec esi                         ; esi = indiceC - 1 
    mov eax, 4                       ; ya que indiceC tiene el número total de columnas,
    mul esi                         ; y el indice es de 0 a columnas-1.
    mov esi, eax                     ; eax = indiceF * filLen
    mov ebx, [filLen]
    mov eax, [indiceF]
    mul ebx
    mov ecx, [matriz+esi+eax]        ; elemento = matriz[indiceF][indiceC]
    mov [numero], ecx             ; se muestra el elemento en pantalla.
    call mostrarNumero
    inc dword [indiceF]             ; se incrementa el número de fila
    mov ebx, [indiceF]               ; si todavía no se terminó de recorrer las filas,
    cmp ebx, [numFilas]                 ; se pasa al siguiente elemento.
    jne siguienteValor              ; sino se resetea la fila y se muestra un salto de linea
    mov dword [indiceF], 0           ; y se decrementa el valor de la columna.
    call mostrarSaltoDeLinea
    dec dword [indiceC]
    cmp dword [indiceC], 0           ; si las columnas llegaron a 0, se terminó de recorrer
    jne siguienteValor              ; la matriz.
finalizar:
    jmp salirDelPrograma