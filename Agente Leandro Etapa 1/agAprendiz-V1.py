# -*- coding: utf-8 -*-  
'''

 Dr Wulfrano Arturo Luna Ramírez
	wluna[at]cua.uam.mx
 Ejemplo de un agente aprendiz (usando el algoritmo Naive Bayes)
'''

import sys
from os import system, name
import traceback 
import pickle
import naiveBayesModelo as tenis

# Preguntar al usuario si desea usar un modelo existente
usar_modelo = input("¿Quieres entrenar un modelo nuevo con datos ya existentes? (s/n): ").strip().lower()
if usar_modelo == 's':
    print(" ")
    print("Entrenando modelo")
    print("")
    import subprocess
    subprocess.call(['python', 'naiveBayesModelo.py'])

def capturaTenisUsuario():
    print(" :) #  Introduce los datos del día de hoy para saber si vamos a jugar tenis ")
    print(" :) #  Usa el siguiente formato <<obligatorio>>")
    print(" :) #    Pronóstico Climático: Soleado 1, Despejado 2, Lluvioso 3")
    print(" :) #    Temperatura: Cálido 1, Templado 2, Frío 3")
    print(" :) #    Humedad: Alta 1, Normal 2")
    print(" :) #    Viento: Fuerte 1, Débil 2")
    print(" :) #  Ejemplo 1: para un día caraterizado como:")
    print(" :) #    Pronóstico Climático: Soleado")
    print(" :) #    Temperatura: Cálido")
    print(" :) #    Humedad: Alta")
    print(" :) #    Viento: Fuerte")
    print(" :) #  Se considera una entrada de datos como sigue:")
    print(" :) #  Con valores nominales:Soleado, Caliente, Alta, Fuerte")
    print(" :) #  Con valores numéricos: 1, 1, 1, 1")
    print(" :) #  Ahora dame tus datos respondiendo a cada pregunta")
    print(" ")
    pronostico  = input("Pronóstico climático?: ")
    temperatura = input("Temperatura?: ")
    humedad     = input("Humedad: ")
    viento      = input("Viento?: ")
    return pronostico,temperatura,humedad,viento
# Hace la prediccion con Naive Bayes en los conjuntos de datos Iris o Jugar Tenis
#
# Codigo de valores de Tennis
# Sunny 1, Overcast 2, Rain 3
# Hot 1, Mild 2, Cool 3
# High 1, Normal 2
# Strong 1, Weak 2
#
    return (origen,destino)
# Funcion principal
def main():
    try:
        print("###############################################################################")
        print(" #                                                                           #")
        print(" # Hola soy el agente aprendiz LEANDRO  :-)                                  #")
        print(" #  Se decidir cuándo ir a jugar tenis.                                      #")
        print(" # Mi función de decisión fue desarrollada con el algoritmo                  #")
        print(" # Naive Bayes, un método sencillo pero efectivo                             #")
        print(" # para la clasificación y la toma de decisiones.                            #")
        print(" ##############################################################################")
        print(" # Naive Bayes es un algoritmo de clasificación probabilística.              #")
        print(" # Se basa en el Teorema de Bayes:                                           #")
        print(" #               P(C|X) = P(X|C)P(C)/P(X)                                    #")
        print(" # en la suposición de independencia entre las variables para                #")
        print(" # calcular la probabilidad de cada clase.                                   #")
        print(" #                                                                           #")
        print("###############################################################################")
        # Cargar el modelo entrenado desde el archivo
        with open('modelo_entrenado.pkl', 'rb') as modelo_archivo:
            modelo = pickle.load(modelo_archivo)
        p, t, h, v = capturaTenisUsuario()
        renglon = [int(p), int(t), int(h), int(v)]
        print("")
        print(" :) #  Haciendo predicción con el modelo entrenado")
        print("")
        print("El modelo utilizado fue:", modelo.__class__.__name__)  # Imprimir el nombre de la clase del modelo
        print("")
        print("Contenido del modelo:", modelo)
        print("")
        etiqueta = tenis.predecir(modelo, renglon)
        # Salida más descriptiva
        if etiqueta == 1:
            print('Leandro dice: Sí, es un buen día para jugar tenis.')
        elif etiqueta == 0:
            print('Leandro dice: No, mejor no salgas a jugar tenis hoy.')
    except Exception:
        traceback.print_exc(file=sys.stdout)
    sys.exit(0)
if __name__ == '__main__':
    main()