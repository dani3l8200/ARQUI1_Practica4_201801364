generateReport MACRO
	               getDate                                                                       	;obtiene la fecha del dia actual
	               getTime                                                                       	;obtiene el tiempo de dia actua

	               deleteFile             pathFile                                               	;elimina el archivo si es que existe en el directorio
	               createFile             pathFile, handleFile                                   	;recrea el archivo si lo es necesario
	               openFile               pathFile, handleFile                                   	;abre el archivo en mode escritura

	;**********************************Escribe el cuerpo del reporte***********************************
	               writeFile              studentJSON, handleFile, SIZEOF studentJSON
	               writeFile              dayDateJSON, handleFile, SIZEOF dayDateJSON
	               writeFile              dayDate, handleFile, SIZEOF dayDate
	               writeFile              monthDateJSON, handleFile, SIZEOF monthDateJSON
	               writeFile              monthDate, handleFile, SIZEOF monthDate
	               writeFile              yearDateJSON, handleFile, SIZEOF yearDateJSON
	               writeFile              hourDateJSON, handleFile, SIZEOF hourDateJSON
	               writeFile              hourDate, handleFile, SIZEOF hourDate
	               writeFile              minuteDateJSON, handleFile, SIZEOF minuteDateJSON
	               writeFile              minuteDate, handleFile, SIZEOF minuteDate
	               writeFile              secondsDateJSON, handleFile, SIZEOF secondsDateJSON
	               writeFile              secondDate, handleFile, SIZEOF secondDate

	               writeFile              promResultJSON, handleFile, SIZEOF promResultJSON
	               clearString            operationTest
	               splitText              operationTest, mediaAns
	               lengthString32BITS     operationTest, parentNameSize
	               writeFile              operationTest, handleFile, parentNameSize

	               writeFile              medianaResultJSON, handleFile, SIZEOF medianaResultJSON
	               clearString            operationTest
	               splitText              operationTest, medianaAns
	               lengthString32BITS     operationTest, parentNameSize
	               writeFile              operationTest, handleFile, parentNameSize

	               
	               writeFile              modaResultJSON, handleFile, SIZEOF modaResultJSON
	               clearString            operationTest
	               splitText              operationTest, modaAns
	               lengthString32BITS     operationTest, parentNameSize
	               writeFile              operationTest, handleFile, parentNameSize
				   
	    
	               writeFile              minResultJSON, handleFile, SIZEOF minResultJSON
	               clearString            operationTest
	               splitText              operationTest, minAns
	               lengthString32BITS     operationTest, parentNameSize
	               writeFile              operationTest, handleFile, parentNameSize
				   
	               writeFile              maxResultJSON, handleFile, SIZEOF maxResultJSON
	               clearString            operationTest
	               splitText              operationTest, maxAns
	               lengthString32BITS     operationTest, parentNameSize
	               writeFile              operationTest, handleFile, parentNameSize
	               
	;**************************************************************************************************************

	               writeFile              operationsJSON, handleFile, SIZEOF operationsJSON      	;escribe el padre de las operaciones
	               lengthString16BITS     parentName, parentNameSize                             	;pone el id correspondiente la padre del archivo
	               writeFile              parentName, handleFile, parentNameSize                 	;obtiene de la longitud del padre
	               
	               generatePartOperations                                                        	;genera las operaciones del archivo operacion1, operacion2 etc
				   
	               writeFile              endJSON, handleFile, SIZEOF endJSON                    	;termina de escribir el archivo

	              

	               closeFile              handleFile                                             	;cierra el archivo

	;end of report

ENDM

lengthString16BITS MACRO buffer, incBuffer
	                   LOCAL      While, endString
	                   SetData
	                   mov        si, 0           	;limpiamos el contador
	While:             
	                   mov        dh, buffer[si]  	;almacenamos en dh el caracter de la cadena a obtener la longitud
	                   cmp        dh, '$'         	;verifica si dh ya tiene el $
	                   je         endString       	; si lo tiene entonces pues terminamos de iterar el while xd
	                   inc        si              	;incrementamos en caso de que aun no haya $
	                   jmp        While           	;vuelve a iterar
	endString:         
	                   mov        incBuffer, si   	;almacenamos el size del si en incBuffer para indicar la longitud de la cadena
	                   RemoveData

ENDM

lengthString32BITS MACRO buffer, incBuffer
	                   LOCAL      While, endString
	                   SetData
	                   mov        si, 0           	;limpiamos el contador
	While:             
	                   mov        dx, buffer[si]  	;almacenamos en dh el caracter de la cadena a obtener la longitud
	                   cmp        dx, '$'         	;verifica si dh ya tiene el $
	                   je         endString       	; si lo tiene entonces pues terminamos de iterar el while xd
	                   inc        si              	;incrementamos en caso de que aun no haya $
	                   jmp        While           	;vuelve a iterar
	endString:         
	                   mov        incBuffer, si   	;almacenamos el size del si en incBuffer para indicar la longitud de la cadena
	                   RemoveData

ENDM


generatePartOperations MACRO
	                       LOCAL              start, sEnd, While1, endWhile1, While2


	;empieza a escribir { y la estructura para las operaciones
	                       writeFile          operations1JSON, handleFile, SIZEOF operations1JSON

	;*********************SETEAMOS los registros SI, DI y cX con 0 ***********
	                       mov                si, 0
	                       mov                di, 0
	                       mov                cx, 0
	;************************************************************************

	start:                                                                                       	;movemos el id de las lista de ids al registro dh en la posicion que tiene SI
	                       mov                dh, listNumbers[si]
	;compara si ya la lista no tiene IDS
	                       cmp                dh, '$'
	;de ser asi termina el proceso en sEnd
	                       je                 sEnd
	;estos es para escribir lods ids en lso reportes por ejemplo  ,"
	                       writeFile          operations2JSON, handleFile, SIZEOF operations2JSON
	                       writeFile          doubleQuotes, handleFile, SIZEOF doubleQuotes

	While1:                
	;movemos el valor de los ids a dh
	                       mov                dh, listNumbers[si]
	;compara si en temp existe el valor tope que separa cada id
	                       mov                temp, dh
	                       cmp                temp, '^'
	;si lo tiene se salta a mover la operacion para el reporte
	                       je                 endWhile1
	;incrementa si
	                       inc                si
	;obtiene la longitud del id
	                       lengthString16BITS temp, parentNameSize
	; escribe el id en el archivo
	                       writeFile          temp, handleFile, parentNameSize
	                       jmp                While1
	endWhile1:             
	;realiza un cierre de comillas para los ids
	                       writeFile          doubleQuotes, handleFile, SIZEOF doubleQuotes
	                       writeFile          doubleDot, handleFile, SIZEOF doubleDot
						  
	;convierte el valor a strign de la lista de valores de las operaciones
	                       splitText          operationTest, listValues[di]
	;obtiene la longitud de la operacion
	                       lengthString32BITS operationTest, parentNameSize
	;escribe el resultado de la opearcion en el reporte
	                       writeFile          operationTest, handleFile, parentNameSize
	;limpia la variable
	                       clearString        operationTest
	;incremetno de di dos veces por que es de tipo dw
	                       inc                di
	                       inc                di
	;ciera la operacion hija y continua leyendo las lista y escribiendo en el reporte si es que encuentras mas
	                       writeFile          operations3JSON, handleFile, SIZEOF operations3JSON

	                       inc                SI
	                       JMP                start
	sEnd:                  


ENDM