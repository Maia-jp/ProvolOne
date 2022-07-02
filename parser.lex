%{
#include <unistd.h>
#include "gramar.tab.h"
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
"="             {return ASSIGN;}
">"             {return MAIOR;}
"<"             {return MENOR;}

"("             {return OPENP;}
")"             {return CLOSEP;}


[ \t\n]           ;
%%

