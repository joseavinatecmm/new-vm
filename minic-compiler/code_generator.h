#ifndef CODE_GENERATOR_H
#define CODE_GENERATOR_H

int generar_ensamblador(const char *archivo_c, const char *archivo_s);
int imprimir_ensamblador(const char *archivo_s);
int generar_objeto(const char *archivo_s, const char *archivo_o);
int generar_ejecutable(const char *archivo_o, const char *ejecutable);
int ejecutar_programa(const char *ejecutable);

#endif
