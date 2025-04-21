#ifndef TABLE_H
#define TABLE_H

#include <stdbool.h>

#define MAX_SYMBOLS 100

struct symbol {
    char* name;
    int value;
    char* str_value;
    bool is_string;
};

struct symbol* find_symbol(const char* name);
void declare_symbol_with_number(const char* name, int value);
void declare_symbol_with_string(const char* name, const char* value);
void declare_symbol_empty(const char* name);
void set_symbol_number(const char* name, int value);
void set_symbol_string(const char* name, const char* value);
void print_table(void);

#endif

// --- Implementation ---
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

static struct symbol symbol_table[MAX_SYMBOLS];
static int symbol_count = 0;

struct symbol* find_symbol(const char* name) {
    for (int i = 0; i < symbol_count; ++i) {
        if (strcmp(symbol_table[i].name, name) == 0)
            return &symbol_table[i];
    }
    return NULL;
}

static struct symbol* create_symbol(const char* name) {
    if (find_symbol(name)) {
        fprintf(stderr, "Multiple declaration of variable %s\n", name);
        exit(1);
    }

    if (symbol_count >= MAX_SYMBOLS) {
        fprintf(stderr, "Symbol table full\n");
        exit(1);
    }

    symbol_table[symbol_count].name = strdup(name);
    symbol_table[symbol_count].value = 0;
    symbol_table[symbol_count].str_value = NULL;
    symbol_table[symbol_count].is_string = false;
    return &symbol_table[symbol_count++];
}


void declare_symbol_with_number(const char* name, int value) {
    struct symbol* s = create_symbol(name);
    s->value = value;
    s->is_string = false;
}

void declare_symbol_with_string(const char* name, const char* value) {
    struct symbol* s = create_symbol(name);
    s->str_value = strdup(value);
    s->is_string = true;
}

void declare_symbol_empty(const char* name) {
    create_symbol(name);
}

void set_symbol_number(const char* name, int value) {
    struct symbol* s = find_symbol(name);
    if (!s) {
        s = create_symbol(name); 
    }
    s->value = value;
    s->is_string = false;
}


void set_symbol_string(const char* name, const char* value) {
    struct symbol* s = find_symbol(name);
    if (!s) {
        s = create_symbol(name); 
    }
    if (s->str_value) free(s->str_value);
    s->str_value = strdup(value);
    s->is_string = true;
}

void print_table(void) {
    printf("--- Symbol Table ---\n");
    for (int i = 0; i < symbol_count; ++i) {
        struct symbol s = symbol_table[i];
        printf("Name: %s, Type: %s, Value: ",
               s.name,
               s.is_string ? "string" : "number");

        if (s.is_string)
            printf("%s\n", s.str_value ? s.str_value : "(null)");
        else
            printf("%d\n", s.value);
    }
    printf("---------------------\n");
}