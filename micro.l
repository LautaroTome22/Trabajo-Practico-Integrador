/* micro.l - Analizador léxico para el Lenguaje Micro */ 
%{ 
#include "y.tab.h" 
#include <stdio.h> 
#include <string.h> 
%} 
/* Definiciones de expresiones regulares */ 
letra [a-zA-Z] 
digito [0-9] 
identificador {letra}({letra}|{digito})* 
constante {digito}+ 
%% 
/* Reglas de token y acciones asociadas */ 
"inicio"       
"fin"          
"leer"         
"escribir"     
return INICIO; 
return FIN; 
return LEER; 
return ESCRIBIR; 
{identificador} { 
/* Aquí se podría llamar a una rutina semántica 
* para buscar en la tabla de símbolos y retornar 
* ID o una palabra reservada, como se hace en el 
* código C manual del documento. */ 
yylval.str = strdup(yytext); 
return ID; 
} 
{constante}    { 
    yylval.str = strdup(yytext); 
    return CONSTANTE; 
} 
":="           return ASIGNACION; 
"+"            return SUMA; 
"-"            return RESTA; 
"("            return PARENIZQUIERDO; 
")"            return PARENDERECHO; 
","            return COMA; 
";"            return PUNTOYCOMA; 
 
[ \t\n]        /* Ignorar espacios en blanco */ ; 
 
.              return ERRORLEXICO; 
 
%% 
/* Funciones auxiliares */ 
 
int yywrap() { 
    return 1; 
} 
