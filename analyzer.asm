simpleWhileAnalisis MACRO buffer
	                    LOCAL       While, Continue, endW, IDS, SaveID, SaveFatherC, SaveWhile, endWSF, seachNumber, WhileNum, endWNumber
	                    LOCAL       checkOp, div0, div1, div2, div3, mul0, mul1, mul2, mul3, add0, add1, add2, add3, sub0, sub1, sub2, sub3
	                    LOCAL       id0, id1, id2,  Whilecheck, WhileSI, endWhileSI, searchTrash, negNumbers
	                    LOCAL       PRODUCT, ADITION, SUBSTRACTION, DIVISION, continueOpeartion, saveOperation, notOperations, negNumbers2
	                    mov         si, 0
	                    mov         cx, 0
	                    mov         [verifyPath], 30h
	                    mov         ax, 0
	                    mov         ah, '^'
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
	                    je          Whilecheck

	                    cmp         dh, 23h                                                                                                	;esto es para las variables que declare en el main con # donde iran los resultados xd
	                    je          seachNumber

	                    PUSH        SI                                                                                                     	;guardamos la posicion
	                    mov         si, 0
	                    mov         si, cx
	                    mov         temp[si], dh
	                    inc         cx                                                                                                     	;incrementamos el contador para el registro del ciclo xd
	                    POP         si

	                    jmp         IDS
	Whilecheck:         
	                    mov         ax, 0
	                    mov         cx, 0

	                    cmp         [verifyPath], 30h
	                    je          SaveFatherC

	                    cmp         temp[0], 'D'
	                    je          div1
	                    cmp         temp[0], 'd'
	                    je          div1
	                    cmp         temp[0], '/'
	                    je          div0

	                    cmp         temp[0], 'M'
	                    je          mul1
	                    cmp         temp[0], 'm'
	                    je          mul1
	                    cmp         temp[0], '*'
	                    je          mul0

	                    cmp         temp[0], 'S'
	                    je          sub1
	                    cmp         temp[0], 's'
	                    je          sub1
	                    cmp         temp[0], '-'
	                    je          sub0

	                    cmp         temp[0], 'a'
	                    je          add1
	                    cmp         temp[0], 'A'
	                    je          add1
	                    cmp         temp[0], '+'
	                    je          add0

	                    cmp         temp[0], 'i'
	                    je          id1
	                    cmp         temp[0], 'I'
	                    je          id1

	                    jmp         SaveID

	SaveID:             
	                    SetData
	                    mov         si, 0
	                    mov         di, counterNumbers
	
	WhileSI:            
	                    mov         dh, temp[si]
	                    cmp         dh, '$'
	                    je          endWhileSI

	                    mov         listNumbers[di], dh
	                    inc         di
	                    inc         si
	                    jmp         WhileSI
	endWhileSI:         
	                    mov         listNumbers[di], '^'
	                    inc         di
	                    mov         counterNumbers, di
	                    
						;print listNumbers
						;ReadKeyPad
	; print       counterValue
	; ReadKeyPad
		
	                    RemoveData
	                    clearString temp
	;limpiamos la cadena para que si se analiza otro archivo no vuelve a tener en el buffer la misma informacion
		
	                    inc         si
	                    jmp         While

	div0:               
	                    mov         ax, 0
	                    mov         ah, '/'
	                    PUSH        AX
	                    clearString temp
	                    inc         si
	                    jmp         While
	div1:               
	                    cmp         temp[1], 'I'
	                    je          div2
	                    cmp         temp[1], 'i'
	                    je          div2
	                    jmp         SaveID
	div2:               
	                    cmp         temp[2], 'v'
	                    je          div3
	                    cmp         temp[2], 'V'
	                    je          div3
	                    jmp         SaveID
	div3:                                                                                                                                  	;
	                    cmp         temp[3], '$'
	                    je          div0
	                    jmp         SaveID
	add0:               
	                    mov         ax, 0
	                    mov         ah, '+'
	                    PUSH        AX
	                    clearString temp
	                    inc         si
	                    jmp         While
	add1:               
	                    cmp         temp[1], 'd'
	                    je          add2
	                    cmp         temp[1], 'D'
	                    je          add2
	                    jmp         SaveID
	add2:               
	                    cmp         temp[2], 'D'
	                    je          add3
	                    cmp         temp[2], 'd'
	                    je          add3
	                    jmp         SaveID
	add3:               
	                    cmp         temp[3], '$'
	                    je          add0
	                    jmp         SaveID
	sub0:               
	                    mov         ax, 0
	                    mov         ah, '-'
	                    PUSH        AX
	                    clearString temp
	                    inc         si
	                    jmp         While
	sub1:               
	                    cmp         temp[1], 'u'
	                    je          sub2
	                    cmp         temp[1], 'U'
	                    je          sub2
	                    jmp         SaveID
	sub2:               
	                    cmp         temp[2], 'B'
	                    je          sub3
	                    cmp         temp[2], 'b'
	                    je          sub3
	                    jmp         SaveID
	sub3:               
	                    cmp         temp[3], '$'
	                    je          sub0
	                    jmp         SaveID
	mul0:               
	                    mov         ax, 0
	                    mov         ah, '*'
	                    PUSH        ax
	                    clearString temp
	                    inc         si
	                    jmp         While
	mul1:               
	                    cmp         temp[1], 'u'
	                    je          mul2
	                    cmp         temp[1], 'U'
	                    je          mul2
	                    jmp         SaveID
	mul2:               
	                    cmp         temp[2], 'l'
	                    je          mul3
	                    cmp         temp[2], 'L'
	                    je          mul3
	                    jmp         SaveID
	mul3:               
	                    cmp         temp[3], '$'
	                    je          mul0
	                    jmp         SaveID
	id0:                
	                    clearString temp
	                    inc         si
	                    jmp         While
	id1:                
	                    cmp         temp[1], 'd'
	                    je          id2
	                    cmp         temp[1], 'D'
	                    je          id2
	id2:                
	                    cmp         temp[3], '$'
	                    je          id0
	                    jmp         SaveID
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
	searchTrash:        
	                    inc         si
	                    mov         dh, buffer[si]
	                    cmp         dh, 22h
	                    je          searchTrash
	                    cmp         dh, 3ah
	                    je          searchTrash
	                    cmp         dh, 20h
	                    je          searchTrash
	                    cmp         dh, 0ah
	                    je          searchTrash
	                    cmp         dh, 0dh
	                    je          searchTrash
	                    cmp         dh, 09h
	                    je          searchTrash
	                    dec         si
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
	                    cmp         dh, 2dh
	                    je          negNumbers
	                    PUSH        SI
	                    mov         si, 0
	                    mov         si, cx
	                    mov         temp[si], dh
	                    inc         cx
	                    POP         si
	                    jmp         WhileNum
	negNumbers:         
	                    mov         [sigNumber], 31h
	                    jmp         WhileNum
		
	endWNumber:         
	                    mov         cx, 0
	                    intToString temp, operation2
	                    cmp         [sigNumber], 30h
	                    je          negNumbers2
	                    neg         operation2
	negNumbers2:        
	                    mov         ax, 0
	                    POP         AX
	                    clearString temp
	                    mov         temp, al
	                    cmp         temp, 00h
	                    je          notOperations
	                    mov         operation1, ax

	                    mov         ax, 0
	                    POP         ax

	                    clearString temp
	                    mov         temp, ah
	                    cmp         temp, '+'
	                    je          ADITION
	                    cmp         temp, '-'
	                    je          SUBSTRACTION
	                    cmp         temp, '*'
	                    je          PRODUCT
	                    cmp         temp, '/'
	                    je          DIVISION
	notOperations:      
	                    clearString temp
	                    mov         temp, ah
	                    cmp         temp, '^'
	                    je          saveOperation

	                    PUSH        AX

	                    PUSH        operation2
						print temp
						clearString temp
						ReadKeyPad
						
	                    mov         [sigNumber], 30h

	                    inc         si
	                    jmp         While
	saveOperation:      
	                    mov         ax, 0
	                    mov         ah, '^'
	                    PUSH        AX
	                    SetData
	                    mov         di, counterValue
	                    mov         ax, operation2
	                    mov         listValues[di], ax
	                    inc         counterValue
	                    inc         counterValue
	                    RemoveData
						splitText operation2, operation2
						print operation2
	                    clearString temp
	                    mov         [sigNumber], 30h
	                    inc         si
	                    jmp         While
	continueOpeartion:  
	                    mov         ax, 0
	                    POP         AX
	                    clearString temp
	                    mov         temp, al
	                    cmp         temp, 00h
	                    je          notOperations
	                    mov         operation1, ax
	                    mov         ax, 0
	                    POP         ax
	                    clearString temp
	                    mov         temp, ah

	                    cmp         temp, '+'
	                    je          ADITION
	                    cmp         temp, '-'
	                    je          SUBSTRACTION
	                    cmp         temp, '*'
	                    je          PRODUCT
	                    cmp         temp, '/'
	                    je          DIVISION

	ADITION:            
	                    mov         ax, operation1
	                    mov         bx, operation2
	                    add         ax, bx
		
	                    clearString operation1
	                    clearString operation2

	                    mov         operation2, ax
	                    jmp         continueOpeartion
	SUBSTRACTION:       
	                    mov         ax, operation1
	                    mov         bx, operation2
	                    sub         ax, bx
	                    clearString operation1
	                    clearString operation2
	                    mov         operation2, ax
	                    jmp         continueOpeartion
	DIVISION:           
	                    mov         ax, operation1
	                    mov         bx, operation2
	                    cwd
	                    idiv        bx
	
	                    clearString operation1
	                    clearString operation2
	                    mov         operation2, ax
	                    jmp         continueOpeartion
	PRODUCT:            
	                    mov         ax, operation1
	                    mov         bx, operation2
	                    imul        bx
	
	                    clearString operation1
	                    clearString operation2
	
	                    mov         operation2, ax
	                    jmp         continueOpeartion
	                   
	endW:               
	    mov dh, listNumbers[0]
		mov temp, dh

		print listNumbers
		print newLine

		splitText operationTest, listValues[0]
		print operationTest
		ReadKeyPad

		splitText operationTest, listValues[2]
		print operationTest
		ReadKeyPad
ENDM