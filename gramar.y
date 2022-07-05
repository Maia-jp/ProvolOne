%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define YYERROR_VERBOSE 1

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
void closeIO();
void verificarVarList(char* string);
void removeChar(char * str, char charToRemmove);
void adicionarVarTable(char *var);
int verificarVarTable(char* var);

int nFunctions = 0;
extern int linenum;
extern int wordnum;
extern char linebuf[500];
int varTableIndex = 0;
char *varTable[500];

//Flags
int FILEIO[2] = {0,0}; //{read,write}


//TODO: Expressoes complexas, verficar arquivos com -Wcounterexamples, verificar shift reduce, concertar indentacao, outros tipos de program

%}

/* Tipos aceitos pelo compilador */
%union {
  int ival;
  char *sval;
}

/* Tokens basicos */
%token <sval> ID
%token <sval> INT
/* Tokens de Operacao */
%token <sval> ASSIGN
%token CLOSEP OPENP
%token <sval> MAIOR
%token <sval> MENOR
%token <sval> MAIS
%token <sval> MENOS
%token <sval> MULT
%token <sval> DIVI
/* Tokens avancados */
%token ENTRADA
%token SAIDA
%token FIM
%token INC
%token ZERA
/* Tokens De Fluxo de Comando */
%token ENQUANTO
%token FACA
%token VEZES
%token ENTAO
%token SE
%token SENAO
/* Gramatica */
%type <sval> program varlist cmd cmds declaration comparation;

/* Regras Gramaticais */
%%
program : ID ENTRADA varlist SAIDA varlist cmds FIM {printf("function %s (%s)\n%s\n\treturn %s\nend", $1,$3,$6,$5);nFunctions++;} 
|	ENTRADA varlist SAIDA varlist cmds FIM {printf("function foo(%s)\n%s\n\treturn %s\nend",$2,$5,$4);nFunctions++;} 
;


varlist: varlist ID 		{char *multparam=malloc(strlen($1)+strlen($2));sprintf(multparam, "%s, %s", $1, $2); $$ = multparam;verificarVarList(multparam);}
|	ID 						{char *param = malloc(strlen($1));sprintf(param,"%s",$1); $$ = param;verificarVarList(param);}
;

cmds: cmds cmd  			{char *comandos=malloc(strlen($1) + strlen($2) + 2); sprintf(comandos, "%s\n\t%s", $1, $2); $$=comandos;}
|	cmd						{char *comando=malloc(strlen($1) + 2); sprintf(comando, "\t%s", $1); $$=comando;}
;


cmd: ENQUANTO ID FACA cmds FIM					{char *loop = malloc(strlen($2)+strlen($4)+16);sprintf(loop,"while(%s)\ndo\n\t%s\n\tend",$2,$4);$$=loop;verificarVarTable($2);}
|	ENQUANTO comparation FACA cmds FIM			{char *loop = malloc(strlen($2)+strlen($4)+16);sprintf(loop,"while(%s)\ndo\n\t%s\n\tend",$2,$4);$$=loop;}
|	FACA ID VEZES cmds FIM           			{char *forLoop=malloc(strlen($2) + strlen($4) + 20); sprintf(forLoop, "for i = %s, 1, -1 do\n\t%s\n\tend", $2, $4); $$ = forLoop;}
| 	INC OPENP ID CLOSEP              			{char *inc=malloc(strlen($3)*2 + 5); sprintf(inc, "%s = %s+1\n",$3,$3); $$ = inc;verificarVarTable($3);}
| 	ZERA OPENP ID CLOSEP             			{char *zerar=malloc(strlen($3) + 6); sprintf(zerar, "%s = 0\n",$3); $$ = zerar;verificarVarTable($3);}
|	SE comparation ENTAO cmds FIM       		{char *condicional=malloc(strlen($2) + strlen($4) + 11); sprintf(condicional, "if %s then\n\t\t%s\nend", $2, $4); $$ = condicional;}
|	SE comparation ENTAO cmds SENAO cmds FIM    {char *condicional=malloc(strlen($2) + strlen($4) + 15); sprintf(condicional, "if %s then\n\t\t%s\t\telse\n\t\t%s\t\tend", $2, $4,$6); $$ = condicional;}
|	comparation;
|	declaration;
;

declaration: ID ASSIGN INT 			{char *line = malloc(strlen($1)+strlen($3)+3);sprintf(line,"%s = %s",$1,$3);$$=line;adicionarVarTable($1);}
|	ID ASSIGN ID 			{char *line = malloc(strlen($1)+strlen($3)+3);sprintf(line,"%s = %s",$1,$3);$$=line;adicionarVarTable($1);verificarVarTable($3);}
|	ID ASSIGN INT MAIS INT	{char *line = malloc(strlen($1)+strlen($3)+5);sprintf(line,"%s = %s+%s ",$1,$3,$5);$$=line;}
|	ID ASSIGN INT MENOS INT	{char *line = malloc(strlen($1)+strlen($3)+5);sprintf(line,"%s = %s-%s ",$1,$3,$5);$$=line;}
|	ID ASSIGN INT MULT INT	{char *line = malloc(strlen($1)+strlen($3)+5);sprintf(line,"%s = %s*%s ",$1,$3,$5);$$=line;}
|	ID ASSIGN INT DIVI INT	{char *line = malloc(strlen($1)+strlen($3)+5);sprintf(line,"%s = %s/%s ",$1,$3,$5);$$=line;}
;



comparation: ID ASSIGN ASSIGN ID		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s == %s",$1,$4);$$=comp;verificarVarTable($1);verificarVarTable($4);}
|	ID ASSIGN ASSIGN INT	{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s == %s",$1,$4);$$=comp;verificarVarTable($1);}
|	ID MAIOR ASSIGN ID		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s >= %s",$1,$4);$$=comp;verificarVarTable($1);verificarVarTable($4);}
|	ID MENOR ASSIGN ID		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s <= %s",$1,$4);$$=comp;verificarVarTable($1);verificarVarTable($4);}
|	ID MAIOR ASSIGN INT		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s >= %s",$1,$4);$$=comp;verificarVarTable($1);}
|	ID MENOR ASSIGN INT		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s <= %s",$1,$4);$$=comp;verificarVarTable($1);}
|	ID MENOR INT			{char *comp = malloc(strlen($1)+strlen($3)+3);sprintf(comp,"%s < %s",$1,$3);$$=comp;verificarVarTable($1);}
|	ID MAIOR INT			{char *comp = malloc(strlen($1)+strlen($3)+3);sprintf(comp,"%s < %s",$1,$3);$$=comp;verificarVarTable($1);}
|	ID MENOR ID				{char *comp = malloc(strlen($1)+strlen($3)+3);sprintf(comp,"%s < %s",$1,$3);$$=comp;verificarVarTable($1);verificarVarTable($3);}
|	ID MAIOR ID				{char *comp = malloc(strlen($1)+strlen($3)+3);sprintf(comp,"%s < %s",$1,$3);$$=comp;verificarVarTable($1);verificarVarTable($3);}
;



%%

int main(int argc, char *argv[]) {
	//Parseia or argumentos de entrada e saida 
	int opt;
	char * saida;
	char * entrada;
	while((opt = getopt(argc, argv, "o:r:")) != -1) 
    { 
        switch(opt) 
        { 
			case 'r':
				entrada = malloc(strlen(optarg));
				sprintf(entrada,"%s",optarg);
				yyin =  fopen(entrada, "r");
				FILEIO[0] = 1;
				break;
            case 'o':
				saida = malloc(strlen(optarg)+4);
				sprintf(saida,"%s.lua",optarg);
				printf("Redirecionando output para %s\n",saida);
 				stdout = fopen(saida, "w+");
				FILEIO[1] = 1;
				break;
            case ':': 
                printf("option needs a value\n"); 
                break; 
            case '?': 
                printf("unknown option: %c\n", opt);
                break; 
        } 
    } 


	if(!FILEIO[0]){
		yyin = stdin;
	}
	yyparse();


	closeIO();
	return 0;
}

void yyerror(const char* s) {
	closeIO();
	if(linenum || wordnum){
		fprintf(stderr, "\n\n%s! <+> Linha:%d|Letra:%d\n", s, linenum,wordnum);
	}else{
		fprintf(stderr, "\n\n%s!\n", s);
	}
	fprintf(stderr, "\t%s\n\t", linebuf);
	
	for(int word = 0; word <= strlen(linebuf); word++)
  	{
		if(word==wordnum){
			fprintf(stderr, "^");
		}else{
    		fprintf(stderr, "-");
	  	}
  	}
	
	exit(1);
}

//AUX functions
void closeIO(){
	if(FILEIO[0]){
		fclose(stdout);
	}
	
	if(FILEIO[0]){
		fclose(stdin);
	}
}

void adicionarVarTable(char *var){
	varTable[varTableIndex] = malloc(sizeof(var));
	sprintf(varTable[varTableIndex],"%s",var);
	varTableIndex++;
	varTableIndex = varTableIndex%499; //Volta ao indicie inical quando estoura o buffer
}

int verificarVarTable(char* var){
	
	for(int j=0;j<varTableIndex;j++){
		if(!strcmp(varTable[j],var)){
			return 1;
		}
	}

	char *erroMsg = malloc(sizeof(var)+39);
	sprintf(erroMsg,"Erro variavel '%s' nao foi declarada antes",var);
	yyerror(erroMsg);
	return 0;
}

//Verifica a existencia de Variaveis Repitidas na varlist
void verificarVarList(char* string){
	//Copia conteudos string
	char * cpstring = malloc(sizeof(string));
	sprintf(cpstring,"%s",string);

	//Tokeniza Lista de Variaveis
	char * token = strtok(cpstring, " ");
	char *varBuf[50];
	int bufSize = 0;
    
	while( token != NULL ) {
		removeChar(token,',');
		varBuf[bufSize] = malloc(sizeof(token));
    	sprintf(varBuf[bufSize],"%s",token);
    	token = strtok(NULL, " ");
		bufSize++;
   	}

	   //Verifica Duplicados
	int no = bufSize;
	for(int i=0; i<no; i++){
		for(int j=i+1;j<no;j++){
			if(!strcmp(varBuf[i],varBuf[j])){
				sprintf(linebuf,"%s",varBuf[i]);
				wordnum = 0;
				linenum = 0;
				yyerror("Erro de Variaveis Duplicadas");
				break;
			}
		}
	}

	for(int i=0; i<no; i++){
		adicionarVarTable(varBuf[i]);
	}
   


}

void removeChar(char * str, char charToRemmove){
    int i, j;
    int len = strlen(str);
    for(i=0; i<len; i++)
    {
        if(str[i] == charToRemmove)
        {
            for(j=i; j<len; j++)
            {
                str[j] = str[j+1];
            }
            len--;
            i--;
        }
    }
    
}