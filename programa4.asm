; Se ingresan un entero N y, a continuación, N números
; enteros. La computadora muestra el promedio de los
; números impares ingresados y la suma de los pares.
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola direccionada en MinGW\bin):
; 1) nasm -f win32 programa4.asm --PREFIX _
; 2) gcc programa4.obj -o programa2.exe
; 3) programa4
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

totalN:         resb    4
sumaPares:      resb    4
sumaImpares:    resb    4
cantImpares:    resb    4
promedio:    resb    4



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

textoPedirNumero:          
        db    "Ingrese un numero: ", 0  ;

textoDePromedio:          
        db    "Promedio de los impares: ", 0  ;

textoDeSuma:          
        db    "Suma de los pares: ", 0  ;

mascara: equ 0x1                        ; mascara para quedarse con los primeros 8 bits



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

mostrarPedirNumero:
        push dword textoPedirNumero
        push fmtString
        call printf
        add esp, 8
        ret 

mostrarPromedio:
        push dword textoDePromedio
        push fmtString
        call printf
        add esp, 8
        ret 

mostrarSuma:
        push dword textoDeSuma
        push fmtString
        call printf
        add esp, 8
        ret 
  

_start:
main:   
    mov dword [sumaPares], 0            ; inicializo la suma de los pares
    mov dword [sumaImpares], 0          ; inicializo la suma de los impares
    mov dword [cantImpares], 0          ; inicializo la cantidad de los impares
    mov dword [promedio], 0          ; inicializo promedio
    mov dword [totalN], 0          ; cantidad de Numeros
    mov eax, 0                  ; numero actual
    mov ebx, 0                  ; indice numeros
    mov ecx, 0                  ; acumulador para promedio de impares
    mov edx, 0                  ; acumulador para suma de pares
    mov esi, 0                  ; contador de numeros impares
    call mostrarPrimerMensaje
    call leerNumero
    mov eax, [numero]
    mov [totalN], eax
    cmp eax, 0                      ; Que no sea cero, sino vuelvo a pedir
    je main
    call mostrarSaltoDeLinea
pedirNumeros:
    call mostrarPedirNumero
    call leerNumero
    mov eax, [numero]
    and eax, mascara
    cmp eax, 0
    je esPar
esImpar:
    xor ecx, ecx
    inc dword [cantImpares]
    mov ecx, [numero]
    add [sumaImpares], ecx
    jmp validador
esPar:
    mov ecx, [numero]
    add [sumaPares], ecx
validador:
    inc ebx
    cmp ebx, [totalN]                    ; si llegue al total, no sigo
    jge calculo
    jmp pedirNumeros
calculo:
    xor edx, edx
    mov eax, [sumaImpares]
    div dword [cantImpares]             ; Divido para sacar el promedio
    mov [promedio], eax
resultados:
    call mostrarSaltoDeLinea
    call mostrarPromedio
    mov ecx, [promedio]
    mov [numero], ecx
    call mostrarNumero
    call mostrarSaltoDeLinea
    call mostrarSuma
    mov ecx, [sumaPares]
    mov [numero], ecx
    call mostrarNumero
finalizar:
    call mostrarSaltoDeLinea
    jmp salirDelPrograma

