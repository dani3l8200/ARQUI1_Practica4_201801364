print MACRO cadena
	          LOCAL      flagPrint
	          SetData
	flagPrint:
	          MOV        AH, 09h          	;ALmacena la poSIcion esto le indica a ah que escriba en consola
	          MOV        DX, offset cadena	;ALmacena la direccion en el registro DX
	          int        21h              	;para el kernel de dos
	          RemoveData
ENDM

ReadKeyPad MACRO
	           MOV AH, 01h	;ALmacena un 1 en AH que esto indica que se ponga en modo de escritura
	           int 21h    	;para el kernel de dos
ENDM

GetText MACRO buffer
	          LOCAL      getCadena, moveSpace, EndC
	          SetData
    
	          MOV        SI, 0
	getCadena:
	          ReadKeyPad
	          CMP        AL, 0dh
	          JE         EndC
	          CMP        AL, 08h
	          JE         moveSpace
	          MOV        buffer[SI], AL
	          INC        SI
	          JMP        getCadena
    
	moveSpace:
	          MOV        AL, 24h
	          dec        SI
	          MOV        buffer[SI], AL
	          JMP        getCadena

	EndC:     
	          MOV        AL, '$'
	          MOV        buffer[SI], AL
	          RemoveData
ENDM

clearString MACRO buffer
	            LOCAL      repeatClear
	            SetData
	            mov        si, 0
	            mov        cx, 0
	            mov        cx, SIZEOF buffer

	repeatClear:
	            mov        buffer[si], '$'
	            inc        si
	            LOOP       repeatClear
	            RemoveData
ENDM

splitText MACRO array
	                LOCAL      Split, RepleaSplit, StringAnalizado, EndAnalisis, Minus
	                SetData
	                MOV        si, 0
	                MOV        CX, 0
	                MOV        BX, 0
	                MOV        DX, 0
	                MOV        DL, 0ah
	                test       AX, 1000000000000000
	                jnz        Minus
	                JMP        Split
	Minus:          
	                neg        AX
	                MOV        array[si], 2dh
	                INC        si
	                JMP        Split

	RepleaSplit:                                                                      	;
	                MOV        AH, 0
	Split:          
	                div        DL
	                INC        CX
	                PUSH       AX
	                CMP        AL, 00h
	                JE         StringAnalizado
	                JMP        RepleaSplit
    
	StringAnalizado:
	                POP        AX
	                add        ah, 30h
	                MOV        array[si], ah
	                INC        si
	                LOOP       StringAnalizado
	                MOV        ah, 24h
	                MOV        array[si], ah
	                INC        si
	EndAnalisis:    
	                RemoveData
ENDM

compareString MACRO buffer, command, equal
	              SetData
	              mov        AX, DS
	              mov        ES, AX
	              mov        cx, 5

	              lea        si, buffer
	              lea        di, command
	              repe       cmpsb
	              RemoveData
	              je         equal
ENDM

intToString MACRO number
	            LOCAL beginConv, EndConv
	; SetData
	            mov   AX, 0
	            mov   bx, 0
	            mov   cx, 0
	            mov   bx, 10            	;este 10 sirve como tempiliar para unir los numeros a uno solo por centenas, decenas y unidades
	            mov   si, 0

	beginConv:  
	            mov   CL, number[si]
	            cmp   CL, 48
	            jl    EndConv
	            cmp   CL, 57
	            jg    EndConv
	            inc   si
	            sub   cl, 48
	            mul   bx
	            add   ax, cx
	            JMP   beginConv
	EndConv:    
	;RemoveData
ENDM

getNumber MACRO buffer
	          LOCAL      beginInt, endInt
	          mov        si, 0
	beginInt: 
	          ReadKeyPad
	          cmp        al, 0dh         	;compara si hay un reset
	          je         endInt          	;si es asi es porque ya termino la cadena
	          mov        buffer[si], al  	;movemos lo que hay de al asi la posicion del buffer
	          inc        si
	          JMP        beginInt        	;repite lo mismo si es posible
	endInt:   
	          mov        buffer[si], 00h 	;se verifica si ya no hay nada
ENDM


simpleWhileAnalisis MACRO buffer
	                    LOCAL       While, Continue, endW, IDS, SaveID, SaveFatherC, SaveWhile, endWSF, seachNumber, WhileNum, endWNumber
	                    LOCAL       checkOp, div0, div1, div2, div3, mul0, mul1, mul2, mul3, add0, add1, add2, add3, sub0, sub1, sub2, sub3
	                    LOCAL       id0, id1, id2, id3, Whilecheck, endWCheck
	                    mov         si, 0
	                    mov         cx, 0
	                    mov         [verifyPath], 30h
	                    mov         ax, '^'
	                    PUSH        ax
	While:              
	                    mov         dh, buffer[si]
	                    cmp         dh, 22h                                                                                                	;aqui verificamos si vienen IDS, para guardarlos para el uso del a consola xd
	                    je          IDS
	                    jmp         Continue
	Continue:           
	                    cmp         dh, '$'                                                                                                	;transfiere la direccion al registro data
	                    je          endW
	                    inc         si                                                                                                     	;verifica si hay mas " para seguir guardando los ids, para las operaciones hijos xd
	                    jmp         While
	IDS:                
	                    inc         si
	                    mov         dh, buffer[si]
	                    cmp         dh, 22h                                                                                                	;ahora si verificamos si encuentra la " de cierre para guardar los IDS
	                    je          SaveID

	                    cmp         dh, 23h                                                                                                	;esto es para las variables que declare en el main con # donde iran los resultados xd
	                    je          seachNumber

	                    PUSH        SI                                                                                                     	;guardamos la posicion
	                    mov         si, 0
	                    mov         si, cx
	                    mov         temp[si], dh
	                    inc         cx                                                                                                     	;incrementamos el contador para el registro del ciclo xd
	                    POP         si

	                    jmp         IDS
	SaveID:             
	                    mov         cx, 0                                                                                                  	;xor cx, cx
	                    mov         ax, 0                                                                                                  	;reiniciamos los registros
	                    mov         ah, temp
	                    PUSH        ax
		
	                    cmp         [verifyPath], 30h                                                                                      	; verifica si ya termino de analizar el archivo para guardar el ID padre
	                    je          SaveFatherC
		
	; print       temp
	                    clearString temp
	;ReadKeyPad                                                                                                       	;limpiamos la cadena para que si se analiza otro archivo no vuelve a tener en el buffer la misma informacion
		
	                    inc         si
	                    jmp         While

	SaveFatherC:        
	                    SetData
	                    mov         si, 0
	SaveWhile:          
	                    mov         dh, temp[si]
	                    cmp         dh, '$'                                                                                                	;verifica si ya es el fin de la cadena de datos a guardar
	                    je          endWSF
	                    mov         pathFile[si], dh
	            
	                    mov         parentName[si], dh
	           
	                    inc         si
	                    jmp         SaveWhile
	endWSF:             
	                    mov         pathFile[si], '.'
	                    inc         si
	                    mov         pathFile[si], 'j'
	                    inc         si
	                    mov         pathFile[si], 's'
	                    inc         si
	                    mov         pathFile[si], 'o'
	                    inc         si
	                    mov         pathFile[si], 00h
	                    mov         [verifyPath], 31h
	;  print       pathFile
	                    RemoveData
	                    clearString temp
	                    inc         si
	                    jmp         While

	seachNumber:        
	                    inc         si
	                    inc         si
	                    inc         si
	                    jmp         WhileNum
	WhileNum:           
	                    inc         si
	                    mov         dh, buffer[si]
	                    cmp         dh, 2ch
	                    je          endWNumber
	                    cmp         dh, 7dh
	                    je          endWNumber
	                    cmp         dh, 0ah
	                    je          endWNumber
	                    PUSH        SI
	                    mov         si, 0
	                    mov         si, cx
	                    mov         temp[si], dh
	                    inc         cx
	                    POP         si
	                    jmp         WhileNum
	
	endWNumber:         
	                    mov         cx, 0
	                    mov         ax, 0
	                    mov         ah, temp
	                    PUSH        ax
	                    print       temp
	                    clearString temp
	                    ReadKeyPad

	                    inc         si
	                    JMP         While
	endW:               


ENDM


SetData MACRO
	        PUSH AX
	        PUSH BX
	        PUSH CX
	        PUSH DX
	        PUSH SI
	        PUSH DI
ENDM

RemoveData MACRO
	           POP DI
	           POP SI
	           POP DX
	           POP CX
	           POP BX
	           POP AX
ENDM