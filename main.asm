include macros.asm
include file.asm
include Time.asm
include report.asm
include analyzer.asm
.model small

.stack 100h

.data
	margenStart         db '========================================================', 0aH, 0dH, '$'

	messageWelcome      db '*  UNIVERSIDAD DE SAN CARLOS DE GUATEMALA              *', 0aH, 0dH, '*  FACULTAD DE INGENIERIA                              *', 0aH, 0dH, '*  CIENCIAS Y SISTEMAS                                 *', 0aH, 0dH, '*  ARQUITECTURA DE COMPUTADORES Y EMSAMBLADORES 1      *', 0aH, 0dH, '*  NOMBRE: JUAN DANIEL ENRIQUE ROMAN BARRIENTOS        *', 0aH, 0dH, '*  CARNET: 201801364                                   *', 0aH, 0dH,  '$'

	margenEnd           db '*  SECCION: A                                          *', 0aH,  0dH, '********************************************************', 0aH , 0dH, '$'

	messageOption       db '*  1) CARGAR ARCHIVO                                   *', 0aH, 0dH, '*  2) CONSOLA                                          *', 0ah, 0dh, '*  3) SALIR                                            *', 0ah, 0dh, '*                                                      *', 0ah, 0dh, '*  :\> SELECT A OPTION: ','$'

	messageOptionEnd    db '                              *', 0ah, 0dh,'========================================================', 0ah, 0dh, '$'

	messageLoad         db 0ah, 0dh, '==================== CARGAR ARCHIVO ====================', '$'

	messageInputPath    db 0ah, 0dh, '  :\> Input Path:', '$'

	messageSuccessPath  db 0ah, 0dh, '  File read successfully :)',0ah,0dh, '$'

	messageErrorPath    db 0ah, 0dh, '  Error Read File', '$'

	newLine             db 0ah, 0dh, '$'

	path                db 100 dup('$')

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

	contentBufferJSON   db 50000 DUP('$')

	temp                db 100 DUP('$')

	sigNumber           db 30h

	operation1          dw 00h, '$'

	operation2          dw 00h, '$'

	operationTest       dw 00h, '$'

	sign                db 00h, '$'

	handleFile          dw ?

	studentJSON         db '{', 0ah, 0dh, 09h, '"reporte": {', 0ah, 0dh, 09h, 09h, '"alumno": {', 0ah, 0dh, 09h, 09h, 09h, '"Nombre": "Juan Daniel Enrique Roman Barrientos",', 0ah, 0dh, 09h, 09h, 09h, 09h, '"Carnet": 201801364,', 0ah, 0dh, 09h, 09h, 09h, '"Seccion": "A",', 0ah, 0dh, 09h, 09h, 09h, '"Curso": "Arquitectura de Computadoras y Ensambladores 1"', 0ah, 0dh, 09h, 09h, '},'

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

	pathFile            db 50 DUP('$')

	parentName          db 30 DUP('$')

	parentNameSize      dw 0

	listNumbers         db 250 dup('$')
	listValues          dw 250 dup('$')
	listValues2         dw 250 dup('$')
	resNumber           db 300 dup('$')

	verifyPath          db 30h
	counterNumbers      dw 0
	counterValue        dw 0
	
	

.code
main PROC
	               MOV                 AX, @data
	               MOV                 DS, AX

	MenuCalculator:
	               print               margenStart
	               print               messageWelcome
	               print               margenEnd
	               print               messageOption
	               ReadKeyPad
	               print               messageOptionEnd
	               CMP                 al, 31h
	               JE                  LOAD
	               CMP                 al, 32h
	               JE                  BASH
	               CMP                 al, 33h
	               JE                  EXIT

	LOAD:          
	               clearString         path
	               clearString         pathFile
	               clearString         contentBufferJSON

	               clearString         temp
	               clearString         listNumbers
	               clearString         listValues2
	               mov                 counterNumbers, 0
	               mov                 counterValue, 0

	               print               messageLoad
	               print               messageInputPath
	               GetPathFile         path
	               openFile            path, handleFile
	               readFile            contentBufferJSON, handleFile, SIZEOF contentBufferJSON
	               closeFile           handleFile
				   
	               simpleWhileAnalisis contentBufferJSON
	              ; generateReport
	               JMP                 MenuCalculator
	BASH:          
	               print               messageBash
	               print               ReadingKeyboad
	              
	               JMP                 MenuCalculator
	EXIT:          
	               MOV                 AH, 4ch
	               INT                 21h
	               print               messageOptionEnd


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
	     
main ENDP
	;description
timeConvert PROC
	               AAM
	               ADD                 ax, 3030h
	               ret
timeConvert ENDP
end main