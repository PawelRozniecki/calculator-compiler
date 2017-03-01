%{
  void yyerror(char *s);
  #include <stdio.h>
  #include <stdlib.h>
  #include <ctype.h>
  #include <math.h>
 

 
 int symbols[52]; //symbol array table for variable names [a-zA-Z]
  int symbolVal(char symbol); //function for look up value of a symbol in a table
  void updateSymbolVal(char symbol, int val); //update symbol table
  
%}

%union {int num; char id; float f;} //types that lexical analyser can return
%start line
%token print

%token exit_command
%token <num> INTEGER
%token <f> FLOAT
%token <num> PI
%token <id> VARIABLES
%token IF ELSE  WHILE
%token INCREMENT
%token DECREMENT
%type  <num> line exp type
%type  <id> assignment

%left '-' '+'
%left '*' '/'
%left '(' ')'
%left '<' '>' LE GE EQ NE
%nonassoc UMINUS


%%

//inputs for c actions


line    : assignment ';'    {;}
        | exit_command ';'  {exit(EXIT_SUCCESS);}
        | print exp ';'     {printf(" = %d\n" , $2);} // each time user inputs print it will print the value of specified exp
        | line assignment ';' {;}
        | line print exp ';'  {printf(" = %d  \n" , $3);}
        | line exit_command ';' {exit(EXIT_SUCCESS);}
     
        | '\n'


        ;

assignment : VARIABLES '=' exp { updateSymbolVal($1,$3); }
           | VARIABLES     {$$ = $1;}

            ;


exp     : type                   {$$ ==$1;}
        | exp '+' type           {$$ =$1+$3;}
        | exp '-' type           {$$ =$1-$3;}
        | exp '/' type           {if ($3 == 0) { yyerror("Cannot divide by zero"); }else $$ = $1/$3;}
        | exp '*' type           {$$ = $1*$3;}
        | exp '^' type           {$$ = pow($1,$3);}
        | exp '%' type       {$$ = $1%$3;}
        |  '(' exp ')'          { $$ = $2;}



        | exp  exp'+'            {$$ =$1+$2;}
        | exp exp '-'            {$$ =$1-$2;}
        | exp exp '*'            {$$ = $1*$2;}
        | exp exp '^'            {$$ = pow($1,$2);}
        | exp exp '%'        {$$ = $1%$2;}
        | exp exp '/'        { $$ = $1/$2;}
        
        | exp EQ exp {if ($1 == $3) {printf("both numbers are equal");} else printf("not equal");}
        ;

type    : INTEGER                 {$$ = $1;}
        | FLOAT                 {$$ = $1;}
        | VARIABLES             {$$ = symbolVal($1);}
        | '(' exp ')'           { $$ = $2;}
        ;

%%

int generateSymbolIndex(char token){
    int index = -1;
    if(islower(token)){
        index = token - 'a' + 26;
        
    }else if(isupper(token)){
        index = token - 'A';
    }
    return  index;
}
int symbolVal(char symbol){
    int table = generateSymbolIndex(symbol);
    return symbols[table];
    
}
void updateSymbolVal(char symbol, int val){
    
    int table = generateSymbolIndex(symbol);
    symbols[table] = val;
    
}

int main(void){
    int i;
    for(i=0; i< 52; i++){
        symbols[i] = 0;
        
    }
    return yyparse();
}
void yyerror(char *s){
    fprintf(stderr, "%s\n" , s);
}



