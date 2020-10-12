getDate MACRO
    SetData ;salva la informacion en la pila
    MOV AH, 2ah ;obtiene la fecha de sitema operativo (windows) 
    int 21h ;realiza una interrupcion 21 

    MOV AL, DL 
    CALL timeConvert ;llama al metodo que convierte el tiempo
    mov dayDate[0], AH ;almcena en el arreglo de dia el valor en la posicion 0
    mov dayDate[1], AL ;almcena en el arreglo de dia el valor en la posicion 1
    
    mov al, dh 
    CALL timeConvert        ;llama al metodo que convierte el tiempo
    mov monthDate[0], AH    ;almcena en el arreglo de mes el valor en la posicion 0
    mov monthDate[1], al     ;almcena en el arreglo de mes el valor en la posicion 1
    RemoveData ;libera la informacion de la pila 
ENDM

getTime MACRO
    SetData ;almacena la informacion en la pila 
    mov ah, 2ch ;obtiene el tiempo actual del sistema 
    int 21h ;realiza una interrupcion 21

    mov al, ch 
    CALL timeConvert ;llama al metodo que convierte el tiempo
    mov hourDate[0], ah ;almcena en el arreglo de hora el valor en la posicion 0
    mov hourDate[1], al ;almcena en el arreglo de hora el valor en la posicion 1

    mov al, cl
    CALL timeConvert ;llama al metodo que convierte el tiempo
    mov minuteDate[0], ah ;almcena en el arreglo de minuto el valor en la posicion 0
    mov minuteDate[1], al ;almcena en el arreglo de minuto el valor en la posicion 1

    mov al, dh
    CALL timeConvert ;llama al metodo que convierte el tiempo
    mov secondDate[0], ah ;almcena en el arreglo de segundo el valor en la posicion 0
    mov secondDate[1], al ;almcena en el arreglo de segundo el valor en la posicion 1

    RemoveData ;libera la informacion de la pila 
ENDM 