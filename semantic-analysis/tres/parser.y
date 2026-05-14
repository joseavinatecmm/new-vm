%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);

#define MAX_FUNC 100

char *funciones[MAX_FUNC];
int aridades[MAX_FUNC];
int nfuncs = 0;

int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 0;
}

void registrar_funcion(char *id, int n) {
    funciones[nfuncs] = strdup(id);
    aridades[nfuncs] = n;
    nfuncs++;
}

int obtener_aridad(char *id) {
    for (int i = 0; i < nfuncs; i++) {
        if (strcmp(funciones[i], id) == 0) {
            return aridades[i];
        }
    }
    return -1;
}
%}

%union {
    char *str;
    int num;
}

%token <str> ID
%token FUNC PARIZQ PARDER PUNTOYCOMA COMA

%type <num> lista
%type <num> lista_opt
%type <num> args

%%

programa:
      declaraciones llamadas
    ;

declaraciones:
      declaracion
    | declaraciones declaracion
    ;

declaracion:
      FUNC ID PARIZQ lista_opt PARDER PUNTOYCOMA
      {
          registrar_funcion($2, $4);
      }
    ;

lista_opt:
      lista
      {
          $$ = $1;
      }
    |
      {
          $$ = 0;
      }
    ;

lista:
      ID
      {
          $$ = 1;
      }
    | lista COMA ID
      {
          $$ = $1 + 1;
      }
    ;

llamadas:
      llamada
    | llamadas llamada
    ;

llamada:
      ID PARIZQ args PARDER PUNTOYCOMA
      {
          int n = obtener_aridad($1);

          if (n == -1) {
              printf("Error: la función '%s' no está declarada\n", $1);
          } else if (n != $3) {
              printf("Error: se esperaban %d argumentos en '%s', pero se recibieron %d\n", n, $1, $3);
          }
      }
    ;

args:
      ID
      {
          $$ = 1;
      }
    | args COMA ID
      {
          $$ = $1 + 1;
      }
    |
      {
          $$ = 0;
      }
    ;

%%

int main() {
    return yyparse();
}

