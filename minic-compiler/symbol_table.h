#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_SIMB 500

#define CLASE_VAR   0
#define CLASE_FUNC  1
#define CLASE_MACRO 2

#define TIPO_INT 0

void st_init(void);

void st_entrar_ambito(void);
void st_salir_ambito(void);

void st_agregar_variable(char *id, int tipo, int linea);
void st_agregar_funcion(char *id, int aridad, int linea);
void st_actualizar_aridad_funcion(char *id, int aridad);
void st_agregar_macro(char *id, int linea);

void st_verificar_uso_variable(char *id, int linea);
void st_verificar_asignacion(char *izq, char *der, int linea);
void st_verificar_llamada_funcion(char *id, int argumentos, int linea);

void st_reportar_variables_no_usadas(void);
void st_imprimir_tabla(void);

#endif
