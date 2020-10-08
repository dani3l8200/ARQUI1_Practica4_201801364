include macros.asm
include file.asm
include Time.asm
.model small

.stack 100h

.data
    margenStart    db '========================================================', 0aH, 0dH, '$'

	messageWelcome db '*  UNIVERSIDAD DE SAN CARLOS DE GUATEMALA              *', 0aH, 0dH, '*  FACULTAD DE INGENIERIA                              *', 0aH, 0dH, '*  CIENCIAS Y SISTEMAS                                 *', 0aH, 0dH, '*  ARQUITECTURA DE COMPUTADORES Y EMSAMBLADORES 1      *', 0aH, 0dH, '*  NOMBRE: JUAN DANIEL ENRIQUE ROMAN BARRIENTOS        *', 0aH, 0dH, '*  CARNET: 201801364                                   *', 0aH, 0dH,  '$'

	margenEnd      db '*  SECCION: A                                          *', 0aH,  0dH, '********************************************************', 0aH , 0dH, '$'

    messageOption  db '*  1) CARGAR ARCHIVO                                   *', 0aH, 0dH, '*  2) CONSOLA                                          *', 0ah, 0dh, '*  3) SALIR                                            *', 0ah, 0dh, '*                                                      *', 0ah, 0dh, '*  :\> SELECT A OPTION: ','$'

    messageOptionEnd db '                              *', 0ah, 0dh,'========================================================', 0ah, 0dh, '$'

    messageLoad db 0ah, 0dh, '==================== CARGAR ARCHIVO ====================', '$'

    messageInputPath db 0ah, 0dh, '  :\> Input Path:', '$'

    messageSuccessPath db 0ah, 0dh, '  File read successfully :)', '$'

    messageErrorPath db 0ah, 0dh, '  Error Read File', '$'

    path db 100 dup('$')

    messageBash db 0ah, 0dh, '==================== CONSOLA ===========================', '$'

    ReadingKeyboad db 0ah, 0dh, '  :\> ', '$'

    ErrorReadingKeyboad db 0ah, 0dh, '  COMANDO NO ENCONTRADO', '$'

    messageMedia db 0ah, 0dh, '  Estadistico Media: ', '$'

    messageModa db 0ah, 0dh, '  Estadistico Moda: ', '$'

    messageMediana db 0ah, 0dh, '  Estadistico Mediana: ', '$'

    messageMax db 0ah, 0dh, '  Estadistico Mayor: ', '$'

    messageMin db 0ah, 0dh, '  Estadistico Menor: ', '$'

    messageID db 0ah, 0dh, '  Resultado: ', '$'

    messageErrorOpen db 0ah, 0dh, '  ERROR: Not is possible open this file', '$'

    messageErrorCreate db 0ah, 0dh, '  ERROR: Not is possible create the file', '$'

    messageErrorWrite db 0ah, 0dh, '   ERROR: Not is possible write in the file', '$'

    messageErrorDelete db 0ah, 0dh, '  ERROR: Not is possible delete the file', '$'

    messageErrorRead db 0ah, 0dh, '  ERROR: Not is possible read the file', '$'

    messageErrorClose db 0ah, 0dh, '  ERROR: Not is possible close the file', '$'

    contentBufferJSON db 1000 dup('$')

    temp db 50 dup('$')

    uNumber db 00h, '$'

    dNumber db 00h, '$'

    sign db 00h, '$'

    handleFile dw ?

    studentJSON db '{', 0ah, 0dh, 09h, '"reporte": {', 0ah, 0dh, 09h, 09h, '"alumno": {', 0ah, 0dh, 09h, 09h, 09h, '"Nombre": "Juan Daniel Enrique Roman Barrientos",', 0ah, 0dh, 09h, 09h, 09h, 09h, '"Carnet": 201801364,', 0ah, 0dh, 09h, 09h, 09h, '"Seccion": "A",', 0ah, 0dh, 09h, 09h, 09h, '"Curso": "Arquitectura de Computadoras y Ensambladores 1"', 0ah, 0dh, 09h, 09h, '},'

    dayDateJSON db 0ah, 0dh, 09h, 09h, '"Fecha": {', 0ah, 0dh, 09h, 09h, 09h, '"Dia": '

    monthDateJSON db ',', 0ah, 0dh, 09h, 09h, 09h, '"Mes": '

    yearDateJSON db ',', 0ah, 0dh, 09h, 09h, 09h, '"Año": 2020'

    hourDateJSON db 0ah, 0dh, 09h, 09h, '},', 0ah, 0dh, 09h, 09h, '"Hora": {', 0ah, 0dh, 09h, 09h, 09h, '"Hora": '

    minuteDateJSON db ',', 0ah, 0dh, 09h, 09h, 09h, '"Minutos": '

    secondsDateJSON db ',', 0ah, 0dh, 09h, 09h, 09h, '"Segundos": '

    promResultJSON db 0ah, 0dh, 09h, 09h, '},', 0ah, 0dh, 09h, 09h, '"resultados": {', 0ah, 0dh, 09h, 09h, 09h, '"Media": '

    medianaResultJSON db ',', 0ah, 0dh, 09h, 09h, 09h, '"Mediana": '

    modaResultJSON db ',', 0ah, 0dh, 09h, 09h, 09h, '"Moda": '

    minResultJSON db ',', 0ah, 0dh, 09h, 09h, 09h, '"Menor": '

    maxResultJSON db ',', 0ah, 0dh, 09h, 09h, 09h, '"Mayor": '

    operationsJSON db 0ah, 0dh, 09h, 09h, '},', 0ah, 0dh, 09h, 09h, '"'

    operations1JSON db '": [', 0ah, 0dh, 09h, 09h, 09h, '{', 0ah, 0dh, 09h, 09h, 09h, 09h

    operations2JSON db 0ah, 0dh, 09h, 09h, 09h, '},'

    endJSON db 0ah, 0dh, 09h, 09h, ']', 0ah, 0dh, 09h, '}', 0ah, 0dh, '}'

    dayDate db 'dd'

    monthDate db 'mm'

    hourDate db 'hh'

    minuteDate db 'mm'

    secondDate db 'ss'

    mediaAns db '#'

    medianaAns db '#'

    modaAns db '#'

    minAns db '#'

    maxAns db '#'

    pathFile db 50 dup('$')

    parentName db 30 dup('$')

    verifyPath db 48
    
.code

	;description
main PROC
	     MOV   AX, @data
	     MOV   DS, AX
	     print margenStart
	     print messageWelcome
	     print margenEnd
         
	     MenuCalculator:
            print messageOption
            ReadKeyPad
            print messageOptionEnd
            print messageBash
            cmp al, 33h
            je EXIT
        EXIT:
            MOV   AH, 4ch
	        INT   21h
            print messageOptionEnd
	     
main ENDP
end main