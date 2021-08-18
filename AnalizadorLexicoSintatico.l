/*
 Objetivo: Elaborar un analizador léxico enlex/flexque reconozca los 
 componentes léxicos pertenecientes a las clases abajo descritas.
 
 28/06/2021
 Alumnos:
 Priego Ramirez de Arellano Enrique Jesus
 Cruz Galvan Alberto Israel
 Materia:
 Grupo 2 Compiladores
 */
%{
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define maxima_lon_campo 3000
#define maximo_atomos 3000
#define FIN_DE_CADENA '?'

FILE *archivo_tokens;
FILE *archivo_atomicos;
FILE *tabla_simbolos;
FILE *tabla_palabras_reservadas;
FILE *tabla_cadenas;
FILE *tabla_operadores_relacionales;
FILE *tabla_op_arit;


int linea = 1;
int indice_de_tabla_simbolos = -1;
int indice_de_tabla_palabras_reservadas = -1;
int indice_de_tabla_cadenas = -1;
int indice_de_tabla_operadores_relacionales = -1;
int indice_de_tabla_op_arit=-1;


// Archivos
void creaArchivos();
void crea_archivo_tokens();
void crea_tabla_simbolos();
void crea_tabla_palabras_reservadas();
void crea_tabla_cadenas();
void crea_tabla_operadores_relacionales();
void crea_tabla_operador_aritmetico();
void cierraArchivos();
void crea_archivo_atomicos();

// Manejo de tablas
void insert(FILE *file, char* filename , char* campo1, char* campo2, char* campo3, int esToken);  //Uso para tablas de 2 o 3 campos
char* select_campo1(/* FROM */ FILE *file, char* filename , /* WHERE CAMPO2 = */ char* campo2 );  //Uso para tablas de 2 o 3 campos

//Manejo de cadenas
void removeSubstring(char *s,const char *toremove);

// Manejo de clases
void identificador(char identificador[]);
void decimal(char constante_entera_decimal[]);
void entera(char constante_entera_decimal[]);
void constante_entera_decimal(char constante_entera_decimal[]);
void cadena(char cadena[]);
void p_reservada(char palabra_reservada[]);
void simbolo_especial(char simbolo_especial[]);
void operador_relacional(char operador_relacional[]);
void operador_aritmetico(char operador_artimetico[]);
void asignacion(char asigancio[]);
void error_lexico(char error_lexico[]);

void atomicos();


//Manejo de sintaxis

int bandera=0;
int *error_sintactico(int*bandera);
int indice_de_caracter_de_cadena_de_atomos=-1;
char cadena_atomos[maximo_atomos];
char atomo;

char getch();

    int* Reservadas(int *bandera);
    int* W(int *bandera);
    int* X(int *bandera);
    
    int* Selector(int *bandera);
    int* Dec(int *bandera);
    int* Ent(int *bandera);
    int* Mientras(int *bandera);
    int* Para(int *bandera);
    int* Si(int *bandera);
    int* Vac(int *bandera);
    int* Numeros(int *bandera);
    int* Op_relacional(int *bandera);
    
    int *Asignacion(int *bandera);
    int *Ex_arit(int *bandera);
    int *Expresion(int *bandera);
    int *Sentencia(int *bandera);
    
    int* F(int *bandera);
    int* B(int *bandera);
    int* E(int *bandera);
    int* U(int *bandera);
    int* N(int *bandera);
    int* I(int *bandera);
    int* L(int *bandera);
    int* C(int *bandera);
    int* M(int *bandera);
    int* K(int *bandera);
    int* Q(int *bandera);
    
    

%}
salto_de_linea                 [\n]
delimitador                    [\t]|[" "]*
letra [a-z_]
digito [0-9]*
ident {letra}({letra}|{digito})*
num_real {digito}+"."{digito}*
asig ("=")
op_rel (<|>)=?|(#)|(=|=)=
op_arit "+"|"-"|"*"|"/"
c_esp "{"|"}"|","|"("|")"|"["|"]"|";"
cad ["@"](.)*["@"]+
reservada DEC|ENT|MIENTRAS|PARA|SI|SINO|VAC



%%
{salto_de_linea}                    linea++;
{delimitador}
{ident}     identificador(yytext);
{digito}	entera(yytext);
{num_real}  decimal(yytext);
{cad}       cadena(yytext);
{reservada} p_reservada(yytext);
{c_esp}     simbolo_especial(yytext);
{op_rel}    operador_relacional(yytext);
{op_arit}	operador_aritmetico(yytext);
{asig}		asignacion(yytext);
.			error_lexico(yytext);
%%
main(int argc, char *argv[])
{
     //Crea archivos
     creaArchivos();

     //Leer archivo de entrada
     yyin = fopen(argv[1],"r");

     //Abrir archivos en modo lectura y escritura

     //Corre el analizador lexico de flex yylex
     yylex();
	 fprintf(archivo_atomicos, "?");
     //Cierra archivos
     cierraArchivos();
     
     //Analisis sintáctico
	atomicos();
     
     //Imprime tabla operadores aritmetico
     printf("***************************************************\n");
     printf("\t\tTabla operadores aritmetico\n");
     printf("***************************************************\n");
        system("cat tabla_operador_aritmetico.txt");
     printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
     //Imprime tabla operadores relacionales
     printf("***************************************************\n");
     printf("\t\tTabla operadores relacionales\n");
     printf("***************************************************\n");
        system("cat tabla_operadores_relacionales.txt");
     printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
     //Imprime tabla_palabras_reservadas
     printf("***************************************************\n");
     printf("\t\t Tabla palabras reservadas\n");
     printf("***************************************************\n");
        system("cat tabla_palabras_reservadas.txt");
     printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n\n\n");
     //Resultados
     //Imprime tabla de simbolos
     printf("***************************************************\n");
     printf("\t\tTabla de simbolos\n");
     printf("***************************************************\n");
        system("cat tabla_simbolos.txt");
     printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
    
     //Imprime tabla de cadenas
     printf("***************************************************\n");
     printf("\t\tTabla de cadenas\n");
     printf("***************************************************\n");
        system("cat tabla_cadenas.txt");
     printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
     
     //Imprime tokens
     printf("***************************************************\n");
     printf("\t\tTokens\n");
     printf("***************************************************\n");
        system("cat tokens.txt");
     printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
     
     
      //Imprime cadena de atomos
    printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
    printf("\t\tCadena de atomos\n");
     printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
    system("cat atomos.txt");
    printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
     
}
void creaArchivos()
{
    //Crea archivo de salida
        crea_archivo_tokens();

    //Crea tabla de simbolos
        crea_tabla_simbolos();

    //Crea tabla de palabras reservadas
        crea_tabla_palabras_reservadas();
        
    //Crea tabla de cadenas
        crea_tabla_cadenas();
        
    //Crea tabla de operadores relacionales
        crea_tabla_operadores_relacionales();   
        
   //Crea tabla para operadores aritmeticos
		crea_tabla_operador_aritmetico();
		
		crea_archivo_atomicos();
}

void crea_archivo_tokens()
{
    archivo_tokens = fopen("tokens.txt","w");
}
void crea_archivo_atomicos()
{
	archivo_atomicos = fopen("atomicos.txt","w");
}

void crea_tabla_simbolos()
{
    tabla_simbolos = fopen("tabla_simbolos.txt","w");
}
void crea_tabla_palabras_reservadas()
{
    tabla_palabras_reservadas = fopen("tabla_palabras_reservadas.txt","w");
    
    //Inserta a la tabla tuplas predefinidas
    insert(tabla_palabras_reservadas, "tabla_palabras_reservadas.txt", "0","DEC"   ,"", 0);
    insert(tabla_palabras_reservadas, "tabla_palabras_reservadas.txt","1","ENT","",0);
    insert(tabla_palabras_reservadas, "tabla_palabras_reservadas.txt","2","MIENTRAS","",0);
    insert(tabla_palabras_reservadas, "tabla_palabras_reservadas.txt","3","PARA","",0);
    insert(tabla_palabras_reservadas, "tabla_palabras_reservadas.txt","4","SI","",0);
    insert(tabla_palabras_reservadas, "tabla_palabras_reservadas.txt","5","SINO","",0);
    insert(tabla_palabras_reservadas, "tabla_palabras_reservadas.txt","6","VAC","",0);
    
}
void crea_tabla_cadenas()
{
    tabla_cadenas = fopen("tabla_cadenas.txt","w");
}

void crea_tabla_operadores_relacionales()
{
    tabla_operadores_relacionales = fopen("tabla_operadores_relacionales.txt","w");
    
    //Inserta a la tabla tuplas predefinidas
    
    insert(tabla_operadores_relacionales, "tabla_operadores_relacionales.txt", "0","#", "", 0);
    insert(tabla_operadores_relacionales, "tabla_operadores_relacionales.txt", "1","==","", 0);
    insert(tabla_operadores_relacionales, "tabla_operadores_relacionales.txt", "2",">", "", 0);
    insert(tabla_operadores_relacionales, "tabla_operadores_relacionales.txt", "3",">=","", 0);
    insert(tabla_operadores_relacionales, "tabla_operadores_relacionales.txt", "4","<","", 0);
    insert(tabla_operadores_relacionales, "tabla_operadores_relacionales.txt", "5","<=","", 0);
}

void crea_tabla_operador_aritmetico()
{
	tabla_op_arit = fopen("tabla_operador_aritmetico.txt","w");
    
    //Inserta a la tabla tuplas predefinidas
    
    insert(tabla_op_arit, "tabla_operador_aritmetico.txt", "0","+", "", 0);
    insert(tabla_op_arit, "tabla_operador_aritmetico.txt", "1","-","", 0);
    insert(tabla_op_arit, "tabla_operador_aritmetico.txt", "2","*", "", 0);
    insert(tabla_op_arit, "tabla_operador_aritmetico.txt", "3","/","", 0);
	}

	
void cierraArchivos()
{
    fclose(archivo_tokens);
    fclose(tabla_simbolos);
    fclose(tabla_palabras_reservadas);
    fclose(tabla_cadenas);
    fclose(tabla_operadores_relacionales);
    fclose(tabla_op_arit);
    fclose(archivo_atomicos);
}

void insert(FILE *file, char* filename , char* campo1, char* campo2, char* campo3, int esToken)
{
    // Si no existe en la tabla se inserta
    if(esToken == 1 || select_campo1( file, filename, campo2) == NULL )
    {
        char *registro = (char *)malloc(sizeof(campo1) + sizeof(campo2) + sizeof(campo3));
        strcpy( registro, campo1);
        strcat( registro, "\t");
        strcat( registro, campo2);
        strcat( registro, "\t");
        strcat( registro, campo3);
        strcat( registro, "\n");
        fprintf( file, "%s", registro);
    }
}

char* select_campo1(/* FROM */ FILE *file, char* filename , /* WHERE CAMPO2 = */ char* campo2 )
{
    
    // Cerrar archivo
    fclose( file );
    
    // Abrir archivo en modo lectura
    file = fopen( filename , "r" );
    
    
    // Declaracion de variables para guardar los campos
    int numero;
    char *_campo1 = (char *) malloc(maxima_lon_campo);
    char *_campo2 = (char *) malloc(maxima_lon_campo);
    char *_campo3 = (char *) malloc(maxima_lon_campo);

    // Ciclo while
    while( fscanf( file, "%200[^\t\n]\t%200[^\t\n]", _campo1, _campo2) >= 1) 
                                                                             // Guarda campo1 y campo2 en _campo1 y _campo2
    {
        //Para hacer al ultimo campo opcional
        fgets( _campo3 , maxima_lon_campo, file );                   // Se encarga del resto de la linea
        sscanf(_campo3, "\t%200[^\t]", _campo3);                             // Le quita el tabulador y guarda el campo3 en _campo3
        if( strcmp( campo2, _campo2 ) == 0 )
        {
            return _campo1;
        }
    }
    if(feof(file))
    {            
         // puts("EOF");
         // printf("No se encontró en la tabla el campo buscado");
         
    }
    else
    {
         puts("CAN NOT READ TABLE");
    }
    
    
    // Cerrar arvhivo 
    fclose(file);
    
    // Abrir archivo en modo escritura
    file = fopen(filename, "a+");

    return NULL;
    
}

// Manejo de cadenas
void removeSubstring(char *s,const char *toremove)
{
  while( s=strstr(s,toremove) )
    memmove(s,s+strlen(toremove),1+strlen(s+strlen(toremove)));
}

// Manejo de clases

void identificador(char identificador[])
{
    // Si no se encuentra la el identificador en la tabla de simbolos: se agrega cadena a la tabla de simbolos
    if( select_campo1( tabla_simbolos , "tabla_simbolos.txt" , identificador ) == NULL)
    {
        char string_de_indice_de_tabla_simbolos[20];
        indice_de_tabla_simbolos++;
        sprintf( string_de_indice_de_tabla_simbolos, "%d", indice_de_tabla_simbolos);
        insert( tabla_simbolos, "tabla_simbolos.txt" , string_de_indice_de_tabla_simbolos, identificador, "", 0);
    }

    // Se crea el token con la clase 1 y la posición en la tabla de simbolos
    char *posicion = select_campo1( tabla_simbolos , "tabla_simbolos.txt" , identificador );
    insert( archivo_tokens , "tokens.txt", "1", posicion, "", 1);   
    fprintf(archivo_atomicos,"a");

}

void asignacion(char asigancio[]){
	
	char ascii_simbolo_igual[20];
    sprintf(ascii_simbolo_igual , "%d", asigancio[0]);
	insert(archivo_tokens, "tokens.txt" , "8",ascii_simbolo_igual, "", 1);
	fprintf(archivo_atomicos,"=");
	}

void decimal(char constante_entera_decimal[])
{
    // Se crea el token con clase 7 y valor en decimal
    insert(archivo_tokens, "tokens.txt" , "7", constante_entera_decimal, "", 1);
    fprintf(archivo_atomicos,"=");
    fprintf(archivo_atomicos,"d");
}

void entera(char constante_entera_decimal[])
{
    // Se crea el token con clase 6 y valor en decimal
    insert(archivo_tokens, "tokens.txt" , "6", constante_entera_decimal, "", 1);
    fprintf(archivo_atomicos,"i");
}

void operador_aritmetico(char operador_artimetico[]){
	// Se crea el token con clase 4 y valor en decimal
    
    if( select_campo1( tabla_op_arit , "tabla_operador_aritmetico.txt" , operador_artimetico ) == NULL)
    {
        char string_de_indice_de_tabla_op_arit[20];
        indice_de_tabla_op_arit++;
        sprintf( string_de_indice_de_tabla_op_arit, "%d", indice_de_tabla_op_arit);
        insert( tabla_op_arit, "tabla_operadores_relacionales.txt" , string_de_indice_de_tabla_op_arit, operador_artimetico, "", 0);
    }

    // Se crea token con clase 4 y posicion en la tabla de cadenas
    char *posicion = select_campo1( tabla_cadenas , "tabla_cadenas.txt" , operador_artimetico ); 
    insert( archivo_tokens , "tokens.txt", "4", posicion, "", 1);
	
	if ((strncmp("+", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"+");
    }
    if ((strncmp("-", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"-");
    }
    if ((strncmp("*", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"*");
    }
    if ((strncmp("/", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"/");
    }
	
	}
void cadena(char cadena[])
{

    removeSubstring( cadena , "\n" );
    // Si no se encuentra la cadena en la tabla de cadenas: se agrega cadena a la tabla de cadenas
    if( select_campo1( tabla_cadenas , "tabla_cadenas.txt" , cadena ) == NULL)
    {
        char string_de_indice_de_tabla_cadenas[20];
        indice_de_tabla_cadenas++;
        sprintf( string_de_indice_de_tabla_cadenas, "%d", indice_de_tabla_cadenas);
        insert( tabla_cadenas, "tabla_cadenas.txt" , string_de_indice_de_tabla_cadenas, cadena, "", 0);
    }

    // Se crea token con clase 3 y posicion en la tabla de cadenas
    char *posicion = select_campo1( tabla_cadenas , "tabla_cadenas.txt" , cadena ); 
    insert( archivo_tokens , "tokens.txt", "3", posicion, "", 1);
    fprintf(archivo_atomicos,"c");
    
}

void p_reservada(char palabra_reservada[])
{
    // Guardar subcadena seguida del simbolo #
    sscanf(palabra_reservada, "#%s", palabra_reservada);
    
    // Si no se encuentra la cadena en la tabla de palabras reservada: se agrega cadena a la tabla de palabras reservadas
    if( select_campo1( tabla_palabras_reservadas , "tabla_palabras_reservadas.txt" , palabra_reservada ) == NULL)
    {
        char string_de_indice_de_tabla_palabras_reservadas[20];
        indice_de_tabla_palabras_reservadas++;
        sprintf( string_de_indice_de_tabla_palabras_reservadas, "%d", indice_de_tabla_palabras_reservadas);
        insert( tabla_palabras_reservadas, "tabla_palabras_reservadas.txt" , string_de_indice_de_tabla_palabras_reservadas, palabra_reservada, "", 0);
    }

    // Se crea token con clase 0 y posicion en la tabla de cadenas
    char *posicion = select_campo1( tabla_palabras_reservadas , "tabla_palabras_reservadas.txt" , palabra_reservada );
    insert( archivo_tokens , "tokens.txt", "0", posicion, "", 1);
    
    //Analizador
    if ((strncmp("DEC", palabra_reservada, -1) == 0)) {
        fprintf(archivo_atomicos,"r");
    }
    if ((strncmp("ENT", palabra_reservada, -1) == 0)) {
        fprintf(archivo_atomicos,"e");
    }
    if ((strncmp("MIENTRAS", palabra_reservada, -1) == 0)) {
        fprintf(archivo_atomicos,"m");
    }
    if ((strncmp("PARA", palabra_reservada, -1) == 0)) {
        fprintf(archivo_atomicos,"p");
    }
    if ((strncmp("SI", palabra_reservada, -1) == 0)) {
        fprintf(archivo_atomicos,"S");
    }
    if ((strncmp("SINO", palabra_reservada, -1) == 0)) {
        fprintf(archivo_atomicos,"n");
    }
    if ((strncmp("undef", palabra_reservada, -1) == 0)) {
        fprintf(archivo_atomicos,"u");
    }
    if ((strncmp("VAC", palabra_reservada, -1) == 0)) {
        fprintf(archivo_atomicos,"v");
    }
    
}

void simbolo_especial(char simbolo_especial[])
{
    // Se crea token con clase 2 Y el simbolo especial en codigo ASCII
    char ascii_simbolo_especial[20];
    sprintf(ascii_simbolo_especial , "%d", simbolo_especial[0]);
    insert(archivo_tokens, "tokens.txt" , "2", ascii_simbolo_especial, "", 1);
    
    //Agregar a cadena de atomos el atomo dependiendo de el simbolo especial
    if ((strncmp(";", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,";");
    }
    if ((strncmp("(", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"(");
    }
    if ((strncmp(")", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,")");
    }
    if ((strncmp(",", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,",");
    }
    if ((strncmp("{", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"{");
    }
    if ((strncmp("}", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"}");
    }
    if ((strncmp("[", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"]");
    }
    if ((strncmp("]", simbolo_especial, -1) == 0)) {
        fprintf(archivo_atomicos,"]");
    }
    
}

void operador_relacional(char operador_relacional[])
{
    // Se crea el token con clase 5 y la posición en la tabla de operadores relacionales
    char *posicion = select_campo1( tabla_operadores_relacionales, "tabla_operadores_relacionales.txt" , operador_relacional );
    insert(archivo_tokens, "tokens.txt" , "5", posicion, "", 1);
    
    
    if ((strncmp("<", operador_relacional, -1) == 0)) {
        fprintf(archivo_atomicos,"<");
    }
    if ((strncmp("<=", operador_relacional, -1) == 0)) {
        fprintf(archivo_atomicos,"l");
    }
    if ((strncmp(">", operador_relacional, -1) == 0)) {
        fprintf(archivo_atomicos,">");
    }
    if ((strncmp(">=", operador_relacional, -1) == 0)) {
        fprintf(archivo_atomicos,"y");
    }
    if ((strncmp("==", operador_relacional, -1) == 0)) {
        fprintf(archivo_atomicos,"g");
    }
    if ((strncmp("#", operador_relacional, -1) == 0)) {
        fprintf(archivo_atomicos,"#");
    }

}

void error_lexico(char error_lexico[])
{
    printf("Error léxico en la linea %d\n Se encontró: %s\n", linea, yytext);
}

// ------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------Analizador sintatico------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------

void atomicos(){
	archivo_atomicos=fopen("atomicos.txt","r");
	fscanf(archivo_atomicos,"%[^\n]", cadena_atomos);
	fclose(archivo_atomicos);
	getch();
	
	//Declaración de bandera de error sintactico.
    int booleano = 0;
    int *bandera = &booleano;
    //Si no se produjeron errores durante el analisis léxico.
    if (bandera == 0) {
        //Inicia el análisis sintáctico.
        int *a = Reservadas(bandera);
        //Se analizó correctamente.
        if (*a == 0) {
            printf("Analisis sintactico: ¡Cadena correcta!\n");
        }
        //Se analizó de manera incorrecta.
        if (*a == 1) {
            printf("Analisis sintactico: ¡Cadena incorrecta!\n");
        }
    }
}

char getch()
{
    indice_de_caracter_de_cadena_de_atomos++;
    atomo = cadena_atomos[indice_de_caracter_de_cadena_de_atomos];
    return cadena_atomos[indice_de_caracter_de_cadena_de_atomos];
}
int *Reservadas(int *bandera)
{
	if (atomo == 'r' ||
		atomo == 'e' ||
		atomo == 'm' ||
		atomo == 'p' ||
		atomo == 's' ||
		atomo == 'n' ||
		atomo == 'v' ||
		atomo == 'c' )//cadena
		{
			W(bandera);
		}
	else
    {
        printf("Error sintactico: Se esperaba una cadena, DEC|ENT|MIENTRAS|PARA|SI|SINO|VAC. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
    }
    return bandera;
}
int *W(int *bandera)
{
	if (atomo == 'c' )//checamos que sea una @cadena@
	{
		getch();
		X(bandera);
	}
	else if (atomo == 'r' ||
			 atomo == 'e' ||
			 atomo == 'm' ||
			 atomo == 'p' ||
			 atomo == 's' ||
			 atomo == 'n' ||
			 atomo == 'v' )
		{
			Selector(bandera);
			X(bandera);
		}
	else
    {
        printf("Error sintactico: Se esperaba una cadena, DEC|ENT|MIENTRAS|PARA|SI|SINO|VAC. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
    }
    return bandera;
}
int *X(int *bandera)
{
	if (atomo == 'c' )//checamos que sea una @cadena@
	{
		atomo=getch();
		X(bandera);
		return bandera;
	}
	else if (atomo == 'r' ||
			 atomo == 'e' ||
			 atomo == 'm' ||
			 atomo == 'p' ||
			 atomo == 's' ||
			 atomo == 'n' ||
			 atomo == 'v' )
		{
			Selector(bandera);
			X(bandera);
			return bandera;
		}
	else if (atomo=='?')
	{
		return bandera;
	}
	else
	{
		printf("Error sintactico: Se esperaba una cadena, DEC|ENT|MIENTRAS|PARA|SI|SINO|VAC. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
	return bandera;
}
//Selector es donde las palabras reservadas van a sus correspondientes sintaxis
int *Selector(int *bandera)//P
{
	if (atomo == 'r')
	{Dec(bandera);}
	else if (atomo == 'e')
	{Ent(bandera);}
	else if (atomo == 'm')
	{Mientras(bandera);}
	else if (atomo == 'p')
	{Para(bandera);}
	else if (atomo == 's')
	{Si(bandera);}
	else if (atomo == 'n')
	{E(bandera);}
	else if (atomo == 'v')
	{Vac(bandera);}
	else
	{
		printf("Error sintactico: Se esperaba una DEC|ENT|MIENTRAS|PARA|SI|SINO|VAC. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
	return bandera;
}
int *Ident(int *bandera)
{
	if (atomo == 'a')//identificador
		{
			getch();
			if(atomo == ',')
			{
				getch();
				Ident(bandera);
			}
		}
		return bandera;
}
int *Dec(int *bandera)
{
	if (atomo == 'r')
	{
		getch();
		if (atomo == 'a')//identificador
		{
			getch();
			if (atomo == ';')
			{
				getch();
				return bandera;
			}else if(atomo == ',')
			{
				Ident(bandera);
			}
			else
			{
				printf("Error sintactico: Falta poner un ;. Se encontró un %c\n", atomo);
				error_sintactico(bandera);
			}
			
		}
		else
		{
			printf("Error sintactico: Se esperaba un identificador. Se encontró un %c\n", atomo);
            error_sintactico(bandera);
		}
	}
	return bandera;
}
int *Ent(int *bandera)
{
	if (atomo == 'e')
	{
		getch();
		if (atomo == 'a')//identificador
		{
			getch();
			if(atomo == ';')
			{
				getch();
				return bandera;
			}else if(atomo == ',')
			{
				getch();
				Ident(bandera);
				if (atomo == 'i')
				{
					getch();
					if(atomo == ']')
					{
						getch();
						return bandera;
					}
					else
					{
						printf("Error sintactico: Se esperaba un [. Se encontró un %c\n", atomo);
						error_sintactico(bandera);
					}
				}
				else
				{
					printf("Error sintactico: Se esperaba un [. Se encontró un %c\n", atomo);
					error_sintactico(bandera);
					}
			}
		}
		else
		{
			printf("Error sintactico: Se esperaba un identificador. Se encontró un %c\n", atomo);
            error_sintactico(bandera);
		}
	}
	return bandera;
}

//Sea constantes numericas enteras o decimal 
int *Numeros(int *bandera)
{
	if (atomo == 'i')
	{
		getch();
	}
	else if	(atomo == 'd')
		{
			getch();
		}
	else
	{
		printf("Error sintactico: Se esperaba un identificador, constante entera o constande decimal. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
}
int* Mientras(int *bandera)
{
	if (atomo == 'm')	
	{
		getch();
		if(atomo=='(')
		{
			getch();
			Expresion(bandera);
			Op_relacional(bandera);
			Ex_arit(bandera);
			if (atomo==')')
			{
				getch();
				if (atomo==')')
				{
					getch();
					if(atomo=='{')
					{
						getch();
						Sentencia(bandera);
						if(atomo=='}')
						{	
							getch();
							return bandera;
						}
						else{
								printf("Error sintactico: Se esperaba un }. Se encontró un %c\n", atomo);
								error_sintactico(bandera);
							}
					}
						else{
								printf("Error sintactico: Se esperaba un {. Se encontró un %c\n", atomo);
								error_sintactico(bandera);
							}		
				}
				else
				{
					printf("Error sintactico: Se esperaba un ). Se encontró un %c\n", atomo);
					error_sintactico(bandera);
				}
			}
			else 
			{
				printf("Error sintactico: Se esperaba un (. Se encontró un %c\n", atomo);
				error_sintactico(bandera);
			}
		}
		else 
		{
			printf("Error sintactico: Se esperaba un (. Se encontró un %c\n", atomo);
			error_sintactico(bandera);
		}
	}
}



int* Para(int *bandera)
{
	if(atomo == 'p')
	{
		if(atomo == '(')
		{
			getch();
			Asignacion(bandera);//var1=5
			if(atomo== ';')//var1<15
			{
				getch();
				Expresion(bandera);
				if(atomo== ';')
				{
					Ex_arit(bandera);
					getch();
				}else
				{
					printf("Error sintactico: Se esperaba un ;. Se encontró un %c\n", atomo);
					error_sintactico(bandera);
				}
			}else
			{
				printf("Error sintactico: Se esperaba un ;. Se encontró un %c\n", atomo);
				error_sintactico(bandera);
			}
		}
	}
}

int* Si(int *bandera)//aqui va tambien la para Sino
{
	if(atomo == 's')
	{
		getch();
		Expresion(bandera);
		B(bandera);
		L(bandera);
		E(bandera);
	}
}

int *Expresion(int *bandera)//int* C
{
	if (atomo == '(')
	{
		getch();
		M(bandera);
		Q(bandera);
		if(atomo == ')')
		{
			getch();
		}
		else
		{
			printf("Error sintactico: Se esperaba un ). Se encontró un %c\n", atomo);
            error_sintactico(bandera);
		}
	}
	else
	{
		printf("Error sintactico: Se esperaba un (. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
	return bandera;
}
int *B(int *bandera)
{
	if (atomo == 'r' ||
		atomo == 'e' ||
		atomo == 'm' ||
		atomo == 'p' ||
		atomo == 's' ||
		atomo == 'n' ||
		atomo == 'v' )
		{
			Selector(bandera);
			B(bandera);
			return bandera;
		}
		//terminos finales
		else if(atomo == '}' ||
				atomo == '?' ||
				atomo == ';')
		{
			return bandera;
		}
		else if(atomo == 'c')
		{
			getch();
			B(bandera);
			return bandera;
		}
		else
		{
			printf("Error sintactico: Se esperaba una DEC|ENT|MIENTRAS|PARA|SI|SINO|VAC. Se encontró un %c\n", atomo);
			error_sintactico(bandera);
		}
		return bandera;
}
int *E(int *bandera)//Sino
{
	if(atomo == '{')
	{
		getch();
		B(bandera);
	}
	else if(atomo == '}')
	{
		return bandera;
	}
	else
	{
		printf("Error sintactico: Se esperaba un SINO. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
	return bandera;
}

int *L(int *bandera)
{
	if (atomo == 'n') 
	{
		return bandera;
	}
	else if(atomo == '(')
	{
		getch();
		Expresion(bandera);
		B(bandera);
		L(bandera);
	}
	else if(atomo == ')') 
	{
		return bandera;
	}
	else
    {
        printf("Error sintactico: Se esperaba un SINO. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
    }
    return bandera;
}

int *M(int *bandera)
{
	if (atomo == 'a')//identificador
	{
		getch();
	}
	else if(atomo == 'i' ||
			atomo == 'd')
	{
		Numeros(bandera);
	}
	else
	{
		printf("Error sintactico: Se esperaba un identificador, constante entera o constande decimal. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
	return bandera;
}

int *Q(int *bandera)
{
	if (atomo == ')') {
        return bandera;
    }
    //operador relacional
    else if(atomo == '#' ||
			atomo == 'g' ||
			atomo == '>' ||
			atomo == 'y' ||
			atomo == '<' ||
			atomo == 'l')
			{
				Op_relacional(bandera);
				M(bandera);
			}
	else
	{
		printf("Error sintactico: Se esperaba un ), <, <=, >, >=, ==, #. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
	return bandera;
}

int *Op_relacional(int *bandera)
{
	if(atomo == '#')
	{	getch();	}
	if(atomo == 'g')
	{	getch();	}
	if(atomo == '>')
	{	getch();	}
	if(atomo == 'y')
	{	getch();	}
	if(atomo == '<')
	{	getch();	}
	if(atomo == 'l')
	{	getch();	}
	if(atomo == 'a'||atomo == 'd'||atomo == 'i')
	{
		return bandera;
	}
	else
	{
		printf("Error sintactico: Se esperaba un  <, <=, >, >=, ==, #, constante decimal o constante entera. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
	return bandera;
}
//funcion
int* Vac(int *bandera)
{
	if(atomo== 'a')
	{
		getch();
		if(atomo== '(')
		{
			getch();
			if(atomo== ')')
			{
				getch();
				if(atomo== '{')
				{
					Sentencia(bandera);
					return bandera;
				}
				else
				{	
					printf("Error sintactico: Se esperaba un {. Se encontró un %c\n", atomo);
					error_sintactico(bandera);
				}
				
			}
			else
			{	
				printf("Error sintactico: Se esperaba un ). Se encontró un %c\n", atomo);
				error_sintactico(bandera);
			}
			
		}
		else
		{	
			printf("Error sintactico: Se esperaba un (. Se encontró un %c\n", atomo);
			error_sintactico(bandera);
        }
		
	}
	else
	{
		printf("Error sintactico: Se esperaba un  identificador. Se encontró un %c\n", atomo);
        error_sintactico(bandera);
	}
	return bandera;
}

int *Ex_arit(int *bandera)
{
	if(atomo == 'a'||
	   atomo == 'i'||
	   atomo == 'd')
	{
		getch();
		if(atomo == '+'||
		   atomo == '-'||
		   atomo == '/'||
		   atomo == '*'||
		   atomo == 'a')
		   {
			   getch();
			   return bandera;
			}
			else if(atomo == '[')
			{
				getch();
				if (atomo == 'i')
				{
					getch();
					if(atomo == ']')
					{	
						getch();
						return bandera;
					}
				}
				
				else
				{
					printf("Error sintactico: Se esperaba un numero entero. Se encontró un %c\n", atomo);
					error_sintactico(bandera);
				}
			}
	}
	return bandera;
}
int *Sentencia(int *bandera)
{
	Dec(bandera);
	Vac(bandera);
	Ent(bandera);
	Ex_arit(bandera);
	Reservadas(bandera);
	Asignacion(bandera);
	return bandera;
}
int *Asignacion(int *bandera)
{
	if(atomo== 'a')
	{
		getch();
		if( atomo=='=')
		{
			getch();
			if(atomo == '[')
			{
				getch();
				Numeros(bandera);
				Ex_arit(bandera);
				Asignacion(bandera);
				W(bandera);
				if (atomo == ']')
				{
					getch();
					return bandera;
				}
				else
				{
					printf("Error sintactico: Se esperaba un ]. Se encontró un %c\n", atomo);
					error_sintactico(bandera);
				}
			}
			else
			{
				printf("Error sintactico: Se esperaba un [. Se encontró un %c\n", atomo);
				error_sintactico(bandera);
			}
			
			if(atomo == 'c')
			{
				getch();
				if(atomo == ';')
				{
					getch();
					return bandera;
				}
			}
			else if(atomo == '?')
			{
				getch();
				return bandera;
			}//Fin ?
		}//Fin atomo =
		else
		{
			printf("Error sintactico: Se esperaba un  identificador, otra asignacion o exptresion aritmetica. Se encontró un %c\n", atomo);
			error_sintactico(bandera);
		}
	}//Fin atomo para

	return bandera;

}//Fin funcion Asignacion
int* error_sintactico(int *bandera)
{
    *bandera = 1;
    
     //Descartar simbolos hasta que se encuentre una palabra reservada o el fin de cadena.
        while (1) {
            //Si se encuentra alguno de estos atomos volver a comenzar el analisis sintáctico.
            if (atomo == 'r' ||
				atomo == 'e' ||
				atomo == 'm' ||
				atomo == 'p' ||
				atomo == 's' ||
				atomo == 'n' ||
				atomo == 'v' ||
				atomo == 'c' )//cadena
                break;
            //Si se encuentra el fin de cadena dejar de buscar.
            if (atomo == '?' )
            {
                return bandera;
            }
            getch();
        }
    
    //Declaración de nueva bandera de error
    int booleano = 0;
    int *_bandera = &booleano;
    
    //Llamada al simbolo inicial.
    Reservadas(_bandera);
    
    return bandera;
}
