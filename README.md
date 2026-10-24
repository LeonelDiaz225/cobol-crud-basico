# CRUD Básico en COBOL 

Este proyecto es una aplicación de terminal desarrollada enteramente en COBOL que implementa un sistema CRUD (Create, Read, Update, Delete) utilizando archivos de organización secuencial (`LINE SEQUENTIAL`). 

Fue desarrollado y probado en un entorno Ubuntu (WSL) utilizando GnuCOBOL.

## Características
El programa presenta un menú interactivo con las siguientes funciones:
1. **Agregar registro:** Permite ingresar un ID (numérico de 4 dígitos) y un Nombre (hasta 20 caracteres).
2. **Listar registros:** Lee secuencialmente el archivo y muestra todos los registros tabulados.
3. **Buscar registro por ID:** Recorre el archivo comparando el ID ingresado para mostrar un registro específico.
4. **Actualizar registro (Update):** Utiliza un archivo temporal para reescribir los datos, reemplazando la información del ID seleccionado.
5. **Eliminar registro (Delete):** Reescribe el archivo original en uno temporal omitiendo el ID seleccionado, para luego reemplazar el archivo físico.

## Tecnologías y Conceptos Aplicados
* **Lenguaje:** COBOL (GnuCOBOL)
* **Persistencia:** Archivos físicos `LINE SEQUENTIAL`.
* **Estructuras de Control:** `PERFORM UNTIL`, `EVALUATE`, condicionales `IF`.
* **Manejo de Errores:** Uso de `FILE STATUS` (ej. capturando el error 35 para crear el archivo dinámicamente si no existe).
* **Llamadas al Sistema:** Uso de `CALL "SYSTEM"` para ejecutar comandos de Linux (`mv` y `rm`) durante los procesos de actualización y eliminación.

## Estructura del Proyecto
* `crud_completo.cob`: Contiene el código fuente final y unificado con el menú interactivo.
* `datos.dat`: (Generado automáticamente) Archivo físico donde se persisten los registros.
* `temp.dat`: (Generado temporalmente) Archivo auxiliar utilizado para las operaciones de Update y Delete.

## Instrucciones de Ejecución

### Prerrequisitos
Debes tener instalado GnuCOBOL en tu sistema Linux/WSL:

```bash
sudo apt-get install open-cobol
```

### Compilación
Para compilar el código fuente y generar el ejecutable, corre el siguiente comando en la terminal:

```bash
cobc -x -o crud_app crud_completo.cob
```

### Ejecución
Una vez compilado, inicia la aplicación con:

```bash
./crud_app
```
