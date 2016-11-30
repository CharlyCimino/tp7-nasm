; Se ingresa una matriz de NxN componentes enteras. La
; computadora muestra los valores ubicados en la diagonal
; secundaria y cuánto suman.
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola direccionada en MinGW\bin):
; 1) nasm -f win32 programa8.asm --PREFIX _
; 2) gcc programa8.obj -o programa8.exe
; 3) programa8
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

tam:                resb    4
acu:                resb    4
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

textoDeInicio:          
        db    "Ingrese N: ", 0  ;

textoIngreso:          
        db    "Ingrese el valor de la Fila %d Columna %d: ", 0  ;

textoMatrizOriginal:          
        db    "Matriz original: ", 0  ;

textoDiagonal:          
        db    "La diagonal principal es: ", 0  ;

textoSuma:          
        db    "Cuya suma da: ", 0  ;

  



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

mostrarMensajeDeInicio:
        push dword textoDeInicio
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

mostrarMensajeDiagonal:
        push dword textoDiagonal
        push fmtString
        call printf
        add esp, 8
        ret

mostrarMensajeSuma:
        push dword textoSuma
        push fmtString
        call printf
        add esp, 8
        ret   

  
_start:
main:
    mov ebx, 0
    mov dword [indiceC], 0         ; indiceC = 0
    mov dword [indiceF], 0         ; indiceF = 0
    mov [acu], dword 0         ; Inicializo con 0 al acumulador de la diagonal
pedirNum:
    call mostrarMensajeDeInicio
    call leerNumero
    mov ecx, [numero]
    cmp ecx, 0                      ; Que no sea cero, sino vuelvo a pedir
    je pedirNum
    mov [tam], ecx
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
    cmp eax, [tam]
    jne ingresar
; si se terminó con la fila, se resetea la columna y se pasa a la
; siguiente fila.
    mov dword [indiceC], 0
    inc dword [indiceF]
    mov eax, [indiceF]
; si todavía hay más filas, se siguen ingresando valores.
    cmp eax, [tam]
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
    cmp eax, [tam]
    jne imprimirColumnas
siguienteFila:
    call mostrarSaltoDeLinea
    mov dword [indiceC], 0           ; se vuelve la columna a 0
    inc dword [indiceF]             ; se incrementa la fila
    mov eax, [indiceF]               ; si todavia no se llego al final de la fila
    cmp eax, [tam]                 ; se sigue recorriendo la matriz
    jne imprimirColumnas
    call mostrarSaltoDeLinea
    xor esi,esi
    call mostrarMensajeDiagonal
ubicarse:
    mov edi, 0                  
    mov esi, matriz 
    mov ebx, [tam]                ; Me ubico en la ultima posicion de la primer fila
    dec ebx
    add esi, ebx                
    add esi, ebx
    add esi, ebx
    add esi, ebx
    mov ecx, 0
diagonal:
    mov eax, [esi]              ; Muevo a eax, el contenido de esi (La matriz)
    mov [numero], eax           
    add eax, [acu]             ; Sumo lo que tengo en el acumulador con el nuevo numero
    mov [acu], eax
    call mostrarNumero          ; Llamo a mostrar Numero
    mov eax, 32                 ; Imprimo espacio
    mov [caracter], eax         
    call mostrarCaracter        
    add esi, ebx                ; Avanzo a la proxima posicion de la diagonal
    add esi, ebx
    add esi, ebx
    add esi, ebx    
    inc edi                     
    cmp edi, [tam]                
    jl diagonal
suma:
    call mostrarSaltoDeLinea
    call mostrarMensajeSuma
    mov edx, [acu]
    mov [numero], edx
    call mostrarNumero
finalizar:
    jmp salirDelPrograma