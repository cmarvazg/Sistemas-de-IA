# Adaptado de https://machinelearningmastery.com/naive-bayes-classifier-scratch-python/ 
# @Jason Brownlee 
# Hacer predicciones con el algoritmo Naive Bayes y 2 conjuntos de datos: Iris y Jugar Tenis 
from csv import reader
from math import sqrt
from math import exp
from math import pi

# Carga un archivo CSV 
def cargaCSV(nomArch):
	conjDatos = list()
	with open(nomArch, 'r') as archivo:
		lectorCSV = reader(archivo)
		for renglon in lectorCSV:
			if not renglon:
				continue
			conjDatos.append(renglon)
	return conjDatos

# Convierte tipos de columna string a float
def str_columna_a_float(conjDatos, columna):
	for renglon in conjDatos:
		renglon[columna] = float(renglon[columna].strip())

# Convierte tipos de columna string a int
def str_columna_a_int(conjDatos, columna):
	valoresDeClase = [renglon[columna] for renglon in conjDatos]
	unique = set(valoresDeClase)
	lookup = dict()
	for i, valor in enumerate(unique):
		lookup[valor] = i
		print('[%s] => %d' % (valor, i))
	for renglon in conjDatos:
		renglon[columna] = lookup[renglon[columna]]
	return lookup

# Parte el conjunto de datos por valores de clase, regresa un diccionario
def separaPorClase(conjDatos):
	separaciones = dict()
	for i in range(len(conjDatos)):
		vector = conjDatos[i]
		valorClase = vector[-1]
		if (valorClase not in separaciones):
			separaciones[valorClase] = list()
		separaciones[valorClase].append(vector)
	return separaciones

# Calcula el promedio de una lista de numeros 
def mean(numbers):
	return sum(numbers)/float(len(numbers))

# Calcula la  desviacion estandar  de una lista de numeros
def stdev(numbers):
	avg = mean(numbers)
	variance = sum([(x-avg)**2 for x in numbers]) / float(len(numbers)-1)
	return sqrt(variance)

# Calcula el promedio, desviacion estandar, y cuenta cada columna en el conjunto de datos
def sumaConjDatos(conjDatos):
	sumas = [(mean(columna), stdev(columna), len(columna)) for columna in zip(*conjDatos)]
	del(sumas[-1])
	return sumas

# Parte el conjunto de datos por clase y luego crea estadisticas por cada renglon
def sumaPorClase(conjDatos):
	separaciones = separaPorClase(conjDatos)
	sumas = dict()
	for valorClase, renglones in separaciones.items():
		sumas[valorClase] = sumaConjDatos(renglones)
	return sumas

# Calcula la probabilidad segun una funcion de distribucion Gaussiana para x
def calculaProbabilidad(x, mean, stdev):
	exponent = exp(-((x-mean)**2 / (2 * stdev**2 )))
	return (1 / (sqrt(2 * pi) * stdev)) * exponent

# Calcula las probabilidades de predecir cada clase para un renglon dado
def calculaClaseProbabilidades(sumas, renglon):
	totalRenglones = sum([sumas[etiqueta][0][2] for etiqueta in sumas])
	probabilidades = dict()
	for valorClase, sumasClase in sumas.items():
		probabilidades[valorClase] = sumas[valorClase][0][2]/float(totalRenglones)
		for i in range(len(sumasClase)):
			mean, stdev, _ = sumasClase[i]
			probabilidades[valorClase] *= calculaProbabilidad(renglon[i], mean, stdev)
	return probabilidades

# Predict the clase for a given renglon
def predecir(sumas, renglon):
	probabilidades = calculaClaseProbabilidades(sumas, renglon)
	mejorEtq, mejorProb = None, -1
	for valorClase, probabilidad in probabilidades.items():
		if mejorEtq is None or probabilidad > mejorProb:
			mejorProb = probabilidad
			mejorEtq = valorClase
	return mejorEtq


# Hace la prediccion con Naive Bayes en los conjuntos de datos Iris o Jugar Tenis
#
# Codigo de valores de Tennis
# Sunny 1, Overcast 2, Rain 3
# Hot 1, Mild 2, Cool 3
# High 1, Normal 2
# Strong 1, Weak 2
#
opc = int(input('Datos: [1 Iris (Default), 2 Tennis]>>'))
if opc == 2:
    nomArch = 'tennisNumerico.csv'
    conjDatos = cargaCSV(nomArch)
    #renglon = ["Sunny","Hot","High","Strong"] => No
    renglon = [1,1,1,1]
    #renglon = ["Overcast","Hot","High","Weak"] => Si
    #renglon = [2,1,1,2]
else:
    nomArch = 'iris.csv'
    conjDatos = cargaCSV(nomArch)
    renglon = [5.7,2.9,4.2,1.3]


for i in range(len(conjDatos[0])-1):
	str_columna_a_float(conjDatos, i)
# convert clase columna to integers
str_columna_a_int(conjDatos, len(conjDatos[0])-1)
# fit modelo
modelo = sumaPorClase(conjDatos)
# define a new record
#renglon = [5.7,2.9,4.2,1.3]
# predecir the etiqueta
etiqueta = predecir(modelo, renglon)
print('Data=%s, Predicted: %s' % (renglon, etiqueta))
