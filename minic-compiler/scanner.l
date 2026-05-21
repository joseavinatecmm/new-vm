%option noyywrap yylineno

%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

digit       [0-9]
id          [a-zA-Z_][a-zA-Z0-9_]*
string      \"[^\"]*\"

%%

"//".*                                  ;
"/*"([^*]|\*+[^*/])*\*+"/"              ;

"#include"                              { return INCLUDE; }
"#define"                               { return DEFINE; }

"int"                                   { return INT; }
"return"                                { return RETURN; }
"if"                                    { return IF; }
"printf"                                { return PRINTF; }

{string}                                {
                                            yylval.str = strdup(yytext);
                                            return STRING_LITERAL;
                                        }

{digit}+                                {
                                            yylval.str = strdup(yytext);
                                            return NUMBER;
                                        }

{id}                                    {
                                            yylval.str = strdup(yytext);
                                            return ID;
                                        }

"("                                     { return PARIZQ; }
")"                                     { return PARDER; }
"{"                                     { return LLAVEIZQ; }
"}"                                     { return LLAVEDER; }
";"                                     { return PUNTOYCOMA; }
","                                     { return COMA; }
"="                                     { return IGUAL; }

"<"                                     { return MENOR; }
">"                                     { return MAYOR; }
"."                                     { return PUNTO; }

"+"                                     { return MAS; }
"-"                                     { return MENOS; }
"*"                                     { return POR; }
"/"                                     { return DIV; }

[ \t\r\n]+                              ;

.                                       { return yytext[0]; }

%%
