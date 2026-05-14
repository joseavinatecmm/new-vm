%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);

extern FILE *yyin;

#define MAX_SIMB 300
#define TIPO_VAR 0
#define TIPO_FUNC 1
#define TIPO_MACRO 2
#define TIPO_INT 0

typedef struct {
    char *nombre;
    int clase;
    int tipo_dato;
    int aridad;
    int ambito;
    int activo;
} Simbolo;

Simbolo tabla[MAX_SIMB];

int ntabla = 0;
int ambito_actual = 0;
int semantic_errors = 0;

int yyerror(char *s) {
    printf("Error sintáctico: %s\n", s);
    return 0;
}

void entrar_ambito() {
    ambito_actual++;
}

void salir_ambito() {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].ambito == ambito_actual) {
            tabla[i].activo = 0;
        }
    }
    ambito_actual--;
}

int existe_en_ambito_actual(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].activo &&
            tabla[i].ambito == ambito_actual &&
            strcmp(tabla[i].nombre, id) == 0) {
            return 1;
        }
    }
    return 0;
}

int existe_global(char *id, int clase) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].activo &&
            tabla[i].ambito == 0 &&
            tabla[i].clase == clase &&
            strcmp(tabla[i].nombre, id) == 0) {
            return 1;
        }
    }
    return 0;
}

void agregar_variable(char *id, int tipo_dato) {
    if (existe_en_ambito_actual(id)) {
        printf("Error semántico: redeclaración de variable '%s'\n", id);
        semantic_errors++;
        return;
    }

    tabla[ntabla++] = (Simbolo){strdup(id), TIPO_VAR, tipo_dato, 0, ambito_actual, 1};
}

void agregar_macro(char *id) {
    if (existe_global(id, TIPO_MACRO)) {
        printf("Error semántico: macro '%s' ya definida\n", id);
        semantic_errors++;
        return;
    }

    tabla[ntabla++] = (Simbolo){strdup(id), TIPO_MACRO, TIPO_INT, 0, 0, 1};
}

void agregar_funcion(char *id, int aridad) {
    if (existe_global(id, TIPO_FUNC)) {
        printf("Error semántico: función '%s' ya declarada\n", id);
        semantic_errors++;
        return;
    }

    tabla[ntabla++] = (Simbolo){strdup(id), TIPO_FUNC, TIPO_INT, aridad, 0, 1};
}

int buscar_tipo_variable(char *id) {
    for (int a = ambito_actual; a >= 0; a--) {
        for (int i = ntabla - 1; i >= 0; i--) {
            if (tabla[i].activo &&
                tabla[i].clase == TIPO_VAR &&
                tabla[i].ambito == a &&
                strcmp(tabla[i].nombre, id) == 0) {
                return tabla[i].tipo_dato;
            }
        }
    }
    return -1;
}

int buscar_aridad_funcion(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].activo &&
            tabla[i].clase == TIPO_FUNC &&
            strcmp(tabla[i].nombre, id) == 0) {
            return tabla[i].aridad;
        }
    }
    return -1;
}

void verificar_asignacion(char *izq, char *der) {
    int tipo_izq = buscar_tipo_variable(izq);
    int tipo_der = buscar_tipo_variable(der);

    if (tipo_izq == -1) {
        printf("Error semántico: variable '%s' no declarada\n", izq);
        semantic_errors++;
    }

    if (tipo_der == -1) {
        printf("Error semántico: variable '%s' no declarada\n", der);
        semantic_errors++;
    }

    if (tipo_izq != -1 && tipo_der != -1 && tipo_izq != tipo_der) {
        printf("Error semántico: tipos incompatibles en asignación '%s = %s'\n", izq, der);
        semantic_errors++;
    }
}

void verificar_uso_variable(char *id) {
    if (buscar_tipo_variable(id) == -1) {
        printf("Error semántico: variable '%s' no declarada\n", id);
        semantic_errors++;
    }
}

void verificar_llamada_funcion(char *id, int argumentos) {
    int esperados = buscar_aridad_funcion(id);

    if (esperados == -1) {
        printf("Error semántico: función '%s' no declarada\n", id);
        semantic_errors++;
        return;
    }

    if (esperados != argumentos) {
        printf("Error semántico: función '%s' espera %d argumento(s), pero recibió %d\n",
               id, esperados, argumentos);
        semantic_errors++;
    }
}
%}

%union {
    char *str;
    int num;
}

%token <str> ID
%token <str> STRING_LITERAL
%token <str> NUMBER

%token INCLUDE DEFINE
%token INT FUNC RETURN IGUAL
%token PARIZQ PARDER LLAVEIZQ LLAVEDER PUNTOYCOMA COMA
%token MENOR MAYOR PUNTO

%type <num> parametros
%type <num> lista_param
%type <num> argumentos
%type <num> lista_args

%%

programa:
      preprocesador declaraciones
      {
          if (semantic_errors == 0) {
              printf("Análisis completado sin errores semánticos.\n");
          } else {
              printf("Análisis completado con %d error(es) semántico(s).\n", semantic_errors);
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
          agregar_macro($2);
      }
    | DEFINE ID ID
      {
          agregar_macro($2);
      }
    | DEFINE ID STRING_LITERAL
      {
          agregar_macro($2);
      }
    | DEFINE ID
      {
          agregar_macro($2);
      }
    ;

declaraciones:
      declaracion
    | declaraciones declaracion
    ;

declaracion:
      INT ID PUNTOYCOMA
      {
          agregar_variable($2, TIPO_INT);
      }
    | FUNC ID PARIZQ
      {
          agregar_funcion($2, -1);
          entrar_ambito();
      }
      parametros PARDER bloque_funcion
      {
          int aridad = $5;

          for (int i = 0; i < ntabla; i++) {
              if (tabla[i].activo &&
                  tabla[i].clase == TIPO_FUNC &&
                  strcmp(tabla[i].nombre, $2) == 0) {
                  tabla[i].aridad = aridad;
                  break;
              }
          }

          salir_ambito();
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
      ID
      {
          agregar_variable($1, TIPO_INT);
          $$ = 1;
      }
    | lista_param COMA ID
      {
          agregar_variable($3, TIPO_INT);
          $$ = $1 + 1;
      }
    ;

bloque_funcion:
      LLAVEIZQ instrucciones LLAVEDER
    ;

bloque:
      LLAVEIZQ
      {
          entrar_ambito();
      }
      instrucciones LLAVEDER
      {
          salir_ambito();
      }
    ;

instrucciones:
      instrucciones instruccion
    |
    ;

instruccion:
      INT ID PUNTOYCOMA
      {
          agregar_variable($2, TIPO_INT);
      }
    | ID IGUAL ID PUNTOYCOMA
      {
          verificar_asignacion($1, $3);
      }
    | ID PARIZQ argumentos PARDER PUNTOYCOMA
      {
          verificar_llamada_funcion($1, $3);
      }
    | RETURN ID PUNTOYCOMA
      {
          verificar_uso_variable($2);
      }
    | bloque
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
      ID
      {
          verificar_uso_variable($1);
          $$ = 1;
      }
    | lista_args COMA ID
      {
          verificar_uso_variable($3);
          $$ = $1 + 1;
      }
    ;

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Uso: %s archivo_fuente\n", argv[0]);
        return EXIT_FAILURE;
    }

    yyin = fopen(argv[1], "r");

    if (!yyin) {
        printf("Error: no se pudo abrir el archivo '%s'\n", argv[1]);
        return EXIT_FAILURE;
    }

    yyparse();

    fclose(yyin);

    return semantic_errors == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}

