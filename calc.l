%{

#include<stdio.h>
#include<math.h>
#include<string.h>
#include <stdlib.h>
#include "calc.tab.h"

#define YYSTYPE char*


#define maxsym 20   /* maximum number of symbols */

struct symbolTable 
{    
	char name[50];
	char value[50]; 
}
	 symbolTable [maxsym];

%}

digit				([0-9])
ID				[a-z]+

%%

"int"				{
						sscanf(yytext, "%s", &(yylval.key));
						return (TOK_INT);}

"print"			{return (TOK_PRINT);}

	
{digit}+	{	sscanf(yytext, "%d", &(yylval.num_val.intValue));
				//yylval.num_val.intValue=atoi(yytext);
				yylval.num_val.numType="int";
				return TOK_NUM;}
					
[a-z][a-z0-9A-Z]*					{sscanf(yytext, "%s", &(yylval.id_name));
					return(TOK_ID);}
					

					
";"					{	return(TOK_SEMICOLON);	}
"+"					{	return(TOK_ADD);	}
"*"					{	return(TOK_MUL);	}
"("					{	return(TOK_OPENB);	}
")"					{	return(TOK_CLOSEB);	}
"="					{	return(TOK_EQUAL);	}
"(-"				{	return(TOK_BRAC_SUB);   }
"-"			{ printf("\nLexical Analysis Error: %s",yytext);
					return(yytext[0]);
				}


"\n"	 			{	yylineno++;		}

[ \n\t]* 			;


%%
