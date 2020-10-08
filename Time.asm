getDate MACRO
    SetData
    MOV AH, 2ah
    int 21h

    MOV AL, DL
    CALL timeConvert
    mov dayDate[0], AH
    mov dayDate[1], AL
    
    mov al, dh
    CALL timeConvert
    mov monthDate[0], AH
    mov monthDate[1], al
    RemoveData
ENDM

getTime MACRO
    SetData
    mov ah, 2ch
    int 21h

    mov al, ch
    CALL timeConvert
    mov hourDate[0], ah
    mov hourDate[1], al

    mov al, cl
    CALL timeConvert
    mov minuteDate[0], ah
    mov minuteDate[1], al

    mov al, dh
    CALL timeConvert
    mov secondDate[0], ah
    mov secondDate[1], al

    RemoveData
ENDM