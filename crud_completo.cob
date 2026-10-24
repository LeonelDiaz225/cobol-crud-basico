IDENTIFICATION DIVISION.
       PROGRAM-ID. CRUD-COMPLETO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCHIVO-DATOS ASSIGN TO "datos.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FS.

           SELECT ARCHIVO-TEMP ASSIGN TO "temp.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-DATOS.
       01  REGISTRO-DATO.
           05 REG-ID       PIC 9(4).
           05 REG-RELLENO  PIC X(1).
           05 REG-NOMBRE   PIC X(20).

       FD  ARCHIVO-TEMP.
       01  REGISTRO-TEMP.
           05 TEMP-ID      PIC 9(4).
           05 TEMP-RELLENO PIC X(1).
           05 TEMP-NOMBRE  PIC X(20).

       WORKING-STORAGE SECTION.
       01  WS-FS           PIC XX.
       01  WS-OPCION       PIC 9 VALUE 0.
       01  WS-FIN-ARCHIVO  PIC X(1).
       01  WS-BUSCAR-ID    PIC 9(4).
       01  WS-ENCONTRADO   PIC X(1).
       01  WS-COMANDO      PIC X(50).

       PROCEDURE DIVISION.
       MENU-PRINCIPAL.
           PERFORM UNTIL WS-OPCION = 6
               DISPLAY " "
               DISPLAY "=============================="
               DISPLAY "    CRUD COMPLETO - COBOL     "
               DISPLAY "=============================="
               DISPLAY "1. Agregar registro"
               DISPLAY "2. Listar registros"
               DISPLAY "3. Buscar registro por ID"
               DISPLAY "4. Actualizar registro (Update)"
               DISPLAY "5. Eliminar registro (Delete)"
               DISPLAY "6. Salir"
               DISPLAY "------------------------------"
               DISPLAY "Seleccione una opcion (1-6): "
               ACCEPT WS-OPCION

               EVALUATE WS-OPCION
                   WHEN 1
                       PERFORM AGREGAR-REGISTRO
                   WHEN 2
                       PERFORM LISTAR-REGISTROS
                   WHEN 3
                       PERFORM BUSCAR-REGISTRO
                   WHEN 4
                       PERFORM ACTUALIZAR-REGISTRO
                   WHEN 5
                       PERFORM ELIMINAR-REGISTRO
                   WHEN 6
                       DISPLAY "Saliendo del programa. ¡Adios!"
                   WHEN OTHER
                       DISPLAY "Opcion invalida. Intente de nuevo."
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

       AGREGAR-REGISTRO.
           OPEN EXTEND ARCHIVO-DATOS.
           IF WS-FS = "35"
               OPEN OUTPUT ARCHIVO-DATOS
           END-IF.

           MOVE SPACES TO REGISTRO-DATO.
           DISPLAY " "
           DISPLAY "--- AGREGAR NUEVO REGISTRO ---"
           DISPLAY "Ingrese ID (4 digitos): "
           ACCEPT REG-ID
           DISPLAY "Ingrese Nombre (max 20 chars): "
           ACCEPT REG-NOMBRE
           MOVE " " TO REG-RELLENO
           WRITE REGISTRO-DATO
           CLOSE ARCHIVO-DATOS
           DISPLAY "¡Registro guardado con exito!".

       LISTAR-REGISTROS.
           OPEN INPUT ARCHIVO-DATOS.
           IF WS-FS = "35"
               DISPLAY " "
               DISPLAY "Aun no hay registros guardados."
           ELSE
               DISPLAY " "
               DISPLAY "=== LISTA DE REGISTROS ==="
               DISPLAY "ID   | NOMBRE"
               DISPLAY "------------------------------"
               MOVE "N" TO WS-FIN-ARCHIVO
               READ ARCHIVO-DATOS
                   AT END MOVE "S" TO WS-FIN-ARCHIVO
               END-READ
               PERFORM UNTIL WS-FIN-ARCHIVO = "S"
                   DISPLAY REG-ID " | " REG-NOMBRE
                   READ ARCHIVO-DATOS
                       AT END MOVE "S" TO WS-FIN-ARCHIVO
                   END-READ
               END-PERFORM
               DISPLAY "------------------------------"
               CLOSE ARCHIVO-DATOS
           END-IF.

       BUSCAR-REGISTRO.
           OPEN INPUT ARCHIVO-DATOS.
           IF WS-FS = "35"
               DISPLAY " "
               DISPLAY "Aun no hay registros guardados."
           ELSE
               DISPLAY " "
               DISPLAY "=== BUSCAR REGISTRO ==="
               DISPLAY "Ingrese el ID de 4 digitos a buscar: "
               ACCEPT WS-BUSCAR-ID
               MOVE "N" TO WS-FIN-ARCHIVO
               MOVE "N" TO WS-ENCONTRADO
               READ ARCHIVO-DATOS
                   AT END MOVE "S" TO WS-FIN-ARCHIVO
               END-READ
               PERFORM UNTIL WS-FIN-ARCHIVO = "S"
                   IF REG-ID = WS-BUSCAR-ID
                       DISPLAY "------------------------------"
                       DISPLAY " ¡Registro encontrado!"
                       DISPLAY " ID:     " REG-ID
                       DISPLAY " Nombre: " REG-NOMBRE
                       DISPLAY "------------------------------"
                       MOVE "S" TO WS-ENCONTRADO
                       MOVE "S" TO WS-FIN-ARCHIVO
                   END-IF
                   IF WS-FIN-ARCHIVO NOT = "S"
                       READ ARCHIVO-DATOS
                           AT END MOVE "S" TO WS-FIN-ARCHIVO
                       END-READ
                   END-IF
               END-PERFORM
               IF WS-ENCONTRADO = "N"
                   DISPLAY "No se encontro ningun registro con el ID " WS-BUSCAR-ID
               END-IF
               CLOSE ARCHIVO-DATOS
           END-IF.

       ACTUALIZAR-REGISTRO.
           OPEN INPUT ARCHIVO-DATOS.
           IF WS-FS = "35"
               DISPLAY " "
               DISPLAY "Aun no hay registros guardados."
           ELSE
               DISPLAY " "
               DISPLAY "=== ACTUALIZAR REGISTRO ==="
               DISPLAY "Ingrese el ID del registro a modificar: "
               ACCEPT WS-BUSCAR-ID
               
               OPEN OUTPUT ARCHIVO-TEMP
               MOVE "N" TO WS-FIN-ARCHIVO
               MOVE "N" TO WS-ENCONTRADO

               READ ARCHIVO-DATOS
                   AT END MOVE "S" TO WS-FIN-ARCHIVO
               END-READ

               PERFORM UNTIL WS-FIN-ARCHIVO = "S"
                   IF REG-ID = WS-BUSCAR-ID
                       DISPLAY "Encontrado. ID: " REG-ID " | Actual: " REG-NOMBRE
                       DISPLAY "Ingrese el nuevo nombre (max 20 chars): "
                       ACCEPT REG-NOMBRE
                       MOVE " " TO REG-RELLENO
                       WRITE REGISTRO-TEMP FROM REGISTRO-DATO
                       MOVE "S" TO WS-ENCONTRADO
                   ELSE
                       WRITE REGISTRO-TEMP FROM REGISTRO-DATO
                   END-IF

                   READ ARCHIVO-DATOS
                       AT END MOVE "S" TO WS-FIN-ARCHIVO
                   END-READ
               END-PERFORM

               CLOSE ARCHIVO-DATOS
               CLOSE ARCHIVO-TEMP

               IF WS-ENCONTRADO = "S"
                   MOVE "mv temp.dat datos.dat" TO WS-COMANDO
                   CALL "SYSTEM" USING WS-COMANDO
                   DISPLAY "¡Registro actualizado con exito!"
               ELSE
                   MOVE "rm temp.dat" TO WS-COMANDO
                   CALL "SYSTEM" USING WS-COMANDO
                   DISPLAY "No se encontro ningun registro con el ID " WS-BUSCAR-ID
               END-IF
           END-IF.

       ELIMINAR-REGISTRO.
           OPEN INPUT ARCHIVO-DATOS.
           IF WS-FS = "35"
               DISPLAY " "
               DISPLAY "Aun no hay registros guardados."
           ELSE
               DISPLAY " "
               DISPLAY "=== ELIMINAR REGISTRO ==="
               DISPLAY "Ingrese el ID del registro a eliminar: "
               ACCEPT WS-BUSCAR-ID
               
               OPEN OUTPUT ARCHIVO-TEMP
               MOVE "N" TO WS-FIN-ARCHIVO
               MOVE "N" TO WS-ENCONTRADO

               READ ARCHIVO-DATOS
                   AT END MOVE "S" TO WS-FIN-ARCHIVO
               END-READ

               PERFORM UNTIL WS-FIN-ARCHIVO = "S"
                   IF REG-ID = WS-BUSCAR-ID
                       DISPLAY "Registro con ID " REG-ID " eliminado."
                       MOVE "S" TO WS-ENCONTRADO
                   ELSE
                       WRITE REGISTRO-TEMP FROM REGISTRO-DATO
                   END-IF

                   READ ARCHIVO-DATOS
                       AT END MOVE "S" TO WS-FIN-ARCHIVO
                   END-READ
               END-PERFORM

               CLOSE ARCHIVO-DATOS
               CLOSE ARCHIVO-TEMP

               IF WS-ENCONTRADO = "S"
                   MOVE "mv temp.dat datos.dat" TO WS-COMANDO
                   CALL "SYSTEM" USING WS-COMANDO
                   DISPLAY "¡Operacion completada con exito!"
               ELSE
                   MOVE "rm temp.dat" TO WS-COMANDO
                   CALL "SYSTEM" USING WS-COMANDO
                   DISPLAY "No se encontro ningun registro con el ID " WS-BUSCAR-ID
               END-IF
           END-IF.
