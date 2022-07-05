%{
#include <unistd.h>
#include "gramar.tab.h"
//Erro Handling Vars
int linenum = 1;
int wordnum = 1;
char linebuf[500];
%}
%%
ENTRADA         {return ENTRADA;}
SAIDA           {return SAIDA;}
FIM             {return FIM;}

ENQUANTO        {return ENQUANTO;}
FACA            {return FACA;}
VEZES           {return VEZES;}

SE              {return SE;}
ENTAO           {return ENTAO;}
SENAO           {return SENAO;}

INC             {return INC;}
ZERA            {return ZERA;}

[A-Za-z]+       {yylval.sval = strdup(yytext);return ID;}
[0-9]+          {yylval.sval = strdup(yytext); return INT;}
"+"             {return MAIS;}
"-"             {return MENOS;}
"*"             {return MULT;}
"/"             {return DIVI;}
"="             {return ASSIGN;}
">"             {return MAIOR;}
"<"             {return MENOR;}

"("             {return OPENP;}
")"             {return CLOSEP;}

[ \t]           {wordnum++;}

[\n]            {wordnum=1;}

\n.*            {linenum++;strncpy(linebuf, yytext+1, sizeof(linebuf));yyless(1);}
%%

