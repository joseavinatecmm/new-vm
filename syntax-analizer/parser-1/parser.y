%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);
%}

// Tokes
%token INCLUDE INT RETURN ID NUMBER

%%
program:
      includes declarations returns
    ;

includes:
      INCLUDE ID
    | /* vacío */
    ;

declarations:
      INT ID ';'
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

