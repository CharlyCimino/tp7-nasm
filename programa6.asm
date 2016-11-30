; Se ingresa N. La computadora muestra los primeros N
; términos de la Secuencia de Lucas.
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola direccionada en MinGW\bin):
; 1) nasm -f win32 programa6.asm --PREFIX _
; 2) gcc programa6.obj -o programa6.exe
; 3) programa6
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

anterior:
        resb    4           
        
actual:
        resb    4 


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

textoSucesion:          
        db    "La sucesion: ", 0  ;

  



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

mostrarTexto:
        push dword textoSucesion
        push fmtString
        call printf
        add esp, 8
        ret 

mostrarAnterior:                 ; muestro el n anterior
        push dword [anterior]
        push fmtInt
        call printf
        add esp, 8
        ret

mostrarActual:                   ; Muestro el n actual
        push dword [actual]
        push fmtInt
        call printf
        add esp, 8
        ret   

  
_start:
main:                            
    mov dword [anterior], 2     ; En anterior guardo el elemento n-2
    mov dword [actual], 1       ; En actual guardo el elemento n-1
    mov ecx, 0
    mov dword [indice], 0      ; Contador de la indice                      
    call mostrarPrimerMensaje          
    call leerNumero             
    dec dword [numero]
    mov ecx, 0
mostrarNumero0:
    call mostrarTexto
    call mostrarAnterior       ; Muestra el primer numero de la sucesion
    mov eax, 0x20                 ; Imprimo un espacio
    mov [caracter], eax         
    call mostrarCaracter        
    mov eax, [numero]           ; Muevo el contenido de la indice de memoria de numero a eax
    cmp eax, 0                  ; Veo si es igual a cero
    jle finalizar                     ; Si es igual a cero me voy al fin de programa
imprimirN:
    call mostrarActual         ; Llama a mostrar numero
    inc dword [indice]          ; Incremento el contador de indice
    mov eax, 0x20                 ; Imprimo un espacio
    mov [caracter], eax         
    call mostrarCaracter        
    mov eax, [numero]           ; Muevo el contenido de la indice de memoria de numero a eax
    cmp eax, [indice]         ; Veo si la indice es igual al n ingresado    
    je finalizar                 ; Si es igual me voy al fin de programa
calcular:
    mov eax, [actual]          ; Me guardo el n-1
    mov ebx, [anterior]        ; Me guardo el n-2
    mov [anterior], eax        ; Guardo en anterior el actual         
    add eax, ebx                ; Sumo n-1 y n-2 para obtener n
    mov [actual], eax          ; Guardo en actual la suma obtenida
    jmp imprimirN               ; Voy a mostrarNumero
finalizar:
    call mostrarSaltoDeLinea
    jmp salirDelPrograma 