/*Priego Ramirez de Arellano Enrique Jesus
Grupo 2 Compiladores
*/
%{
#include <stdio.h>
%}
/*
Declaracion:
Donde aparecen los componentes pertenecientes
al lexico
*/
/*
Simbolos especiales
|:=Disyuncion
():=agrupacion de expresiones regulares
*:=repetecion de un patron cero o mas veces
+:=repetecion de un patron una o mas veces
?:=el patron cero o mas veces
"":delimitacion de cadenas
*/

letra [a-zA-Z_]
digito [0-9]*
ident {letra}({letra}|{digito})*
num_real {digito}+"."{digito}*
asig "="
op_rel (<|>)=?|(#)|(=|=)=
op_arit "+"|"-"|"*"|"/"
c_esp "{"|"}"|","|"("|")"|"["|"]"|";"
cad ["@"](.)*["@"]+
reservada DEC|ENT|MIENTRAS|PARA|SI|SINO|VAC

%%
{cad} {printf("Es una cadena %s\n",yytext);}
[ \t]+ putchar(' ');
[ \t]+$ ;
{asig} {printf("Asignacion %s\n",yytext);}
{c_esp} {printf ("Caracter especial %s\n",yytext);}
{reservada} {printf("%s es una palabra reservada\n", yytext);}
{ident} {printf("%s es un identificador\n", yytext);}
{num_real} {printf("%s es un numero real\n", yytext);}
{digito} {printf("%s es un numero\n", yytext);}
{op_rel} {printf("%s es un operacion realacional\n", yytext);}
{op_arit} {printf("Operador %s\n",yytext);}
. {printf ("No pertenece al alfabeto del leguaje lexico %s\n",yytext);}
%%
main()
{
 yylex();
}
