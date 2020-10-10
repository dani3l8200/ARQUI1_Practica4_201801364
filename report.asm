generateReport MACRO
	               getDate
	               getTime

	               deleteFile pathFile
	               createFile pathFile, handleFile
	               openFile   pathFile, handleFile

	               writeFile  studentJSON, handleFile, SIZEOF studentJSON
	               writeFile  dayDateJSON, handleFile, SIZEOF dayDateJSON
	               writeFile  dayDate, handleFile, SIZEOF dayDate
	               writeFile  monthDateJSON, handleFile, SIZEOF monthDateJSON
	               writeFile  monthDate, handleFile, SIZEOF monthDate
	               writeFile  yearDateJSON, handleFile, SIZEOF yearDateJSON
	               writeFile  hourDateJSON, handleFile, SIZEOF hourDateJSON
	               writeFile  hourDate, handleFile, SIZEOF hourDate
	               writeFile  minuteDateJSON, handleFile, SIZEOF minuteDateJSON
	               writeFile  minuteDate, handleFile, SIZEOF minuteDate
	               writeFile  secondsDateJSON, handleFile, SIZEOF secondsDateJSON
	               writeFile  secondDate, handleFile, SIZEOF secondDate
	               writeFile  promResultJSON, handleFile, SIZEOF promResultJSON
	               writeFile  mediaAns, handleFile,  SIZEOF mediaAns
	               writeFile  medianaResultJSON, handleFile, SIZEOF medianaResultJSON
	               writeFile  medianaAns, handleFile, SIZEOF medianaAns
	               writeFile  modaResultJSON, handleFile, SIZEOF modaResultJSON
	               writeFile  modaAns, handleFile, SIZEOF modaAns
	               writeFile  minResultJSON, handleFile, SIZEOF minResultJSON
	               writeFile  minAns, handleFile, SIZEOF minAns
	               writeFile  maxResultJSON, handleFile, SIZEOF maxResultJSON
	               writeFile  maxAns, handleFile, SIZEOF maxAns
	               writeFile  operationsJSON, handleFile, SIZEOF operationsJSON
                   lengthString parentName, parentNameSize
	               writeFile  parentName, handleFile, parentNameSize
	               writeFile  operations1JSON, handleFile, SIZEOF operations1JSON
	               writeFile  operations2JSON, handleFile, SIZEOF operations2JSON
	               writeFile  endJSON, handleFile, SIZEOF endJSON

	               closeFile  handleFile

ENDM

lengthString MACRO buffer, incBuffer
	             LOCAL      While, endString
	             SetData
	             mov        si, 0 ;limpiamos el contador
	While:       
	             mov        dh, buffer[si] ;almacenamos en dh el caracter de la cadena a obtener la longitud
	             cmp        dh, '$' ;verifica si dh ya tiene el $
	             je         endString ; si lo tiene entonces pues terminamos de iterar el while xd
	             inc        si ;incrementamos en caso de que aun no haya $
	             jmp        While ;vuelve a iterar
	endString:   
	             mov        incBuffer, si ;almacenamos el size del si en incBuffer para indicar la longitud de la cadena
	             RemoveData 

ENDM