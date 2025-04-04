#include <string.h>
#include <stdlib.h>
 
struct symbol {
  char* name;
  int value;  
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
void set_symbol(char *sname, int svalue) {
    int pos = find_symbol(sname);
    if(pos < 0) {
       table[num_sym].name = sname;
       table[num_sym].value = svalue;
       num_sym++;
       if(num_sym > 100) {
          printf("Too many variables (>100)");
          exit(0);
       }
    } else {
       table[pos].name = sname;
       table[pos].value = svalue;
    }
}