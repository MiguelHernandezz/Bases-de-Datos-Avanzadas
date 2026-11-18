import random
import sys

# Uso: python "Int. Datos.py" [num_registros]   (por defecto 30 millones)
registros = int(sys.argv[1]) if len(sys.argv) > 1 else 30_000_000
nombre_archivo = 'datos_estudiantes.csv'

print(f"Creando {nombre_archivo}...")

try:
    
    with open(nombre_archivo, 'w', encoding='utf-8') as archivo:
        # Cabecera: Consulta1.sql carga el fichero con CSV HEADER
        archivo.write("estudiante_id,nombre,codigo_carrera,edad,indice\n")
        for i in range(1, registros + 1):
            
            estudiante_id = i
            nombre = f"Estudiante_{i}"
            codigo_carrera = random.randint(0, 100)
            edad = random.randint(18, 40)
            indice = random.randint(0, 10000)
            
            archivo.write(f"{estudiante_id},{nombre},{codigo_carrera},{edad},{indice}\n")
            
            if i % 1_000_000 == 0:
                print(f"Progreso: {i // 1_000_000}M / {registros // 1_000_000}M")

    print("Archivo generado con exito")

except Exception as e:
    print(f"Error: {e}")