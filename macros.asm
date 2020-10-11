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

splitText MACRO array, seek
	                LOCAL Split, RepleaSplit, StringAnalizado, EndAnalisis, Minus
	                PUSH  SI
	                PUSH  CX

	                MOV   si, 0
	                MOV   CX, 0
	                MOV   BX, 0
	                MOV   DX, 0
	                MOV   bx, 0ah
	                MOV   ax, seek
	                test  AX, 1000000000000000
	                jnz   Minus
	                JMP   Split
	Minus:          
	                neg   AX
	                MOV   array[si], 2dh
	                INC   si
	                JMP   Split

	RepleaSplit:                                                                 	;
	                MOV   dx, 0
	Split:          
	                div   bx
	                INC   CX
	                PUSH  DX
	                CMP   AX, 00h
	                JE    StringAnalizado
	                JMP   RepleaSplit
    
	StringAnalizado:
	                POP   AX
	                add   ax, 30h
	                MOV   array[si], ax
	                INC   si
	                LOOP  StringAnalizado
	                MOV   ax, 24h
	                MOV   array[si], ax
	                
	EndAnalisis:    
	                POP   CX
	                POP   SI
ENDM

compareString MACRO buffer, command, equal
	              SetData
	              mov        AX, DS
	              mov        ES, AX
	              mov        cx, 1eh

	              lea        si, buffer
	              lea        di, command
	              repe       cmpsb
	              RemoveData
	              je         equal
ENDM

intToString MACRO number, output
	            LOCAL      beginConv, EndConv
	            SetData
	            mov        AX, 0
	            mov        bx, 0
	            mov        cx, 0
	            mov        bx, 10            	;este 10 sirve como tempiliar para unir los numeros a uno solo por centenas, decenas y unidades
	            mov        si, 0

	beginConv:  
	            mov        CL, number[si]
	            cmp        CL, 30h
	            jl         EndConv
	            cmp        CL, 39h
	            jg         EndConv
	            inc        si
	            sub        cl, 30h
	            mul        bx
	            add        ax, cx
	            JMP        beginConv
	EndConv:    
	            mov        output, ax
	            RemoveData
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