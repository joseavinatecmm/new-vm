%{
#include <stdio.h>
#include <string.h>

int token_count = 0;
int lines = 1;

#define MAXTOKENS 500

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

^"#include"[ \t]*<[^>]+\.h>     { addToken("INCLUDE", yytext, lines); }

"int"                           { addToken("INT TYPE", yytext, lines); }
"return"                        { addToken("RETURN", yytext, lines); }

{alpha}({alpha}|{digit})*       { addToken("IDENTIFIER", yytext, lines); }

"{"                             { addToken("LEFT-BRACE", yytext, lines); }
"}"                             { addToken("RIGHT-BRACE", yytext, lines); }
"("                             { addToken("LEFT-PAREN", yytext, lines); }
")"                             { addToken("RIGHT-PAREN", yytext, lines); }
";"                             { addToken("SEMICOLON", yytext, lines); }

{digit}+                        { addToken("NUMBER", yytext, lines); }

\n                              { lines++; }  
{ws}                            {  } // ignore spaces
.                               { addToken("UNKNOWN", yytext, lines); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror("No se pudo abrir el archivo"); return 1; }
        yyin = f;
    }

    yylex();

    printf("\n%-15s %-20s %-5s\n", "TOKEN", "LEXEME", "LINE");
    printf("------------------------------------------------------\n");
    for (int i = 0; i < token_count; i++) {
        printf("%-15s %-20s %-5d\n", tokens[i].type, tokens[i].lexeme, tokens[i].line);
    }

    printf("\n>>> Total de líneas leídas: %d\n", lines);
    return 0;
}

