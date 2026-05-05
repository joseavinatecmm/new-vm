%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int curr_lineno;
extern char *yytext;

void yyerror(const char *s);
int yylex(void);
%}

%union {
    char *str;
    double fval;
}

%token INCLUDE DEFINE INT RETURN ID NUMBER
%token LT GT
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
    if (yyparse() == 0)
        printf("Análisis sintáctico completado correctamente.\n");
    else
        printf("Falló el análisis sintáctico.\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "\n Error sintáctico en la línea %d: %s\n", curr_lineno, s);
    fprintf(stderr, "   Token problemático: '%s'\n", yytext);
}

