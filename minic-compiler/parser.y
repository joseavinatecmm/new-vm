%error-verbose

%{
#include <stdio.h>
#include <stdlib.h>

#include "symbol_table.h"
#include "error_manager.h"
#include "code_generator.h"

int yylex(void);
int yyerror(char *s);

extern FILE *yyin;
extern int yylineno;
extern char *yytext;
%}

%union {
    char *str;
    int num;
}

%token <str> ID
%token <str> STRING_LITERAL
%token <str> NUMBER

%token INCLUDE DEFINE
%token INT RETURN IF PRINTF IGUAL

%token PARIZQ PARDER
%token LLAVEIZQ LLAVEDER

%token PUNTOYCOMA COMA

%token MENOR MAYOR PUNTO

%left MAS MENOS
%left POR DIV

%type <num> parametros
%type <num> lista_param
%type <num> argumentos
%type <num> lista_args

%%

programa:
      preprocesador declaraciones
      {
          if (em_get_errores() == 0) {
              printf("\nAnálisis léxico, sintáctico y semántico completado sin errores.\n");
          } else {
              printf("\nAnálisis finalizado con %d error(es).\n", em_get_errores());
          }
      }
    ;

preprocesador:
      preprocesador directiva
    |
    ;

directiva:
      include
    | define
    ;

include:
      INCLUDE MENOR ID MAYOR
    | INCLUDE MENOR ID PUNTO ID MAYOR
    | INCLUDE STRING_LITERAL
    ;

define:
      DEFINE ID NUMBER
      {
          st_agregar_macro($2, yylineno);
      }
    | DEFINE ID STRING_LITERAL
      {
          st_agregar_macro($2, yylineno);
      }
    ;

declaraciones:
      declaraciones declaracion
    | declaracion
    ;

declaracion:
      declaracion_variable_global
    | declaracion_funcion
    ;

declaracion_variable_global:
      INT ID PUNTOYCOMA
      {
          st_agregar_variable($2, TIPO_INT, yylineno);
      }
    | INT ID error
      {
          em_error_sintactico(
              yylineno,
              yytext,
              "falta ';' después de declaración global"
          );

          yyerrok;
      }
    ;

declaracion_funcion:
      INT ID PARIZQ
      {
          st_agregar_funcion($2, -1, yylineno);
          st_entrar_ambito();
      }
      parametros PARDER bloque_funcion
      {
          st_actualizar_aridad_funcion($2, $5);
          st_salir_ambito();
      }
    ;

parametros:
      {
          $$ = 0;
      }
    | lista_param
      {
          $$ = $1;
      }
    ;

lista_param:
      INT ID
      {
          st_agregar_variable($2, TIPO_INT, yylineno);
          $$ = 1;
      }
    | lista_param COMA INT ID
      {
          st_agregar_variable($4, TIPO_INT, yylineno);
          $$ = $1 + 1;
      }
    ;

bloque_funcion:
      LLAVEIZQ instrucciones LLAVEDER
    | LLAVEIZQ instrucciones error
      {
          em_error_sintactico(
              yylineno,
              yytext,
              "falta '}' al final del bloque de función"
          );

          yyerrok;
      }
    ;

bloque:
      LLAVEIZQ
      {
          st_entrar_ambito();
      }
      instrucciones LLAVEDER
      {
          st_salir_ambito();
      }
    ;

instrucciones:
      instrucciones instruccion
    |
    ;

instruccion:
      INT ID PUNTOYCOMA
      {
          st_agregar_variable($2, TIPO_INT, yylineno);
      }

    | INT ID error
      {
          em_error_sintactico(
              yylineno,
              yytext,
              "falta ';' después de declaración local"
          );

          yyerrok;
      }

    | ID IGUAL expresion PUNTOYCOMA
      {
          st_verificar_uso_variable($1, yylineno);
      }

    | ID IGUAL expresion error
      {
          em_error_sintactico(
              yylineno,
              yytext,
              "falta ';' al final de asignación"
          );

          yyerrok;
      }

    | ID PARIZQ argumentos PARDER PUNTOYCOMA
      {
          st_verificar_llamada_funcion($1, $3, yylineno);
      }

    | PRINTF PARIZQ STRING_LITERAL PARDER PUNTOYCOMA

    | PRINTF PARIZQ STRING_LITERAL COMA argumentos PARDER PUNTOYCOMA

    | RETURN expresion PUNTOYCOMA

    | RETURN expresion error
      {
          em_error_sintactico(
              yylineno,
              yytext,
              "falta ';' después de return"
          );

          yyerrok;
      }

    | IF PARIZQ ID PARDER bloque
      {
          st_verificar_uso_variable($3, yylineno);
      }

    | bloque
    ;

expresion:
      ID
      {
          st_verificar_uso_variable($1, yylineno);
      }

    | NUMBER

    | expresion MAS expresion
    | expresion MENOS expresion
    | expresion POR expresion
    | expresion DIV expresion

    | PARIZQ expresion PARDER
    ;

argumentos:
      {
          $$ = 0;
      }

    | lista_args
      {
          $$ = $1;
      }
    ;

lista_args:
      expresion
      {
          $$ = 1;
      }

    | lista_args COMA expresion
      {
          $$ = $1 + 1;
      }
    ;

%%

int yyerror(char *s) {
    em_error_sintactico(yylineno, yytext, s);
    return 0;
}

int main(int argc, char *argv[]) {
    st_init();
    em_init();

    if (argc != 2) {
        printf("Uso: %s archivo_fuente.c\n", argv[0]);
        return EXIT_FAILURE;
    }

    yyin = fopen(argv[1], "r");

    if (!yyin) {
        printf("Error: no se pudo abrir '%s'\n", argv[1]);
        return EXIT_FAILURE;
    }

    yyparse();

    fclose(yyin);

    st_reportar_variables_no_usadas();

    st_imprimir_tabla();

    if (em_get_errores() == 0) {
        printf("\nNo se detectaron errores. Iniciando generación de código.\n");

        generar_ensamblador(argv[1], "assembly.s");
        imprimir_ensamblador("assembly.s");
        generar_objeto("assembly.s", "obj_code.o");
        generar_ejecutable("obj_code.o", "program-exec");
        ejecutar_programa("program-exec");

    } else {
        printf("\nNo se genera código debido a errores detectados.\n");
    }

    printf(
        "\nResumen: %d error(es), %d warning(s).\n",
        em_get_errores(),
        em_get_warnings()
    );

    return em_get_errores() == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}
