%{
#include <stdio.h>
#include "table.h"
extern FILE *yyin;
extern int yylex(void);
void yyerror(const char*);
%}
%union {
  char* vname; 
  int value; 
};
%token DECLARE PRINT EQ 
%token <value> NUMBER
%token <vname> VARNAME
%%
P: L YYEOF
L: I L
L: 
I: DECLARE VARNAME { declare_symbol($2); }
I: DECLARE VARNAME EQ NUMBER { declare_symbol_with_value($2, $4); }
I: VARNAME EQ NUMBER { 
      if (find_symbol($1) < 0) {
        printf("Undeclared variable %s\n", $1);
        exit(0);
      }
      set_symbol($1, $3); 
    }
I: PRINT VARNAME { 
      int index = find_symbol($2); 
      if(index >= 0)
        printf("%d\n",table[index].value); 
      else {
        printf("Undeclared variable %s\n",$2);
        exit(0);
      }
    }
%%
 
int main(void) {
  yyin = fopen("program.txt", "r");
  yyparse(); 
}
 
void yyerror(const char *s) { 
        printf("error: %s\n", s); 
}
