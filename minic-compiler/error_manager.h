#ifndef ERROR_MANAGER_H
#define ERROR_MANAGER_H

void em_init(void);

void em_error_sintactico(int linea, const char *lexema, const char *mensaje);

void em_error_variable_no_declarada(int linea, const char *id, int ambito);
void em_error_redeclaracion_variable(int linea, const char *id, int ambito);
void em_error_funcion_no_declarada(int linea, const char *id);
void em_error_funcion_redeclarada(int linea, const char *id);
void em_error_aridad(int linea, const char *id, int esperados, int recibidos);
void em_error_macro_duplicada(int linea, const char *id);
void em_error_asignacion(int linea, const char *izq, const char *der);
void em_error_tabla_llena(int linea);

void em_warning_variable_no_usada(int linea, const char *id);

int em_get_errores(void);
int em_get_warnings(void);

#endif
