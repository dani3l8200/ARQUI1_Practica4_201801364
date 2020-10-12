include macros.asm
include file.asm
include Time.asm
include report.asm
include analyzer.asm
.model small

.stack 100h

.data
	;********************************************************* Para Interfaz ***********************************************
	margenStart         db '========================================================', 0aH, 0dH, '$'
	messageWelcome      db '*  UNIVERSIDAD DE SAN CARLOS DE GUATEMALA              *', 0aH, 0dH, '*  FACULTAD DE INGENIERIA                              *', 0aH, 0dH, '*  CIENCIAS Y SISTEMAS                                 *', 0aH, 0dH, '*  ARQUITECTURA DE COMPUTADORES Y EMSAMBLADORES 1      *', 0aH, 0dH, '*  NOMBRE: JUAN DANIEL ENRIQUE ROMAN BARRIENTOS        *', 0aH, 0dH, '*  CARNET: 201801364                                   *', 0aH, 0dH,  '$'
	margenEnd           db '*  SECCION: A                                          *', 0aH,  0dH, '********************************************************', 0aH , 0dH, '$'
	messageOption       db '*  1) CARGAR ARCHIVO                                   *', 0aH, 0dH, '*  2) CONSOLA                                          *', 0ah, 0dh, '*  3) SALIR                                            *', 0ah, 0dh, '*                                                      *', 0ah, 0dh, '*  :\> SELECT A OPTION: ','$'
	messageOptionEnd    db '                              *', 0ah, 0dh,'========================================================', 0ah, 0dh, '$'
	messageLoad         db 0ah, 0dh, '==================== CARGAR ARCHIVO ====================', '$'
	messageInputPath    db 0ah, 0dh, '  :\> Input Path:', '$'
	messageSuccessPath  db 0ah, 0dh, '  File read successfully :)',0ah,0dh, '$'
	messageErrorPath    db 0ah, 0dh, '  Error Read File', '$'
	messageBash         db 0ah, 0dh, '==================== CONSOLA ===========================', '$'
	ReadingKeyboad      db 0ah, 0dh, '  :\> ', '$'
	ErrorReadingKeyboad db 0ah, 0dh, '  COMANDO NO ENCONTRADO', '$'
	messageMedia        db 0ah, 0dh, '  Estadistico Media: ', '$'
	messageModa         db 0ah, 0dh, '  Estadistico Moda: ', '$'
	messageMediana      db 0ah, 0dh, '  Estadistico Mediana: ', '$'
	messageMax          db 0ah, 0dh, '  Estadistico Mayor: ', '$'
	messageMin          db 0ah, 0dh, '  Estadistico Menor: ', '$'
	messageID           db 0ah, 0dh, '  Resultado: ', '$'
	messageErrorOpen    db 0ah, 0dh, '  ERROR: Not is possible open this file', '$'
	messageErrorCreate  db 0ah, 0dh, '  ERROR: Not is possible create the file', '$'
	messageErrorWrite   db 0ah, 0dh, '   ERROR: Not is possible write in the file', '$'
	messageErrorDelete  db 0ah, 0dh, '  ERROR: Not is possible delete the file', '$'
	messageErrorRead    db 0ah, 0dh, '  ERROR: Not is possible read the file', '$'
	messageErrorClose   db 0ah, 0dh, '  ERROR: Not is possible close the file', '$'
	;*************************************************************************************************************************************
	;*******************************************************************end for interfaz**************************************************
	
	;******************************************************************variables utilizadas***********************************************
	;realiza un salto de linea
	newLine             db 0ah, 0dh, '$'
	;array que almacenarada el path del archivo de entrada
	path                db 100 dup('$')
	;array para almacenar el contenido del archivo
	contentBufferJSON   db 50000 DUP('$')
	;array que tiene como funcion de ser ayuda para almcenara ciertos valores del archivo para realizar operaciones
	temp                db 100 DUP('$')                                                                                                                                                                                                                                                                                                                                                                                                                            	;
	;sigNumber esta variable indica que si el numero es negativo o positivo
	sigNumber           db 30h
	;variable de tipo word para almacenar la operacion1
	operation1          dw 00h, '$'
	;variable de tipo word para almacenar la operacion2
	operation2          dw 00h, '$'
	;variable de tipo word para prubas de si estaba operando bien xD
	operationTest       dw 00h, '$'
	;variable que almacenara el signo menos
	sign                db 00h, '$'
	;variable utilizada para los archivos
	handleFile          dw ?
	;variable utilizada para almacenar el nombre del reporte
	pathFile            db 50 DUP('$')
	;variable que recibe el nombre del reporte
	parentName          db 30 DUP('$')
	;variable para mostrar el size de las variables, seria equivalente a un length xd
	parentNameSize      dw 0
	;array usado para almacenar los nombres de las operaciones
	listNumbers         db 250 dup('$')
	;array usado para almacenar los resultados de las operaciones
	listValues          dw 250 dup('$')

	;array para el resultado
	resNumber           db 300 dup('$')
	;variable para verificar si ya se almaceno un padre id
	verifyPath          db 30h
	;variable para contadores de ids
	counterNumbers      dw 0
	;variable para contadores de los valores de las operaciones
	counterValue        dw 0
	;*************************************************Para el reporte***********************************************************************
	studentJSON         db '{', 0ah, 0dh, 09h, '"reporte": {', 0ah, 0dh, 09h, 09h, '"alumno": {', 0ah, 0dh, 09h, 09h, 09h, '"Nombre": "Juan Daniel Enrique Roman Barrientos",', 0ah, 0dh, 09h, 09h, 09h, '"Carnet": 201801364,', 0ah, 0dh, 09h, 09h, 09h, '"Seccion": "A",', 0ah, 0dh, 09h, 09h, 09h, '"Curso": "Arquitectura de Computadoras y Ensambladores 1"', 0ah, 0dh, 09h, 09h, '},'
	dayDateJSON         db 0ah, 0dh, 09h, 09h, '"Fecha": {', 0ah, 0dh, 09h, 09h, 09h, '"Dia": '
	monthDateJSON       db ',', 0ah, 0dh, 09h, 09h, 09h, '"Mes": '
	yearDateJSON        db ',', 0ah, 0dh, 09h, 09h, 09h, '"Año": 2020'
	hourDateJSON        db 0ah, 0dh, 09h, 09h, '},', 0ah, 0dh, 09h, 09h, '"Hora": {', 0ah, 0dh, 09h, 09h, 09h, '"Hora": '
	minuteDateJSON      db ',', 0ah, 0dh, 09h, 09h, 09h, '"Minutos": '
	secondsDateJSON     db ',', 0ah, 0dh, 09h, 09h, 09h, '"Segundos": '
	promResultJSON      db 0ah, 0dh, 09h, 09h, '},', 0ah, 0dh, 09h, 09h, '"resultados": {', 0ah, 0dh, 09h, 09h, 09h, '"Media": '
	medianaResultJSON   db ',', 0ah, 0dh, 09h, 09h, 09h, '"Mediana": '
	modaResultJSON      db ',', 0ah, 0dh, 09h, 09h, 09h, '"Moda": '
	minResultJSON       db ',', 0ah, 0dh, 09h, 09h, 09h, '"Menor": '
	maxResultJSON       db ',', 0ah, 0dh, 09h, 09h, 09h, '"Mayor": '
	operationsJSON      db 0ah, 09h, 09h, '},', 0ah, 09h, 09h, '"'
	operations1JSON     db '": ['
	operations2JSON     db 0ah, 09h, 09h, 09h, '{', 0ah, 09h, 09h, 09h, 09h
	doubleQuotes        db '"'
	doubleDot           db ": "
	operations3JSON     db 0ah, 09h, 09h, 09h, '},'
	endJSON             db 0ah, 09h, 09h, ']', 0ah, 09h, '}', 0ah, '}'
	dayDate             db 'dd'
	monthDate           db 'mm'
	hourDate            db 'hh'
	minuteDate          db 'mm'
	secondDate          db 'ss'
	mediaAns            db '#'
	medianaAns          db '#'
	modaAns             db '#'
	minAns              db '#'
	maxAns              db '#'
	;**********************************************************************************************************************************
	;**********************************************end content for report**************************************************************
	
.code
main PROC
	;esto es para incializar el programa
	               MOV                 AX, @data
	               MOV                 DS, AX

	MenuCalculator:
	;*********************impresion de la interfaz end dosBox*********************
	               print               margenStart
	               print               messageWelcome
	               print               margenEnd
	               print               messageOption
	;lee la consola
	               ReadKeyPad
	               print               messageOptionEnd
	;******************************************************************
	;compara que opcion fue usada, 1
	               CMP                 al, 31h
	               JE                  LOAD
	;compara que opcion fue usada, 2
	               CMP                 al, 32h
	               JE                  BASH
	;compara que opcion fue usada, 3
	               CMP                 al, 33h
	               JE                  EXIT

	LOAD:                                                                                     	
	;*****************limpia las variables utilizadas para la ejecucion de operaciones**********
	               clearString         path
	               clearString         pathFile
	               clearString         contentBufferJSON
	               clearString         temp
	               clearString         listNumbers
	               clearString         listValues
	;**********************************************************************************************
				   
	;inicializa los contadores  en 0
	               mov                 counterNumbers, 0
	               mov                 counterValue, 0

	;**************************para cargar el archivo***********************************************
	               print               messageLoad
	               print               messageInputPath
	;pide la ubicacion del archivo a cargar
	               GetPathFile         path
	;abre el archivo
	               openFile            path, handleFile
	;lee el archivo
	               readFile            contentBufferJSON, handleFile, SIZEOF contentBufferJSON
	;cierra el archivo
	               closeFile           handleFile
	;***************************************************************************************************

	;analiza el archivo de entrada y realiza las operaciones necesarias
	               simpleWhileAnalisis contentBufferJSON
	;genera el reporte
	               generateReport
	;vuelve al menu principal
	               JMP                 MenuCalculator
	BASH:          
	;aqui es para ingresar los comandos especiales
	               print               messageBash
	               print               ReadingKeyboad
	               ReadKeyPad
	;regresa al menu principal
	               JMP                 MenuCalculator
	EXIT:          
	;se acaba el programa
	               MOV                 AH, 4ch
	               INT                 21h
	               print               messageOptionEnd

	;******************************Esto es para mensajes de errores**********************************************
	ErrorOpen:     
	               print               messageErrorOpen
	               ReadKeyPad
	               JMP                 MenuCalculator
	ErrorCreate:   
	               print               messageErrorCreate
	               ReadKeyPad
	               JMP                 MenuCalculator
	ErrorWrite:    
	               print               messageErrorWrite
	               ReadKeyPad
	               JMP                 MenuCalculator
	ErrorRead:     
	               print               messageErrorRead
	               ReadKeyPad
	               JMP                 MenuCalculator
	ErrorClose:    
	               print               messageErrorClose
	               ReadKeyPad
	               JMP                 MenuCalculator
	ErrorDelete:   
	               print               messageErrorDelete
	               ReadKeyPad
	               JMP                 MenuCalculator
	;**************************************************************************************************************************
main ENDP
	;description

	;metodo para convertir el tiempo
timeConvert PROC
	               AAM
	               ADD                 ax, 3030h
	               ret
timeConvert ENDP
end main