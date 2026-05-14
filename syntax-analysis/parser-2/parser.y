%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

/* Declaración de tokens */
%token INCLUDE DEFINE INT RETURN ID NUMBER
%token LT GT

%union {
    char *str;
    double fval;
}

%type <str> ID
%type <fval> NUMBER

%%
program:
      includes macros declarations returns
    ;

includes:
      INCLUDE LT ID GT includes
    | /* vacío */
    ;

macros:
      DEFINE ID NUMBER macros
    | /* vacío */
    ;

declarations:
      INT ID ';' declarations
    | /* vacío */
    ;

returns:
      RETURN ID ';'
    ;

%%

int main() {
    printf("Iniciando análisis sintáctico...\n");
    yyparse();
    printf("Análisis sintáctico concluido.\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
}

