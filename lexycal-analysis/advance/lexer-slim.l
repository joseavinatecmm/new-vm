%{
#include <stdio.h>
int countn = 0;
%}

%option yylineno

alpha   [a-zA-Z]
digit   [0-9]
unary   "++"|"--"

%%

"int"        { printf("TOKEN: INT (%s)\n", yytext); }
"float"      { printf("TOKEN: FLOAT (%s)\n", yytext); }
"char"       { printf("TOKEN: CHAR (%s)\n", yytext); }
"void"       { printf("TOKEN: VOID (%s)\n", yytext); }
"return"     { printf("TOKEN: RETURN (%s)\n", yytext); }
"for"        { printf("TOKEN: FOR (%s)\n", yytext); }
"if"         { printf("TOKEN: IF (%s)\n", yytext); }
"else"       { printf("TOKEN: ELSE (%s)\n", yytext); }
"printf"     { printf("TOKEN: PRINTF (%s)\n", yytext); }
"scanf"      { printf("TOKEN: SCANF (%s)\n", yytext); }
"true"       { printf("TOKEN: TRUE (%s)\n", yytext); }
"false"      { printf("TOKEN: FALSE (%s)\n", yytext); }


[-]?{digit}+                { printf("TOKEN: NUMBER (%s)\n", yytext); }
[-]?{digit}+\.{digit}+      { printf("TOKEN: FLOAT (%s)\n", yytext); }
{alpha}({alpha}|{digit})*   { printf("TOKEN: ID (%s)\n", yytext); }
{unary}                     { printf("TOKEN: UNARY (%s)\n", yytext); }

"<="        { printf("TOKEN: LE (%s)\n", yytext); }
">="        { printf("TOKEN: GE (%s)\n", yytext); }
"=="        { printf("TOKEN: EQ (%s)\n", yytext); }
"<"         { printf("TOKEN: LT (%s)\n", yytext); }
"&&"        { printf("TOKEN: AND (%s)\n", yytext); }
"||"        { printf("TOKEN: OR (%s)\n", yytext); }

"+"         { printf("TOKEN: ADD (%s)\n", yytext); }
"-"         { printf("TOKEN: SUB (%s)\n", yytext); }
"*"         { printf("TOKEN: MUL (%s)\n", yytext); }

[ \t]+      { /* ignorar espacios */ }
\n          { countn++; }

.           { printf("UNKNOWN: %s\n", yytext); }

%%

int yywrap(void) { return 1; }

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror("No se pudo abrir el archivo"); return 1; }
        yyin = f;
    }
    yylex();
    printf("\n>>> Total de líneas: %d\n", countn);
    return 0;
}

