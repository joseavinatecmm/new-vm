#include "error_manager.h"

#include <stdio.h>

static int errores = 0;
static int warnings = 0;

void em_init(void) {
    errores = 0;
    warnings = 0;
}

int em_get_errores(void) {
    return errores;
}

int em_get_warnings(void) {
    return warnings;
}

void em_error_sintactico(int linea, const char *lexema, const char *mensaje) {
    errores++;

    printf("\n[SINTÁCTICO]\n");
    printf("  Línea          : %d\n", linea);
    printf("  Cerca de token : %s\n", lexema ? lexema : "EOF");
    printf("  Detalle        : %s\n", mensaje);
    printf("  Sugerencia     : revise la estructura gramatical cercana al token indicado.\n\n");
}

void em_error_variable_no_declarada(int linea, const char *id, int ambito) {
    errores++;

    printf(
        "[SEMÁNTICO]\n"
        "  Línea    : %d\n"
        "  Categoría: Variable no declarada\n"
        "  Detalle  : variable '%s' no declarada en el ámbito %d ni en ámbitos visibles.\n\n",
        linea,
        id,
        ambito
    );
}

void em_error_redeclaracion_variable(int linea, const char *id, int ambito) {
    errores++;

    printf(
        "[SEMÁNTICO]\n"
        "  Línea    : %d\n"
        "  Categoría: Redeclaración de variable\n"
        "  Detalle  : variable '%s' ya existe en el ámbito %d.\n\n",
        linea,
        id,
        ambito
    );
}

void em_error_funcion_no_declarada(int linea, const char *id) {
    errores++;

    printf(
        "[SEMÁNTICO]\n"
        "  Línea    : %d\n"
        "  Categoría: Función no declarada\n"
        "  Detalle  : se llamó a la función '%s', pero no existe declaración previa.\n\n",
        linea,
        id
    );
}

void em_error_funcion_redeclarada(int linea, const char *id) {
    errores++;

    printf(
        "[SEMÁNTICO]\n"
        "  Línea    : %d\n"
        "  Categoría: Redeclaración de función\n"
        "  Detalle  : la función '%s' ya fue declarada globalmente.\n\n",
        linea,
        id
    );
}

void em_error_aridad(int linea, const char *id, int esperados, int recibidos) {
    errores++;

    printf(
        "[SEMÁNTICO]\n"
        "  Línea    : %d\n"
        "  Categoría: Aridad incorrecta\n"
        "  Detalle  : función '%s' esperaba %d argumento(s), pero recibió %d.\n\n",
        linea,
        id,
        esperados,
        recibidos
    );
}

void em_error_macro_duplicada(int linea, const char *id) {
    errores++;

    printf(
        "[SEMÁNTICO]\n"
        "  Línea    : %d\n"
        "  Categoría: Macro duplicada\n"
        "  Detalle  : la macro '%s' ya fue definida previamente.\n\n",
        linea,
        id
    );
}

void em_error_asignacion(int linea, const char *izq, const char *der) {
    errores++;

    printf(
        "[SEMÁNTICO]\n"
        "  Línea    : %d\n"
        "  Categoría: Asignación inválida\n"
        "  Detalle  : la asignación '%s = %s' contiene uno o más identificadores no declarados.\n\n",
        linea,
        izq,
        der
    );
}

void em_error_tabla_llena(int linea) {
    errores++;

    printf(
        "[INTERNO]\n"
        "  Línea   : %d\n"
        "  Detalle : la tabla de símbolos está llena.\n\n",
        linea
    );
}

void em_warning_variable_no_usada(int linea, const char *id) {
    warnings++;

    printf(
        "[WARNING]\n"
        "  Línea    : %d\n"
        "  Categoría: Variable no usada\n"
        "  Detalle  : variable '%s' declarada pero no usada.\n\n",
        linea,
        id
    );
}
