import csv
import pickle
from sklearn.naive_bayes import GaussianNB
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score

# Función para cargar datos desde un archivo CSV
def cargar_datos(csv_filename):
    with open(csv_filename, 'r') as archivo:
        lector_csv = csv.reader(archivo)
        dataset = list(lector_csv)
    return dataset

# Función para convertir los datos a números ya que Naive Bayes requiere datos numéricos
def preparar_datos(dataset):
    # Transformamos las columnas de características a valores numéricos
    le = LabelEncoder()
    for i in range(len(dataset[0]) - 1):
        column = [row[i] for row in dataset]
        le.fit(column)
        encoded_column = le.transform(column)
        for row in dataset:
            row[i] = encoded_column[dataset.index(row)]
    return dataset

# Función para entrenar el modelo Naive Bayes
def entrenar_modelo_naive_bayes(X, y):
    modelo = GaussianNB()
    modelo.fit(X, y)
    return modelo

# Función para guardar el modelo entrenado
def guardar_modelo(modelo, filename):
    with open(filename, 'wb') as archivo:
        pickle.dump(modelo, archivo)

# Función principal
def main():
    # Cargar datos
    datos = cargar_datos('datos_entrenamiento.csv')
    datos = preparar_datos(datos)

    # Separar en características y etiquetas
    X = [fila[:-1] for fila in datos]  
    y = [fila[-1] for fila in datos]   

    # Dividir los datos en entrenamiento y prueba
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Entrenar el modelo
    modelo = entrenar_modelo_naive_bayes(X_train, y_train)

    # Guardar el modelo
    guardar_modelo(modelo, 'modelo_entrenado.pkl')

    # Evaluar el modelo si es necesario
    y_pred = modelo.predict(X_test)
    print(f'Exactitud del modelo: {accuracy_score(y_test, y_pred)}')

if __name__ == '__main__':
    main()
