%{
#include "parser.tab.h"
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
[ \t\n]+                ;     /* Ignorar espacios y saltos de línea */
.                       { return yytext[0]; }
%%

