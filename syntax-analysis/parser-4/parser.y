%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern char *yytext;

void yyerror(const char *s);
int yylex(void);
%}

/* Tokens */
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
    if (yyparse() == 0) {
        printf("Análisis sintáctico completado correctamente.\n");
    } else {
        printf("❌ Falló el análisis sintáctico.\n");
    }
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "\n Error sintáctico en la línea %d: %s\n", yylineno, s);
    fprintf(stderr, "   Token problemático: '%s'\n", yytext);

    if (strstr(yytext, "#")) {
        fprintf(stderr, "Posible error: Directiva preprocesador (#include o #define) incompleta o mal formada.\n");
    } else if (strcmp(yytext, "<") == 0) {
        fprintf(stderr, "Posible error: Falta identificador o '>' después del '<' en include.\n");
    } else if (strcmp(yytext, ";") != 0 && strstr(s, "syntax") != NULL) {
        fprintf(stderr, "Posible error: Falta ';' al final de la declaración o 'return'.\n");
    } else if (strcmp(yytext, "") == 0) {
        fprintf(stderr, "Posible error: Fin de archivo inesperado.\n");
    } else {
        fprintf(stderr, "Revisa la estructura del programa, puede haber un token fuera de lugar.\n");
    }
}

