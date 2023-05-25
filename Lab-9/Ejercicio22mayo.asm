; -----------------------------------------------
; UNIVERSIDAD DEL VALLE DE GUATEMALA 
; Organización de computadoras y Assembler
; Ciclo 1 - 2023
; Nombre: subrutinas1.asm
; Descripción: demuestra uso de subrutinas en el mismo 
;			   documento
; Autor: KB, May 2023
; ----------------------------------------------- 

.386
.model flat, stdcall, c
.stack 4096
; ----------------------------------------------- 
; SECCION DE DECLARACIÓN DE VARIABLES
; ----------------------------------------------- 
.data
    
    msg0 BYTE '-------------------------------------------------------------------------------', 0Ah, 0
	msg1 BYTE '   Bienvenido a la demostracion de uso de subrutinas en un mismo documento.', 0Ah, 0
    msg2 BYTE 'El arreglo contiene los siguientes elementos:', 0Ah, 0
    msg3 BYTE 'La suma total del valor de los elementos del array es:', 0
    msg4 BYTE 'El promedio del valor de los elementos del array es:', 0
    sum DWORD 0
    promedio DWORD 0
    fmt db "%d",0Ah, 0

    arr DWORD 10, 20, 30, 40, 50, 60

; ----------------------------------------------- 
; SECCION DE DEFINICIÓN DE CÓDIGO
; ----------------------------------------------- 
; ------------ Librerías utilizadas -------------
.code
    includelib libucrt.lib
    includelib legacy_stdio_definitions.lib
    includelib libcmt.lib
    includelib libvcruntime.lib

    extrn printf:near
    extrn scanf:near
    extrn exit:near
	

; ------------ Rutina Principal -------------
public main
main proc
    push offset msg0		; Imprimir mensaje p/contexto de programa
    call printf
    push offset msg1		; Imprimir mensaje p/contexto de programa
    call printf
    push offset msg0		; Imprimir mensaje p/contexto de programa
    call printf

    push offset msg2		; Imprimir mensaje p/indicar elementos de array
    call printf

    call arrayPrint
    push offset msg3		; Imprimir mensaje p/sumatoria
    call printf
       
	call arraySuma
    push sum
    push offset fmt
    call printf
	

    push offset msg4		; Imprimir mensaje p/sumatoria
    call printf

    call arrayPromedio
    push promedio
    push offset fmt        ; Imprimir mensaje p/sumatoria
    call printf

	push 0
    call exit           ; salir del programa
	


main endp

; ------------ SUBRUTINAS -------------
;___________________________________________
;arrayPrint
;input: var global arr dword
;output: NO utiliza
;___________________________________________

arrayPrint proc
    push ebp
    mov ebp, esp
    push esi
    
    mov esi, offset arr
    mov ebx, sizeof arr
label1:
	mov eax, [esi]		; DIRECCIONAM. INDIRECTO: Cargar el valor del i-esimo elem de array a eax 
	push eax			; Pasar valor a pila p/imprimir
	push offset fmt		; Pasar formato 
	call printf
    add esp, 8
	sub ebx, 4			; Decrementar "contador"
	add esi, 4			; Moverse al sig. elem. del array
	cmp ebx,0			; Aún hay elementos en el array?
	jne label1			; Sí, entonces repetir proceso desde label1

    pop esi
    mov esp, ebp
	pop ebp
    ret
arrayPrint endp

;___________________________________________
;arraySuma
;input: var global arr dword
;output: var global sum
;___________________________________________
arraySuma proc
    push ebp
    mov ebp, esp
    push esi
    
    mov esi, offset arr
    mov ebx, sizeof arr
	mov eax, 0
label1:
	add eax, [esi]		; DIRECCIONAM. INDIRECTO: Cargar el valor del i-esimo elem de array a eax 

	sub ebx, 4			; Decrementar "contador"
	add esi, 4			; Moverse al sig. elem. del array
	cmp ebx,0			; Aún hay elementos en el array?
	jne label1			; Sí, entonces repetir proceso desde label1

    mov sum, eax

    pop esi
    mov esp, ebp
	pop ebp
    ret
arraySuma endp



;___________________________________________
;arrayPromedio
;input: var global arr dword
;output: var global sum
;___________________________________________
arrayPromedio proc

    mov eax, sum

    mov ecx, sizeof arr / 4 ; Se mueve cada 4 bits
    cdq ; Redondea el resultado
    idiv ecx
    mov promedio, eax

    ret
arrayPromedio endp

end