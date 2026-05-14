%option noyywrap

%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"func"                  { return FUNC; }

[a-zA-Z_][a-zA-Z0-9_]*  {
                            yylval.str = strdup(yytext);
                            return ID;
                        }

"("                     { return PARIZQ; }
")"                     { return PARDER; }
";"                     { return PUNTOYCOMA; }
","                     { return COMA; }

[ \t\r\n]+              ;

.                       { return yytext[0]; }

%%

