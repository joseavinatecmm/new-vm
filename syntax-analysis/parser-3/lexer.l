%{
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

#undef yywrap      /* ← evita conflicto de macro */
int yywrap(void) { return 1; }  /* evita necesidad de -lfl */
int curr_lineno = 1;
%}

%option noyywrap

%%
"#include"              { return INCLUDE; }
"#define"               { return DEFINE; }
"<"                     { return LT; }
">"                     { return GT; }
"int"                   { return INT; }
"return"                { return RETURN; }
[0-9]+(\.[0-9]+)?       { yylval.fval = atof(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }
";"                     { return ';'; }
[ \t\r]+                ;               
\n                      { curr_lineno++; }
.                       { return yytext[0]; }
<<EOF>>                 { return 0; }
%%

