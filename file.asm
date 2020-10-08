GetPathFile MACRO array
	            LOCAL      getCadena, endCadena, RemoveSpace
    
	            MOV        SI, 0
	getCadena:  
	            ReadKeyPad
	            CMP        AL, 0dh
	            JE         endCadena
	            CMP        AL, 08h
	            JE         RemoveSpace
	            MOV        array[SI], AL
	            INC        SI
	            JMP        getCadena
	RemoveSpace:
	            MOV        AL, 24h
	            DEC        SI
	            MOV        array[SI], AL
	            JMP
	endCadena:  
	            MOV        array[SI], 00h
ENDM

openFile MACRO file, handler
	         MOV AH, 3dh    	;abre el archivo
	         MOV AL, 010B   	;Acceso lectura/escritura
	         lea DX, file   	;realiza una lectura con la informacion
	         int 21h
	         MOV handler, AX	;transfiere la informacion al handler
	         jc  ErrorOpen  	;si hay carry lanzara un error ya que no pudo abrir el archivo con exito
ENDM

createFile MACRO file, handler
	           MOV AH, 3ch    	;crea el archivo
	           MOV CX, 00h    	;mueve al inicio del archivo
	           lea DX, file   	;realiza una lectura con la informacion
	           int 21h
	           MOV handler, AX	;transfiere la informacion al handler
	           jc  ErrorCreate	;si hay carry lanzara un error ya que no se creo con exito el archivo
ENDM

writeFile MACRO array, handler, numBytes
	          PUSH CX
	          PUSH DX

	          MOV  AH, 40h
	          MOV  BX, handler
	          MOV  CX, numBytes
	          lea  DX, array
	          int  21h
	          jc   ErrorWrite

	          POP  DX
	          POP  CX
ENDM

readFile MACRO array, handler, numBytes
    MOV AH, 3fh
    MOV BX, handler
    MOV CX, numBytes
    lea DX, array
    int 21h
    jc ErrorRead
ENDM

closeFile MACRO handler
    MOV AH, 3eh
    mov handler, BX
    int 21h
    jc ErrorClose
ENDM

deleteFile MACRO buffer
    MOV AH, 41h
    lea DX, buffer
    jc ErrorDelete
ENDM