# -*- coding: utf-8 -*-

import os
import re
import sys


# Cambia el formato de la imagen origen en PGN y crea la imagen destino en ASC
def convierteArch(origen,destino):
	rel=''
	line=''
	palabras = open(origen, 'r').readlines()
	f=open(destino,"w")
	lin = 0
	col = 0
	#maxlin = 897
	#maxcol = 1192
	maxlin = 600
	maxcol = 800
	print("Trabajando con "+origen+"\n")
	#f.write("NCOLS 890"+'\n')
	#f.write("NROWS 515"+'\n')
	f.write("NCOLS "+str(maxcol)+'\n')
	f.write("NROWS "+str(maxlin)+'\n')
	#f.write("NCOLS 1524"+'\n')
	#f.write("NROWS 832"+'\n')
	f.write("XLLCORNER 0"+'\n')
	f.write("YLLCORNER 0"+'\n')
	f.write("CELLSIZE 1"+'\n')
	f.write("NODATA_VALUE -1"+'\n')
	for cWord in palabras:
		cWord = cWord.strip()
		if(lin > 3):
			if(col < maxcol):
				line=line + cWord + ' ' 
			else:
				line=line + cWord + '\n'
				f.write(line)
				line = ''
				col = 0
			col = col + 1
		else:
			lin = lin + 1
	f.close()
	return 0


# ----- main ----- #
if __name__ == "__main__":
	#convierteArch("imagenEntrada.pgm","imagenSalida.asc")
	imgE = sys.argv[1]
	arc = imgE.split(".")
	imgS = str(arc[0])+".asc"
	print("Convirtiendo imagen ",imgE," a formato PGM ",imgS)
	convierteArch(imgE,imgS)

