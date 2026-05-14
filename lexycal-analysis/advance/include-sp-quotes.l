%{
#include <stdio.h>
#include <string.h>

int token_count = 0;
int line_count = 1;

#define MAXTOKENS 1000

typedef struct {
    char lexeme[100];
    char type[30];
    int line;
} Token;

Token tokens[MAXTOKENS];

void addToken(const char *type, const char *lexeme, int line) {
    if (token_count < MAXTOKENS) {
        strcpy(tokens[token_count].type, type);
        strcpy(tokens[token_count].lexeme, lexeme);
        tokens[token_count].line = line;
        token_count++;
    }
}
%}

%option noyywrap

alpha [a-zA-Z_]
digit [0-9]
ws [ \t]+

%%

[ \t]*"#include"[ \t]*<[^>]+\.h>      { addToken("INCLUDE_ANGLE", yytext, line_count); }

[ \t]*"#include"[ \t]*\"[^\"]+\.h\"   { addToken("INCLUDE_QUOTES", yytext, line_count); }

"int"                           { addToken("INT", yytext, line_count); }
"return"                        { addToken("RETURN", yytext, line_count); }
{alpha}({alpha}|{digit})*       { addToken("IDENTIFIER", yytext, line_count); }

"{"                             { addToken("LBRACE", yytext, line_count); }
"}"                             { addToken("RBRACE", yytext, line_count); }
"("                             { addToken("LPAREN", yytext, line_count); }
")"                             { addToken("RPAREN", yytext, line_count); }
";"                             { addToken("SEMICOLON", yytext, line_count); }

{digit}+                        { addToken("NUMBER", yytext, line_count); }

\n                              { line_count++; }  
{ws}                            {  }
.                               { addToken("UNKNOWN", yytext, line_count); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror("No se pudo abrir el archivo"); return 1; }
        yyin = f;
    }

    yylex();

    printf("\n%-18s %-25s %-5s\n", "TOKEN", "LEXEME", "LINE");
    printf("--------------------------------------------------------------\n");
    for (int i = 0; i < token_count; i++) {
        printf("%-18s %-25s %-5d\n", tokens[i].type, tokens[i].lexeme, tokens[i].line);
    }

    printf("\n>>> Total de líneas leídas: %d\n", line_count);
    return 0;
}

