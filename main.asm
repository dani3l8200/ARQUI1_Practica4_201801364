include macros.asm

.model small

.stack 100h

.data

	margenStart    db '********************************************************', 0aH, 0dH, '$'

	messageWelcome db '*  UNIVERSIDAD DE SAN CARLOS DE GUATEMALA              *', 0aH, 0dH, '*  FACULTAD DE INGENIERIA                              *', 0aH, 0dH, '*  CIENCIAS Y SISTEMAS                                 *', 0aH, 0dH, '*  ARQUITECTURA DE COMPUTADORES Y EMSAMBLADORES 1      *', 0aH, 0dH, '*  NOMBRE: JUAN DANIEL ENRIQUE ROMAN BARRIENTOS        *', 0aH, 0dH, '*  CARNET: 201801364                                   *', 0aH, 0dH,  '$'

	margenEnd      db '*  SECCION: A                                          *', 0aH,  0dH, '********************************************************', 0aH , 0dH, '$'

    messageOption  db '*  1) CARGAR ARCHIVO                                   *', 0aH, 0dH, '*  2) CONSOLA                                          *', 0ah, 0dh, '*  3) SALIR                                            *', 0ah, 0dh, '*                                                      *', 0ah, 0dh, '*  SELECT A OPTION: ','$'

    messageOptionEnd db '                                  *', 0ah, 0dh,'********************************************************', 0ah, 0dh, '$'
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
            cmp al, 33h
            je EXIT
        EXIT:
            MOV   AH, 4ch
	        INT   21h
            print messageOptionEnd
	     
main ENDP
end main