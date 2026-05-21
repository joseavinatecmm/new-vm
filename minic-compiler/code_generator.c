#include "code_generator.h"

#include <stdio.h>
#include <stdlib.h>

int generar_ensamblador(const char *archivo_c, const char *archivo_s) {
    char comando[512];

    snprintf(comando, sizeof(comando), "gcc -S %s -o %s", archivo_c, archivo_s);

    printf("\n[1] Generando ensamblador:\n%s\n", comando);

    return system(comando);
}

int imprimir_ensamblador(const char *archivo_s) {
    char comando[512];

    snprintf(comando, sizeof(comando), "cat %s", archivo_s);

    printf("\n[2] Código ensamblador generado:\n\n");

    return system(comando);
}

int generar_objeto(const char *archivo_s, const char *archivo_o) {
    char comando[512];

    snprintf(comando, sizeof(comando), "gcc -c %s -o %s", archivo_s, archivo_o);

    printf("\n[3] Generando objeto:\n%s\n", comando);

    return system(comando);
}

int generar_ejecutable(const char *archivo_o, const char *ejecutable) {
    char comando[512];

    snprintf(comando, sizeof(comando), "gcc %s -o %s", archivo_o, ejecutable);

    printf("\n[4] Generando ejecutable:\n%s\n", comando);

    return system(comando);
}

int ejecutar_programa(const char *ejecutable) {
    char comando[512];

    snprintf(comando, sizeof(comando), "./%s", ejecutable);

    printf("\n[5] Ejecutando programa:\n%s\n\n", comando);

    return system(comando);
}
