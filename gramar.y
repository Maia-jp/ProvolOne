%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
void closeIO();

int nFunctions = 0;

//Flags
int FILEIO[2] = {0,0}; //{read,write}

//TODO: Verificacao de variaveis, Expressoes complexas, verficar arquivos com -Wcounterexamples, verificar shift reduce

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
/* Gramatica */
%type <sval> program varlist cmd cmds declaration comparation;

/* Regras Gramaticais */
%%
program : ENTRADA varlist SAIDA varlist cmds FIM {printf("function foo%d (%s)\n%s\n\treturn %s\nend",nFunctions,$2,$5,$4);nFunctions++;}


varlist: varlist ID 		{char *multparam=malloc(strlen($1)+strlen($2));sprintf(multparam, "%s, %s", $1, $2); $$ = multparam;}
|	ID 						{char *param = malloc(strlen($1));sprintf(param,"%s",$1); $$ = param;}
;

cmds: cmds cmd  			{char *comandos=malloc(strlen($1) + strlen($2) + 2); sprintf(comandos, "%s\n\t%s", $1, $2); $$=comandos;}
|	cmd						{char *comando=malloc(strlen($1) + 2); sprintf(comando, "\t%s", $1); $$=comando;}
;


cmd:
|	ENQUANTO ID FACA cmds FIM			{char *loop = malloc(strlen($2)+strlen($4)+16);sprintf(loop,"while(%s)\ndo\n\t%s\n\tend",$2,$4);$$=loop;}
|	ENQUANTO comparation FACA cmds FIM	{char *loop = malloc(strlen($2)+strlen($4)+16);sprintf(loop,"while(%s)\ndo\n\t%s\n\tend",$2,$4);$$=loop;}
|	FACA ID VEZES cmds FIM           	{char *forLoop=malloc(strlen($2) + strlen($4) + 20); sprintf(forLoop, "for i=%s, 1, -1 do\n\t%s\tend\n", $2, $4); $$ = forLoop;}
| 	INC OPENP ID CLOSEP              	{char *inc=malloc(strlen($3)*2 + 5); sprintf(inc, "%s = %s+1\n",$3,$3); $$ = inc;}
| 	ZERA OPENP ID CLOSEP             	{char *zerar=malloc(strlen($3) + 6); sprintf(zerar, "%s = 0\n",$3); $$ = zerar;};
|	comparation;
|	declaration;
;

declaration:
|	ID ASSIGN INT 			{char *line = malloc(strlen($1)+strlen($3)+3);sprintf(line,"%s = %s",$1,$3);$$=line;}
|	ID ASSIGN ID 			{char *line = malloc(strlen($1)+strlen($3)+3);sprintf(line,"%s = %s",$1,$3);$$=line;}
;


comparation:
|	ID ASSIGN ASSIGN ID		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s == %s",$1,$4);$$=comp;}
|	ID ASSIGN ASSIGN INT	{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s == %s",$1,$4);$$=comp;}
|	ID MAIOR ASSIGN ID		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s >= %s",$1,$4);$$=comp;}
|	ID MENOR ASSIGN ID		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s <= %s",$1,$4);$$=comp;}
|	ID MAIOR ASSIGN INT		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s >= %s",$1,$4);$$=comp;}
|	ID MENOR ASSIGN INT		{char *comp = malloc(strlen($1)+strlen($4)+4);sprintf(comp,"%s <= %s",$1,$4);$$=comp;}
;



%%

int main(int argc, char *argv[]) {
	//Parseia or argumentos de entrada e saida 
	// if(argc > 1){
	// 	for(int arg=0;arg<argc;arg++){
	// 		if(strcmp(argv[arg],"-o")){
				

	// 			printf("Redirecionando output para saida.lua\n");
	// 			stdout = fopen("saida.lua", "a");
	// 		}
	// 	}
	// }
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
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}

void closeIO(){
	if(FILEIO[0]){
		fclose(stdout);
	}
	
	if(FILEIO[0]){
		fclose(stdin);
	}
}