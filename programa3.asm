; Se ingresa una cadena. La computadora indica si es un
; palíndromo.
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola direccionada en MinGW\bin):
; 1) nasm -f win32 programa3.asm --PREFIX _
; 2) gcc programa3.obj -o programa3.exe
; 3) programa3
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

indice:     resb    4       ; indice
indiceAux:  resb    4       ; otro indice
length:     resb    4       ; cantidad de caracteres
mitad:      resb    4       ; auxiliar para recorrer la cadena hasta la mitad



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

textoNo:       
        db  "La cadena NO es un palindromo.", 0 ;

textoSi:         
        db  "La cadena es un palindromo.", 0    ;

mascara: equ 0xFF                        ; mascara para quedarse con los primeros 8 bits



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

mostrarSi:
        push dword textoSi
        push fmtString
        call printf
        add esp, 8
        ret 

mostrarNo:
        push dword textoNo
        push fmtString
        call printf
        add esp, 8
        ret 
  

_start:
main:
    mov dword [indice], 0          ; inicializo indice en 0
    mov dword [length], 0          ; inicializo length en 0
    call mostrarPrimerMensaje
    call leerCadena
contador:                             ; Contador de caracteres
    mov eax, [length]                            
    cmp byte [cadena+eax], 0      
    je continuar
    inc dword [length]
    jmp contador
continuar:
    dec dword [length]               ; length-- por el caracter nulo que indica fin de string
    mov eax, [length]
    mov [indiceAux], eax             ; indiceAux = length
    shr eax, 1                       ; length/2
    mov [mitad], eax
    inc dword [mitad]                ; mitad++
comparar:
    mov eax, [indice]                ; posicion de inicio de la cadena          
    mov ebx, [indiceAux]             ; posicion de final de la cadena
    mov ecx, [cadena+eax]                        
    mov edx, [cadena+ebx]
    and ecx, mascara                  ; Solo los 8 bits menos significativos
    and edx, mascara                  ; Solo los 8 bits menos significativos
    cmp ecx, edx                     ; comparo
    jne negativo                    ; si son distintos, no es un palindromo
    inc dword [indice]              ; indice++
    dec dword [indiceAux]           ; indiceAux--
    mov eax, [indice]
    cmp eax, [mitad]                 ; si llegamos a la mitad+1
    je  afirmativo                  ; es un palindromo
    jmp comparar                   
negativo:
    call mostrarNo
    jmp terminar
afirmativo:
    call mostrarSi
terminar:
    call mostrarSaltoDeLinea
    jmp salirDelPrograma