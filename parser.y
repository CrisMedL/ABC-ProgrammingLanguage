%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table.h"

extern int yylex(void);
extern FILE* yyin;

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

%union {
    int num_value;
    char* str_value;
}

%token DECLARE PRINT EQ
%token PLUS MINUS TIMES DIVIDE
%token COMMA
%token <num_value> NUMBER
%token <str_value> STRING
%token <str_value> VARNAME

%type <num_value> expr

%left PLUS MINUS
%left TIMES DIVIDE
%nonassoc UMINUS

%%

program: lines ;

lines:
      line lines
    | /* empty */
    ;

line:
      declaration
    | assignment
    | print
    ;

declaration:
      DECLARE VARNAME EQ expr       { declare_symbol_with_number($2, $4); }
    | DECLARE VARNAME EQ STRING     { declare_symbol_with_string($2, $4); }
    | DECLARE VARNAME               { declare_symbol_empty($2); }
    | DECLARE var_list
    ;

var_list:
    var_init
  | var_init COMMA var_list
;

var_init:
    VARNAME EQ expr    { declare_symbol_with_number($1, $3); }
  | VARNAME EQ STRING  { declare_symbol_with_string($1, $3); }
  | VARNAME            { declare_symbol_empty($1); }
;

assignment:
      VARNAME EQ expr               { set_symbol_number($1, $3); }
    | VARNAME EQ STRING             { set_symbol_string($1, $3); }
    ;

print:
      PRINT VARNAME {
          struct symbol* s = find_symbol($2);
          if (!s) {
              printf("Undeclared variable %s\n", $2);
              exit(1);
          }
          if (s->is_string) {
              printf("%s\n", s->str_value);
          } else {
              printf("%d\n", s->value);
          }
      }
    ;

expr:
      expr PLUS expr     { $$ = $1 + $3; }
    | expr MINUS expr    { $$ = $1 - $3; }
    | expr TIMES expr    { $$ = $1 * $3; }
    | expr DIVIDE expr   {
          if ($3 == 0) {
              yyerror("Division by zero");
              exit(1);
          }
          $$ = $1 / $3;
      }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    | NUMBER            { $$ = $1; }
    | VARNAME {
          struct symbol* s = find_symbol($1);
          if (!s) {
              printf("Undeclared variable %s\n", $1);
              exit(1);
          }
          if (s->is_string) {
              printf("Variable %s is a string, not a number\n", $1);
              exit(1);
          }
          $$ = s->value;
      }
    | '(' expr ')'      { $$ = $2; }
    ;

%%

int main(int argc, char *argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error opening file");
            return 1;
        }
    } else {
        yyin = stdin;
    }

    return yyparse();
}
