#include "symbol_table.h"
#include "error_manager.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *nombre;
    int clase;
    int tipo_dato;
    int aridad;
    int ambito;
    int activo;
    int linea;
    int usado;
} Simbolo;

static Simbolo tabla[MAX_SIMB];

static int ntabla = 0;
static int ambito_actual = 0;

void st_init(void) {
    ntabla = 0;
    ambito_actual = 0;
}

void st_entrar_ambito(void) {
    ambito_actual++;
}

void st_salir_ambito(void) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].ambito == ambito_actual) {
            tabla[i].activo = 0;
        }
    }

    ambito_actual--;
}

static int existe_en_ambito_actual(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].activo &&
            tabla[i].ambito == ambito_actual &&
            strcmp(tabla[i].nombre, id) == 0) {
            return 1;
        }
    }

    return 0;
}

static void insertar(char *id,
                     int clase,
                     int tipo,
                     int aridad,
                     int ambito,
                     int linea) {
    if (ntabla >= MAX_SIMB) {
        em_error_tabla_llena(linea);
        return;
    }

    tabla[ntabla].nombre = strdup(id);
    tabla[ntabla].clase = clase;
    tabla[ntabla].tipo_dato = tipo;
    tabla[ntabla].aridad = aridad;
    tabla[ntabla].ambito = ambito;
    tabla[ntabla].activo = 1;
    tabla[ntabla].linea = linea;
    tabla[ntabla].usado = 0;

    ntabla++;
}

void st_agregar_variable(char *id, int tipo, int linea) {
    if (existe_en_ambito_actual(id)) {
        em_error_redeclaracion_variable(linea, id, ambito_actual);
        return;
    }

    insertar(id, CLASE_VAR, tipo, 0, ambito_actual, linea);
}

void st_agregar_funcion(char *id, int aridad, int linea) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].clase == CLASE_FUNC &&
            strcmp(tabla[i].nombre, id) == 0) {
            em_error_funcion_redeclarada(linea, id);
            return;
        }
    }

    insertar(id, CLASE_FUNC, TIPO_INT, aridad, 0, linea);
}

void st_actualizar_aridad_funcion(char *id, int aridad) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].clase == CLASE_FUNC &&
            strcmp(tabla[i].nombre, id) == 0) {
            tabla[i].aridad = aridad;
            return;
        }
    }
}

void st_agregar_macro(char *id, int linea) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].clase == CLASE_MACRO &&
            strcmp(tabla[i].nombre, id) == 0) {
            em_error_macro_duplicada(linea, id);
            return;
        }
    }

    insertar(id, CLASE_MACRO, TIPO_INT, 0, 0, linea);
}

static int buscar_variable(char *id) {
    for (int amb = ambito_actual; amb >= 0; amb--) {
        for (int i = ntabla - 1; i >= 0; i--) {
            if (tabla[i].activo &&
                tabla[i].clase == CLASE_VAR &&
                tabla[i].ambito == amb &&
                strcmp(tabla[i].nombre, id) == 0) {
                return i;
            }
        }
    }

    return -1;
}

void st_verificar_uso_variable(char *id, int linea) {
    int idx = buscar_variable(id);

    if (idx == -1) {
        em_error_variable_no_declarada(linea, id, ambito_actual);
        return;
    }

    tabla[idx].usado = 1;
}

void st_verificar_asignacion(char *izq, char *der, int linea) {
    int existe_izq = buscar_variable(izq);
    int existe_der = buscar_variable(der);

    if (existe_izq == -1 || existe_der == -1) {
        em_error_asignacion(linea, izq, der);

        if (existe_izq == -1) {
            em_error_variable_no_declarada(linea, izq, ambito_actual);
        }

        if (existe_der == -1) {
            em_error_variable_no_declarada(linea, der, ambito_actual);
        }

        return;
    }

    tabla[existe_izq].usado = 1;
    tabla[existe_der].usado = 1;
}

static int buscar_aridad(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].clase == CLASE_FUNC &&
            strcmp(tabla[i].nombre, id) == 0) {
            return tabla[i].aridad;
        }
    }

    return -1;
}

void st_verificar_llamada_funcion(char *id, int argumentos, int linea) {
    int aridad = buscar_aridad(id);

    if (aridad == -1) {
        em_error_funcion_no_declarada(linea, id);
        return;
    }

    if (aridad != argumentos) {
        em_error_aridad(linea, id, aridad, argumentos);
    }
}

void st_reportar_variables_no_usadas(void) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].clase == CLASE_VAR && tabla[i].usado == 0) {
            em_warning_variable_no_usada(tabla[i].linea, tabla[i].nombre);
        }
    }
}

void st_imprimir_tabla(void) {
    printf("\nTABLA DE SÍMBOLOS\n");
    printf("--------------------------------------------------------------------------------\n");
    printf("%-15s %-10s %-8s %-8s %-8s %-8s\n",
           "Nombre",
           "Clase",
           "Ámbito",
           "Activo",
           "Aridad",
           "Usado");
    printf("--------------------------------------------------------------------------------\n");

    for (int i = 0; i < ntabla; i++) {
        char *clase = "variable";

        if (tabla[i].clase == CLASE_FUNC) {
            clase = "funcion";
        }

        if (tabla[i].clase == CLASE_MACRO) {
            clase = "macro";
        }

        printf("%-15s %-10s %-8d %-8d %-8d %-8d\n",
               tabla[i].nombre,
               clase,
               tabla[i].ambito,
               tabla[i].activo,
               tabla[i].aridad,
               tabla[i].usado);
    }

    printf("--------------------------------------------------------------------------------\n");
}
