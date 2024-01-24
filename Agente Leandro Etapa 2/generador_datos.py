import itertools
import random
import csv

# Configuración del grid
GRID_SIZE = 4  # Tamaño del grid (4x4)
NUM_CELLS = GRID_SIZE * GRID_SIZE
OBSTACLES_RATIO = 0.1  # 10% de las celdas
FOOD_RATIO = 0.15  # 15% de las celdas

# Acciones posibles
acciones = ['mover_izquierda', 'mover_derecha', 'mover_arriba', 'mover_abajo', 'comer', 'evadir']

# Estados posibles para una celda, agregando 'agente' como un estado posible
cellda_estados = ['vacío', 'comida', 'obstáculo', 'agente']

# Función para generar el conjunto de entrenamiento
def generar_conjunto_entrenamiento():
    conjunto_datos = []

    # Generar todas las posiciones posibles para el agente
    for agente_pos in range(NUM_CELLS):
        # Generar todas las combinaciones posibles para las celdas del grid
        for grid in itertools.product(cellda_estados, repeat=NUM_CELLS):
            # Inicializar el estado con 'vacío'
            estado = ['vacío' for _ in range(NUM_CELLS)]
            # Colocar el agente en la posición determinada
            estado[agente_pos] = 'agente'
            
            # Llenar el resto del grid con la combinación actual
            iter_grid = iter(grid)
            for i in range(NUM_CELLS):
                if estado[i] == 'agente':
                    continue
                estado[i] = next(iter_grid)
            
            # Validar la cantidad de comida y obstáculos
            comida_count = estado.count('comida')
            obstaculo_count = estado.count('obstáculo')
            
            # Si el estado no cumple con las proporciones de comida y obstáculos, lo saltamos
            if comida_count != round(NUM_CELLS * FOOD_RATIO) or obstaculo_count != round(NUM_CELLS * OBSTACLES_RATIO):
                continue
            
            # Decidir la acción basada en el estado actual
            accion = random.choice(acciones)

            # Añade el estado y la acción al conjunto de datos
            conjunto_datos.append((estado, accion))
    
    return conjunto_datos

# Función principal
def main():
    datos = generar_conjunto_entrenamiento()
    # Abrir un archivo CSV para escribir los datos
    with open('datos_entrenamiento.csv', 'w', newline='') as archivo_csv:
        escritor_csv = csv.writer(archivo_csv)
        # Escribir los nombres de las columnas como la primera fila, si es necesario
        columnas = [f'celda_{i}' for i in range(NUM_CELLS)] + ['acción']
        escritor_csv.writerow(columnas)
        
        # Escribir los datos
        for estado, accion in datos:
            escritor_csv.writerow(estado + [accion])

if __name__ == "__main__":
    main()
