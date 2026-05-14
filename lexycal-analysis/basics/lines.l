%{
int num_lines = 0;
int num_chars = 0;
%}

%%
\n      ++num_lines;
.       ++num_chars;
quit     return 0;
%%

// User code section
int yywrap()
{
    return 1;
}

int main(int argc, char **argv)
{

yylex();
printf("number of lines = %d, number of chars = %d\n",
       num_lines, num_chars );

return 0;
}
