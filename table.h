#include <string.h>
#include <stdlib.h>
 
struct symbol {
  char* name;
  int value;
  int declared;  // Flag to track if variable is declared
};
struct symbol table[100]; 
int num_sym = 0;

int find_symbol(char *sname) {
   for(int i=0; i < num_sym; i++) {
       if(strcmp(table[i].name, sname) == 0)
         return i;
   }
   return -1;
}

void declare_symbol(char *sname) {
    int pos = find_symbol(sname);
    if(pos >= 0) {
        printf("Multiple declaration of variable %s\n", sname);
        exit(0);
    }
    table[num_sym].name = sname;
    table[num_sym].declared = 1;
    table[num_sym].value = 0; // Default value
    num_sym++;
    if(num_sym > 100) {
        printf("Too many variables (>100)\n");
        exit(0);
    }
}

void declare_symbol_with_value(char *sname, int svalue) {
    int pos = find_symbol(sname);
    if(pos >= 0) {
        printf("Multiple declaration of variable %s\n", sname);
        exit(0);
    }
    table[num_sym].name = sname;
    table[num_sym].declared = 1;
    table[num_sym].value = svalue;
    num_sym++;
    if(num_sym > 100) {
        printf("Too many variables (>100)\n");
        exit(0);
    }
}

void set_symbol(char *sname, int svalue) {
    int pos = find_symbol(sname);
    if(pos < 0) {
        printf("Undeclared variable %s\n", sname);
        exit(0);
    }
    table[pos].value = svalue;
}
