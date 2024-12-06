// ------------------ EJ 2.A ------------------- //

// Con la menor cantidad de registros e instrucciones, inicializar con el valor de su
// índice las primeras N posiciones de memoria (comenzando en la dirección “0”).
/*
    // Inicialización del contador
    ADD x9, x30, x30    // x9 = 30 + 30 = 60
    ADD x9, x9, x4      // x9 = 60 + 4 = 64
    
    ADD x10, XZR, XZR   // x10 = 0 Variable para la dirección de memoria
    ADD X11, XZR, XZR   // x11 = 0 Variable para el valor a guardar

loop2A:
    STUR x11, [x10]     // Guardar el valor de x11 en la dirección x10
    ADD x10, x10, x8    // Avanzar la dirección en 8 bytes
    ADD x11, x11, x1    // Incrementar el valor de x11
    SUB x9, x9, x1      // Decrementar el contador
    CBZ  x9, end2A      // Revisar si el contador es 0, si es así, terminamos
    CBZ  XZR, loop2A    // Sino volvemos al inicio del bucle

end2A:

// ------------------- FIN -------------------- //

// ------------------ EJ 2.B ------------------- //

// Realizar la sumatoria de las primeras N posiciones de memoria y guardar el
// resultado en la posición N+1.

    // Inicialización
    SUB x10, x10, x10         // Establecer x10 en 0 (base de memoria)
    SUB x13, x13, x13         // Establecer x13 en 0 (acumulador)
    ADD x12, x10, x15         // Establecer x12 en N (número de elementos)

    CBZ x12, end2B            // Si x12 es 0, saltar a End (resultado final)
loop2B:
    LDUR x14, [x10]           // Cargar el valor desde la dirección base en x14
    ADD  x13, x13, x14        // Sumar el valor en x14 al acumulador x13
    ADD  x10, x10, X8         // Avanzar la dirección base en 8 bytes
    SUB  x12, x12, X1         // Decrementar el contador N
    
    CBZ  x12, end2B           // Verificar de nuevo si x12 es 0, si es así, saltar a End
    CBZ  XZR, loop2B          // Volver al inicio del bucle si x12 no es 0 (xzr siempre es 0, así que esto siempre regresa al bucle)

end2B:
    STUR  x13, [x10]          // Almacenar el resultado acumulado en la posición N+1

// ------------------- FIN -------------------- //

// ------------------ EJ 2.C ------------------- //

// Realizar la multiplicación de dos registros: X16 y X17 y
// guardar el resultado en la posición “0” de la memoria.

    SUB X14, X14, X14      // Inicializar X14 (temporal) a 0 (Acumulador para el resultado)
    ADD X15, X17, XZR      // Inicializar X15 (temporal) a X17 (Para llevar el conteo de iteraciones)

    CBZ X15, end2C         // Si X15 es 0, saltar a "end"
loop2C:  
    ADD X14, X14, X16      // Sumar X16 a X14 (Resultado acumulado)
    SUB X15, X15, X1       // Decrementar el contador
    CBZ  x15, end2C        // Verificar de nuevo si x15 es 0, si es así, saltar a End
    CBZ  XZR, loop2C       // Volver al inicio del bucle si x15 no es 0 (xzr siempre es 0, así que esto siempre regresa al bucle)

end2C: 
    STUR x14, [x0]         // Guardar el resultado en la dirección 0 de memoria

// ------------------- FIN -------------------- //

endloop: CBZ XZR, endloop  // Bucle infinito


*/




/* 
.org 0xD8                       // Dirección del vector de excepción
                                // Cargar el registro ESR (Exception Syndrome Register)

ADD X29, XZR, XZR               // Inicializo el contador en 0. Este sería para external interrup.
ADD X30, XZR, XZR               // Inicializo el contador en 0. Este sería para opcode inválido.
MRS X12, s2_0_c2_c0_0           // X12 = ESR (Información sobre la excepción): ESR = EStatus que sale del maindec


//------- Verificar el tipo de excepción -------//

SUB X14, X12, X1                // para un error de interrupción externa EStatus = 0001
CBZ X14, ExternalInterrupt      // Comparar con 0 (Por ejemplo, tipo de interrupción externa)
                                // Si es interrupción externa, saltar a ExternalInterrupt


SUB x13, X12, X2                // para un error de invalid instruction EStatus = 0010
CMP X13, InvalidInstruction     // Comparar con otro tipo de excepción (Instrucción no válida)
                                // Si es instrucción no válida, saltar a InvalidInstruction


//------- Manejo de interrupción externa -------//

ExternalInterrupt:
    ADD X29, X29, X1            // Incrementar el contador
    ERET                        // Retornar del manejo de interrupción


//------- Manejo de instrucción no válida -------//

InvalidInstruction:
    ADD X30, X30, X1            // Incrementar el contador.
                                // Cargar el registro ELR (Exception Link Register)
    MRS X13, s2_0_c1_c0_0       // X13 = ELR (Dirección de la instrucción que causó la excepción).
    ADD X13, X13, X4            // Sumarle 4 al registro X13 que tiene la posición retornada por el registro ELR.
    BR X13                      // Saltar a la posisción X13 = ELR + 4.
*/


.data
contador_interrupt_externa:   .word 0  // Inicializar en 0
contador_instruccion_invalida: .word 0  // Inicializar en 0

.text
.org 0xD8                       // Dirección del vector de excepción
    MRS X12, s2_0_c2_c0_0       // X12 = ESR (Exception Syndrome Register)

//------- Verificar el tipo de excepción -------//

                                // Comprobar si es interrupción externa (ESR == 1)
    SUB X14, X12, X1            // Restar ESR - 1
    CBZ X14, ExternalInterrupt  // Si es igual a 0, saltar a manejo de interrupción externa

                                // Comprobar si es instrucción no válida (ESR == 2)
    SUB X14, X12, X2            // Restar ESR - 2
    CBZ X14, InvalidInstruction // Si es igual a 0, saltar a manejo de instrucción no válida

//------- Manejo de interrupción externa -------//
ExternalInterrupt:
                                // Cargar el contador de memoria
    LDUR X10, [X29]             // Cargar el contador de interrupciones externas (con desplazamiento 0)
    ADD X10, X10, X1            // Incrementar el contador en 1
    STUR X10, [X29]             // Guardar el nuevo valor en memoria
    ERET                        // Retornar del manejo de interrupción

//------- Manejo de instrucción no válida -------//
InvalidInstruction:
                                // Cargar el contador de memoria
    LDUR X11, [X30]             // Cargar el contador de instrucciones no válidas (con desplazamiento 0)
    ADD X11, X11, X1            // Incrementar el contador en 1
    STUR X11, [X30]             // Guardar el nuevo valor en memoria

                                // Saltar a la siguiente instrucción (ELR + 4)
    MRS X13, s2_0_c1_c0_0       // X13 = ELR (Exception Link Register)
    ADD X13, X13, X4            // Saltar a la siguiente instrucción (ELR + 4)
    BR X13   
