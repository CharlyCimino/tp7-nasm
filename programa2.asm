; Se ingresa una cadena. La computadora muestra las subcadenas 
; formadas por las posiciones pares e impares de la cadena. 
; Ej: FAISANSACRO > ASNAR FIASCO
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola direccionada en MinGW\bin):
; 1) nasm -f win32 programa2.asm --PREFIX _
; 2) gcc programa2.obj -o programa2.exe
; 3) programa2
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

cadenaImpar:
        resb    0x0100           ; CADENA CON CARACTERES EN POSICIONES IMPARES

cadenaPar:
        resb    0x0100           ; CADENA CON CARACTERES EN POSICIONES PARES

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)



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
        db    "Ingrese una cadena: ", 0  ;



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

mostrarPrimerMensaje:
        push dword textoDeInicio
        push fmtString
        call printf
        add esp, 8
        ret 
  

_start:
main:   
	call mostrarPrimerMensaje
    call leerCadena
    mov edi, 0                  ; Registro que contiene indice de la cadena
    mov edx, 0                  ; Registro que contiene el indice de las subcadenas
impares:
    mov al, [edi+cadena]
    inc edi
    cmp al, 0
    je mostrarResultado
    mov [edx+cadenaImpar], al
pares:
    mov al, [edi+cadena]
    inc edi
    cmp al, 0
    je mostrarResultado
    mov [edx+cadenaPar], al
    inc edx
    jmp impares
mostrarResultado:
    mov edi, 0
mostrarCadenaPar:
    mov al, [edi+cadenaPar]
    cmp al, 0
    je mostrarEspacio
    mov [caracter], al
    call mostrarCaracter
    inc edi
    jmp mostrarCadenaPar
mostrarEspacio:
    mov dword [caracter], ' '
    call mostrarCaracter
    mov edi, 0
mostrarCadenaImpar:
    mov al, [edi+cadenaImpar]
    cmp al, 0
    je salirDelPrograma
    mov [caracter], al
    call mostrarCaracter
    inc edi
    jmp mostrarCadenaImpar
    call salirDelPrograma