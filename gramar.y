%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

int nFunctions = 0;

//TODO: Verificacao de variaveis, Expressoes complexas, IO de arquivo como flag, verficar arquivos com -Wcounterexamples, verificar shift reduce

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

// TODO Aceitar outros booleanos
cmd:
|	ENQUANTO ID FACA cmds FIM	{char *loop = malloc(strlen($2)+strlen($4)+16);sprintf(loop,"while(%s)\nDO\n%s\nEND",$2,$4);$$=loop;}
|	comparation;
|	declaration;
;

declaration:
|	ID ASSIGN INT 			{char *line = malloc(strlen($1)+strlen($3)+3);sprintf(line,"%s = %s",$1,$3);$$=line;}
|	ID ASSIGN ID 			{char *line = malloc(strlen($1)+strlen($3)+3);sprintf(line,"%s = %s",$1,$3);$$=line;}
;

// TODO >,< e >= e <=
comparation:
|	ID ASSIGN ASSIGN ID		{char *comp = malloc(strlen($1)+strlen($3)+4);sprintf(comp,"%s == %s",$1,$3);$$=comp;}
|	ID ASSIGN ASSIGN INT	{char *comp = malloc(strlen($1)+strlen($3)+4);sprintf(comp,"%s == %s",$1,$3);$$=comp;}
;



%%

int main() {
	yyin = stdin;
	yyparse();

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}