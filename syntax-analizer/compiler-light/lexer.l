%option noyywrap yylineno

%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

digit       [0-9]
letter      [a-zA-Z_]
id          {letter}({letter}|{digit})*
number      {digit}+
floatnum    {digit}+\.{digit}+
string      \"[^\"]*\"

%%

"#include"          { return INCLUDE; }
"#define"           { return DEFINE; }

"int"               { return INT; }
"float"             { return FLOAT; }
"char"              { return CHAR; }
"double"            { return DOUBLE; }
"void"              { return VOID; }

"return"            { return RETURN; }
"if"                { return IF; }
"else"              { return ELSE; }
"while"             { return WHILE; }
"main"              { return MAIN; }

"<="                { return LE; }
">="                { return GE; }
"=="                { return EQ; }
"!="                { return NE; }

{floatnum}          { return FLOAT_NUMBER; }
{number}            { return NUMBER; }
{string}            { return STRING_LITERAL; }
{id}                { return ID; }

"("                 { return '('; }
")"                 { return ')'; }
"{"                 { return '{'; }
"}"                 { return '}'; }
";"                 { return ';'; }
","                 { return ','; }
"."                 { return '.'; }
"="                 { return '='; }

"+"                 { return '+'; }
"-"                 { return '-'; }
"*"                 { return '*'; }
"/"                 { return '/'; }

"<"                 { return '<'; }
">"                 { return '>'; }

[ \t\r\n]+          ;

.                   {
                        printf("Carácter no reconocido en línea %d: %s\n", yylineno, yytext);
                        return yytext[0];
                    }


