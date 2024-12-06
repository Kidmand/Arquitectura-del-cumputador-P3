    .text
    .org 0x0000

// ------------------ EJ 3 ------------------- //
// Test de r, (LDUR, STUR, CBZ, ADD, SUB, AND, ORR, BR, ERET y MRS
// Se recomienda modelar el programa principal en un bucle infinito de forma en que
// puedan registrar varias interrupciones externas y que este no contenga la instrucción
// no válida.
// El programa principal (no ISR) debe contener además una instrucción de opcode no
// válido (opcode corrupto o inexistente en nuestra ISA).
// Codigo del programa principal:

main:
    BR X2
    ADD X2, X2, X2
    ADD X2, X2, X2 // X2 debe tener 4
    // X2 no debe tener 8
    

// Como mínimo, se pretende que el código de la ISR identifique que tipo de
// interrupción se trata y lleve la cuenta en dos registros (X29 y X30 por ejemplo) el
// número de interrupciones de cada tipo que se procesaron.
// - En caso de que se procese una instrucción no válida, debe saltarse esa instrucción y
// continuar con el flujo normal del programa (retornar a ELR+4), en el caso de una
// interrupción externa se retorna al flujo normal del programa (usando ERET)
// Codigo de la ISR:






/* .data
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
    LDUR X10, [X29]         // Cargar el contador de interrupciones externas (con desplazamiento 0)
    ADD X10, X10, X1           // Incrementar el contador en 1
    STUR X10, [X29]         // Guardar el nuevo valor en memoria
    ERET                        // Retornar del manejo de interrupción

//------- Manejo de instrucción no válida -------//
InvalidInstruction:
    // Cargar el contador de memoria
    LDUR X11, [X30]         // Cargar el contador de instrucciones no válidas (con desplazamiento 0)
    ADD X11, X11, X1           // Incrementar el contador en 1
    STUR X11, [X30]         // Guardar el nuevo valor en memoria

    // Saltar a la siguiente instrucción (ELR + 4)
    MRS X13, s2_0_c1_c0_0       // X13 = ELR (Exception Link Register)
    ADD X13, X13, X4            // Saltar a la siguiente instrucción (ELR + 4)
    BR X13   
