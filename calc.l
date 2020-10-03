%{
#include <stdio.h>
#include "calc.tab.h"
int l=1;
%}

digit	([0-9])
variable [a-zA-Z][a-zA-Z0-9]*
lexerr [0-9a-z]*
%%


"print"	{	return(TOK_PRINT);							}
";"			{	return(TOK_SEMICOLON);					}
"+"			{	return(TOK_ADD);								}
"-"			{
					printf("\nLexical Error: %s",yytext);
					return(yytext[0]);
				}
"(-"		{	return(TOK_BRAC_SUB);						}
"*"			{	return(TOK_MUL);								}
"/"			{	return(TOK_DIV);								}
"=" 		{ return(TOK_EQUAL);							}
"(" 		{ return(TOK_OPEN_BRAC);					}
")" 		{ return(TOK_CLOSE_BRAC);					}
"int"			{	return(TOK_INT);					}



[\n] l++;
" ";
"  ";

{digit}+	{
		sscanf(yytext, "%d", &yylval);
		return TOK_NUM;
		}

{variable} {
sscanf(yytext, "%s", &yylval);
return(TOK_ID);
}

{lexerr}	{
		printf("\nLexical Error: %s",yytext);
		return(yytext[0]);
		}
.return yytext[0];

%%
