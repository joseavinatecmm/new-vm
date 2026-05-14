%{
#include "parser.tab.h"
%}

%option noyywrap

%%
"#include"          { return INCLUDE; }
"int"               { return INT; }
"return"            { return RETURN; }
[a-zA-Z_][a-zA-Z0-9_]* { return ID; }
[0-9]+              { return NUMBER; }
";"                 { return ';'; }
[ \t\n]             ;    
.                   { return yytext[0]; }
%%


