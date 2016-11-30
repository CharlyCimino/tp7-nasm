; Dado un entero N, tal que 0 ‹ N ‹ 11, la computadora
; muestra la tabla de multiplicar de N.
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola direccionada en MinGW\bin):
; 1) nasm -f win32 programa1.asm --PREFIX _
; 2) gcc programa1.obj -o programa1.exe
; 3) programa1
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
num:         
        resd    1                ; NÚMERO DEL QUE SE MOSTRARÁ LA TABLA DE MULTIPLICAR
factor:      
        resd    1                ; MULTIPLICADOR DE NUM



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
        db    "Ingrese un numero entre 1 y 10: ", 0  ;

signoMultiplicar:          
        db    " x ", 0  ; 

signoIgual:          
        db    " = ", 0  ; 

mascara:           equ     0x10000000       ; MASCARA PARA DETERMINAR SI UN NUM ES NEGATIVO



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

_start:
main:                            ; Arranca el programa
    mov esi, 0
    mov ebx, 0
    mov dword [factor], 0        ; Inicializo factor en 0
primerMensaje:
    mov al, [ebx+textoDeInicio]
    mov [ebx+cadena], al
    inc ebx
    cmp al, 0
    jne primerMensaje
    call mostrarCadena
    call leerNumero
validador:    
    mov eax, [numero]            
    and eax, mascara             ; AND con la máscara para saber si es + o -
    jnz primerMensaje            ; Si el número negativo vuelvo a pedirlo
    mov eax, [numero]        
    cmp eax, 0                   ; Comparo para saber si es 0
    je  primerMensaje            ; Si el número es 0 vuelvo a pedirlo
    sub eax, 11                  ; Le resto 11 al número
    and eax, mascara             ; AND con la máscara para saber si es + o - esa resta
    jz primerMensaje             ; Si la resta es positiva, el número es mayor que 10, vuelvo a pedirlo
    mov esi, 0
    mov ebx, 0
    mov al, [numero]
    mov [num], al                ; Guardo el número ingresado
mostrarN:   
    mov al, [num]
    mov [numero], al
    call mostrarNumero           ; Muestro num
mostrarX:
    mov al, [ebx+signoMultiplicar]
    mov [ebx+cadena], al
    inc ebx
    cmp al, 0
    jne mostrarX
    call mostrarCadena           ; Muestro " x "
mostrarFactor:
    mov al, [factor]
    mov [numero], al
    call mostrarNumero           ; Muestro factor
    mov esi, 0
    mov ebx, 0
mostrarIgual:
    mov al, [ebx+signoIgual]
    mov [ebx+cadena], al
    inc ebx
    cmp al, 0
    jne mostrarIgual
    call mostrarCadena           ; Muestro " = "
    mov esi, 0
    mov ebx, 0
multiplicar:
    mov eax, [factor]            ; Muevo factor
    mov ebx, [num]               ; Muevo num
    mul ebx                      ; Los multiplico (el producto queda en EAX)
mostrarResultado:
    mov [numero], eax
    call mostrarNumero           ; Muestro el producto
    mov esi, 0
    mov ebx, 0
proximoRenglon:
    call mostrarSaltoDeLinea
    inc dword [factor]           ; factor++
    cmp dword [factor], 11       ; Comparo con 11
    jne mostrarN                 ; Si no es 11, entonces es menor, nuevo ciclo
    call salirDelPrograma