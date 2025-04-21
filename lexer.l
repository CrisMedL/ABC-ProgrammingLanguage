%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>   // For strdup, atoi
%}


%x STRINGMODE

%%

"declare"         { return DECLARE; }
"print"           { return PRINT; }
"="               { return EQ; }
"+"               { return PLUS; }
"-"               { return MINUS; }
"*"               { return TIMES; }
"/"               { return DIVIDE; }
","               { return COMMA; }
[0-9]+            { yylval.num_value = atoi(yytext); return NUMBER; }
\"([^\"\n]*)\" { yylval.str_value = strdup(yytext + 1); yylval.str_value[strlen(yylval.str_value) - 1] = '\0'; return STRING; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str_value = strdup(yytext); return VARNAME; }

[ \t\r\n]+        { /* skip whitespace */ }

.                 { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}
