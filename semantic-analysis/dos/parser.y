%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);

#define MAX_ID 100

#define TIPO_INT   0
#define TIPO_FLOAT 1
#define TIPO_CHAR  2

char *tabla[MAX_ID];
int tipos[MAX_ID];
int ntabla = 0;

int tipo_actual;

int yyerror(char *s) {
    printf("Error sintáctico: %s\n", s);
    return 0;
}

void agregar_tipo(char *id, int tipo) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i], id) == 0) {
            printf("Error semántico: variable '%s' ya fue declarada\n", id);
            return;
        }
    }

    tabla[ntabla] = strdup(id);
    tipos[ntabla] = tipo;
    ntabla++;
}

int buscar_tipo(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i], id) == 0) {
            return tipos[i];
        }
    }

    return -1;
}

const char* nombre_tipo(int tipo) {
    switch (tipo) {
        case TIPO_INT:
            return "int";
        case TIPO_FLOAT:
            return "float";
        case TIPO_CHAR:
            return "char";
        default:
            return "desconocido";
    }
}
%}

%union {
    char *str;
    int tipo;
}

%token <str> ID
%token INT FLOAT CHAR
%token IGUAL PUNTOYCOMA

%type <tipo> tipo

%%

programa:
      declaraciones asignaciones
    ;

declaraciones:
      declaracion
    | declaraciones declaracion
    ;

declaracion:
      tipo ID PUNTOYCOMA
      {
          agregar_tipo($2, $1);
      }
    ;

tipo:
      INT
      {
          $$ = TIPO_INT;
      }
    | FLOAT
      {
          $$ = TIPO_FLOAT;
      }
    | CHAR
      {
          $$ = TIPO_CHAR;
      }
    ;

asignaciones:
      asignacion
    | asignaciones asignacion
    ;

asignacion:
      ID IGUAL ID PUNTOYCOMA
      {
          int tipo_izq = buscar_tipo($1);
          int tipo_der = buscar_tipo($3);

          if (tipo_izq == -1) {
              printf("Error semántico: variable '%s' no declarada\n", $1);
          }

          if (tipo_der == -1) {
              printf("Error semántico: variable '%s' no declarada\n", $3);
          }

          if (tipo_izq != -1 && tipo_der != -1 && tipo_izq != tipo_der) {
              printf(
                  "Error semántico: tipos incompatibles en asignación '%s = %s'\n",
                  $1,
                  $3
              );

              printf(
                  "  '%s' es de tipo %s, pero '%s' es de tipo %s\n",
                  $1,
                  nombre_tipo(tipo_izq),
                  $3,
                  nombre_tipo(tipo_der)
              );
          }
      }
    ;

%%

int main() {
    return yyparse();
}


