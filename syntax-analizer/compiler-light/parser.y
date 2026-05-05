%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
extern char *yytext;

int yylex(void);
void yyerror(const char *s);

static int syntax_errors = 0;

static void report_context_error(const char *context) {
    syntax_errors++;
    printf("\n[ERROR SINTÁCTICO]\n");
    printf("  Línea aproximada : %d\n", yylineno);
    printf("  Cerca de lexema  : '%s'\n", yytext);
    printf("  Contexto         : %s\n\n", context);
}
%}

%error-verbose

%token INCLUDE DEFINE
%token INT FLOAT CHAR DOUBLE VOID
%token RETURN IF ELSE WHILE
%token MAIN
%token ID NUMBER FLOAT_NUMBER STRING_LITERAL

%token LE GE EQ NE

%left '+' '-'
%left '*' '/'
%left '<' '>' LE GE EQ NE
%right '='

%%

program:
      includes macros global_declarations functions
      {
          if (syntax_errors == 0) {
              printf("\nAnálisis sintáctico completado correctamente.\n");
          } else {
              printf("\nAnálisis terminado con %d error(es) sintáctico(s).\n", syntax_errors);
          }
      }
    ;

includes:
      includes include_stmt
    | /* vacío */
    ;

include_stmt:
      INCLUDE '<' ID '>'
    | INCLUDE '<' ID '.' ID '>'
    | INCLUDE STRING_LITERAL
    | INCLUDE error
      {
          report_context_error("Directiva #include inválida.");
          yyerrok;
      }
    ;

macros:
      macros macro_stmt
    | /* vacío */
    ;

macro_stmt:
      DEFINE ID expression
    | DEFINE ID
    | DEFINE error
      {
          report_context_error("Declaración de macro inválida.");
          yyerrok;
      }
    ;

global_declarations:
      global_declarations declaration
    | /* vacío */
    ;

declaration:
      type declarator_list ';'
    | type error ';'
      {
          report_context_error("Declaración de variable inválida.");
          yyerrok;
      }
    ;

declarator_list:
      declarator
    | declarator_list ',' declarator
    ;

declarator:
      ID
    | ID '=' expression
    ;

type:
      INT
    | FLOAT
    | CHAR
    | DOUBLE
    | VOID
    ;

functions:
      function
    | functions function
    ;

function:
      type ID '(' parameter_list_opt ')' block
    | INT MAIN '(' ')' block
    | type ID '(' error ')' block
      {
          report_context_error("Error en parámetros de función.");
          yyerrok;
      }
    | INT MAIN '(' error ')' block
      {
          report_context_error("Error en parámetros de main. Se esperaba int main().");
          yyerrok;
      }
    | type ID '(' parameter_list_opt ')' error
      {
          report_context_error("Bloque de función inválido.");
          yyerrok;
      }
    | INT MAIN '(' ')' error
      {
          report_context_error("Bloque inválido en main.");
          yyerrok;
      }
    ;

parameter_list_opt:
      parameter_list
    | /* vacío */
    ;

parameter_list:
      parameter
    | parameter_list ',' parameter
    ;

parameter:
      type ID
    | type
    ;

block:
      '{' local_declarations statements '}'
    | '{' local_declarations statements error
      {
          report_context_error("Falta cerrar bloque '}'.");
          yyerrok;
      }
    ;

local_declarations:
      local_declarations declaration
    | /* vacío */
    ;

statements:
      statements statement
    | /* vacío */
    ;

statement:
      assignment_stmt
    | if_stmt
    | while_stmt
    | return_stmt
    | function_call_stmt
    | block
    | error ';'
      {
          report_context_error("Sentencia inválida.");
          yyerrok;
      }
    ;

assignment_stmt:
      ID '=' expression ';'
    | ID '=' error ';'
      {
          report_context_error("Asignación inválida.");
          yyerrok;
      }
    ;

function_call_stmt:
      ID '(' argument_list_opt ')' ';'
    | ID '(' error ')' ';'
      {
          report_context_error("Llamada a función inválida.");
          yyerrok;
      }
    ;

argument_list_opt:
      argument_list
    | /* vacío */
    ;

argument_list:
      expression
    | argument_list ',' expression
    ;

if_stmt:
      IF '(' expression ')' block
    | IF '(' expression ')' block ELSE block
    | IF '(' error ')' block
      {
          report_context_error("Condición inválida en if.");
          yyerrok;
      }
    | IF '(' expression ')' error
      {
          report_context_error("Bloque inválido en if.");
          yyerrok;
      }
    ;

while_stmt:
      WHILE '(' expression ')' block
    | WHILE '(' error ')' block
      {
          report_context_error("Condición inválida en while.");
          yyerrok;
      }
    ;

return_stmt:
      RETURN expression ';'
    | RETURN ';'
    | RETURN error ';'
      {
          report_context_error("Sentencia return inválida.");
          yyerrok;
      }
    ;

expression:
      expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | expression '<' expression
    | expression '>' expression
    | expression LE expression
    | expression GE expression
    | expression EQ expression
    | expression NE expression
    | '(' expression ')'
    | ID
    | NUMBER
    | FLOAT_NUMBER
    | STRING_LITERAL
    ;

%%

void yyerror(const char *s) {
    syntax_errors++;
    printf("\n[ERROR SINTÁCTICO GENERAL]\n");
    printf("  Línea aproximada : %d\n", yylineno);
    printf("  Cerca de lexema  : '%s'\n", yytext);
    printf("  Mensaje Bison    : %s\n\n", s);
}

int main(void) {
    printf("Iniciando análisis sintáctico...\n");
    yyparse();

    return syntax_errors == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}

