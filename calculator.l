%{
    #include "y.tab.h"

 
%}

%%


"print"     { return print;}
"exit"      {return exit_command;}


[a-zA-Z]+   {yylval.id = yytext[0];  return VARIABLES;}
-?[0-9]+ {yylval.num = atoi(yytext);  return INTEGER ;}
[0-9]+\.[0-9]+ { yylval.num = atoi(yytext); return FLOAT;}

"<=" {return LE;}
">=" {return GE;}
"==" {return EQ;}
"!=" {return NE;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"++" {return INCREMENT;}
"--" {return DECREMENT;}


[ \t\n]     ;
[-+*/=;^%()]   { return yytext[0];}
.           {ECHO; yyerror("unexpected character");}

%%




//called by lex when input is at end of file, returns 1 by default


int yywrap(void)
{
    return 1;
}



