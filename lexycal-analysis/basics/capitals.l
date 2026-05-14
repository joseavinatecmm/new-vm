%{
int count = 0;
%}

%%
[A-Z] {printf("%s capital letter\n", yytext);
       count++;}

.     {printf("%s not a capital letter\n", yytext);}
\n    {return 0;}

%%

int yywrap()
{
    return 1;
}

int main(){

yylex();
printf("\n... num of Capital letters " 
      "in the given text - %d\n", count);

return 0;
}
