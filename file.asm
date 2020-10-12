;GetPahtFile sirve para introducir el directorio donde se encuentre algun archivo 
GetPathFile MACRO array
	            LOCAL      getCadena, endCadena, RemoveSpace
				; setea el registro SI con 0
	            MOV        SI, 0
	getCadena:  
				;lee la consola para introducir la ubicacion del archivo
	            ReadKeyPad
				;compara si hay un enter que seria un retorno de carro
	            CMP        AL, 0dh
	            JE         endCadena
				;esto es por si se metio mal alguna letra poder borrar la de atras
	            CMP        AL, 08h
	            JE         RemoveSpace
				;se mueve al path el contenido 
	            MOV        array[SI], AL
				;incrementa SI
	            INC        SI
				;se vuelve a repetir el ciclo
	            JMP        getCadena
	RemoveSpace:
				;mueve un fin de cadena a AL
	            MOV        AL, 24h
				;decrementa SI SI--
	            DEC        SI
				;mueve el caracter al path una casilla anterior
	            MOV        array[SI], AL
				;regresa al getCadena para seguir anadiendo al path
	            JMP        getCadena
	endCadena:  
				;termina de ingresar el path 
	            MOV        array[SI], 00h
ENDM

openFile MACRO file, handler
	         MOV AH, 3dh    	;abre el archivo
	         MOV AL, 10b   	;Acceso lectura/escritura
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

;macro para escribir el archivo 
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
;macro para leer el archivo 
readFile MACRO array, handler, numBytes
	         MOV AH, 3fh
	         MOV BX, handler
	         MOV CX, numBytes
	         lea DX, array
	         int 21h
	         jc  ErrorRead
			 print messageSuccessPath
ENDM

;macro para cerrar el archivo
closeFile MACRO handler
	          MOV AH, 3eh
	          mov handler, BX
	          int 21h
	          jc  ErrorClose
ENDM
;macro para eliminar el archivo 
deleteFile MACRO buffer
	           MOV AH, 41h
	           lea DX, buffer
	           jc  ErrorDelete
ENDM