/* micro.y - Analizador sintáctico para el Lenguaje Micro */ 
%{ 
#include <stdio.h> 
#include "lex.yy.c" 
#include "rutinas.c" /* Archivo con rutinas semánticas */ 
extern FILE *in; 
extern char buffer; 
extern TOKEN tokenActual; 
extern RegTS TS; 

// Union para manejar atributos de expresiones 
%union { 
char *str; 
} 
// Declaraciones de tokens (terminales) 
%token INICIO FIN LEER ESCRIBIR ID CONSTANTE PARENIZQUIERDO 
PARENDERECHO PUNTOYCOMA COMA ASIGNACION SUMA RESTA FDT 
// Símbolo de inicio de la gramática 
%start objetivo 
// Tipos de atributos para no-terminales 
%type <str> expresion primaria identificador 
%% 
/* Reglas de la gramática y acciones semánticas */ 
objetivo : programa FDT 
{ 
Terminar(); 
}; 
programa : INICIO listaSentencias FIN 
{ 
Comenzar(); 
}; 
listaSentencias : sentencia 
| listaSentencias sentencia ; 
sentencia : identificador ASIGNACION expresion PUNTOYCOMA 
{ 
Asignar($1, $3); 
} 
| LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PUNTOYCOMA 
{ 
// Las rutinas de 'leer' se ejecutan en listaIdentificadores 
} 
| ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PUNTOYCOMA 
{ 
// Las rutinas de 'escribir' se ejecutan en listaExpresiones 
}; 

listaIdentificadores : identificador 
{ 
    Leer($1); 
} 
 
| listaIdentificadores COMA identificador 
{ 
    Leer($3); 
}; 
 
listaExpresiones : expresion 
{ 
    Escribir($1); 
} 
 
| listaExpresiones COMA expresion 
{ 
    Escribir($3); 
}; 
 
expresion : primaria 
 
| expresion SUMA primaria 
{ 
    $$ = GenInfijo($1, "+", $3); 
} 
 
| expresion RESTA primaria 
{ 
    $$ = GenInfijo($1, "-", $3); 
}; 
 
primaria : identificador 
 
| CONSTANTE 
| PARENIZQUIERDO expresion PARENDERECHO ; 
 
identificador : ID 
{ 
    $$ = $1; 
}; 
 
%% 
/* Código de usuario */ 
 
int yyerror(char const *s) { 
    fprintf(stderr, "Error Sintáctico: %s\n", s); 
    return 0;
}

int main(int argc, char **argv) { 
    if (argc!= 2) { 
        printf("Debe ingresar el nombre del archivo fuente.\n"); 
        return -1; 
    } 
    if ((in = fopen(argv, "r")) == NULL) { 
        printf("No se pudo abrir el archivo fuente.\n"); 
        return -1; 
    } 
    return yyparse(); 
}