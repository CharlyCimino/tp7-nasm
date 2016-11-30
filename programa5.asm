; Se ingresa una cadena. La computadora la muestra
; separada en palabras, a razón de una palabra por
; renglón.
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola direccionada en MinGW\bin):
; 1) nasm -f win32 programa5.asm --PREFIX _
; 2) gcc programa5.obj -o programa5.exe
; 3) programa5
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

saltoDeLinea:    equ 0xA         ; caracter nueva linea



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
    mov dword [indice], 0            ; se inicializa el indice
    call mostrarPrimerMensaje
    call leerCadena                 
recorrer:            
    mov eax, [indice]                ; se recorre la cadena hasta el 0            
    cmp byte [cadena+eax], 0      
    je  mostrar
    cmp byte [cadena+eax], ' '       ; si es un espacio se reemplaza con un salto de linea
    jne  continuar                   
    mov byte [cadena+eax], saltoDeLinea   
continuar:                           
    inc dword [indice]              ; indice++
    jmp recorrer                   ; nuevo ciclo
mostrar:
    call mostrarCadena
    call mostrarSaltoDeLinea
    jmp salirDelPrograma