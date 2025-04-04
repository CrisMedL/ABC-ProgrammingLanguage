%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
%}
%option noyywrap
%%
print  { return PRINT; }
=      { return EQ; }
[0-9]+ { yylval.value = atoi(yytext); 
         return NUMBER; 
       }
[a-zA-Z][a-zA-Z0-9]* { 
       yylval.vname = strdup(yytext); 
       return VARNAME; 
    }
%%