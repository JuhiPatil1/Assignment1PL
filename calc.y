%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yyparse();
extern	FILE* yyin;
extern int yylex();

#define maxsym 20  ;

extern int yylineno;

struct symbolTable
{
	char name[50];
	char value[50];
	char type [50];
};


struct symbolTable symTab[10];

int iTableSize = 0;

//Functions
void insertIntValue(char name[50],char value[50],char type[50]);
int getIntValue(char name[50]);
void updateVal (char *val, char *id);
int typeerror(const char *s)


%}


%token TOK_SEMICOLON TOK_ADD TOK_MUL TOK_OPENB TOK_CLOSEB TOK_EQUAL  %token TOK_ID TOK_INT TOK_PRINT TOK_BRAC_SUB

%token<num_val> TOK_NUM

%union{
		char id_name[100];
		char key[100];
		struct numberType
		{
			char *numType;
			int intValue;
		};
		struct numberType num_val;
		
		
}

%type<num_val> expr constants
%type<id_name> TOK_ID
%type<key> TOK_INT


%left TOK_ADD
%left TOK_MUL


%%


stmts :
		| stmts stmt
		;
		
stmt:
    TOK_INT TOK_ID TOK_SEMICOLON
		{

        int temp=getIntValue($2);
		fprintf(stdout,"temp value:%d\n",temp);
		printf("temp value:%d\n",temp);
		if(temp > -1)
		{
		 return typeerror("Variable is already defined more than once.\n");
		}
		else{
		insertIntValue($2,"0","int");
		}
		
		}

    | TOK_ID TOK_EQUAL expr TOK_SEMICOLON 
	{
		
		
		int index1=getIntValue($1);
		if(index1 > -1)
		{

		if(strcmp(symTab[index1].type,$3.numType)==0)
			{

			char *exprval = (char *)malloc(sizeof(int)*50);
			snprintf(exprval, sizeof(int)*50, "%d", $3.intValue);
			updateVal (exprval,$1);
			}
				else
					{
					yyerror("Type error");
					}
		}
		else
		{
		yyerror(strcat($1," is used but is not declared"));
		}
	}
	
	|  TOK_PRINT TOK_ID TOK_SEMICOLON
	{
		int index = getIntValue($2);
		printf("%s\n",symTab[index].value);
	}
	
;


expr: 	 
	
	  expr TOK_ADD expr
	  {
		if(strcmp($1.numType,$3.numType)==0)
		{
			struct numberType finalValue;
			finalValue.numType=$1.numType;
			finalValue.intValue=$1.intValue + $3.intValue;
				
			$$=finalValue;
		}
		else
			yyerror("Type error");
	  }
	| expr TOK_MUL expr
	  {
		if(strcmp($1.numType,$3.numType)==0)
		{
			struct numberType finalValue;
			finalValue.numType=$1.numType;
			finalValue.intValue=$1.intValue * $3.intValue;
			
				
			$$=finalValue;
		}
		else
			yyerror("Type error");
	  }
	|	TOK_ID
	{
		int index = getIntValue($1);
		struct numberType idData;
			idData.intValue=atoi(symTab[index].value);
			idData.numType="int";
		
		
		$$=idData;
		
	}
	| 
	TOK_BRAC_SUB expr TOK_CLOSEB
    {
			struct numberType finalValue;
			finalValue.numType=$2.numType;
			finalValue.intValue=$2.intValue * -1;
				
			$$=finalValue;
		
	  
    }
	| constants
	{
		
		$$=$1;
	}
	
;


constants:	TOK_NUM 
	  { 	
		$$=$1;
	  }

%%

void insertIntValue(char Name[50], char Value[50], char Type[50])
{
    strcpy(symTab[iTableSize].name, Name);
    strcpy(symTab[iTableSize].value, Value);
	strcpy(symTab[iTableSize].type, Type);
	//printf("\n %s : %s : %s", symTab[iTableSize].name, symTab[iTableSize].value, symTab[iTableSize].type);
    iTableSize++;
}

int getIntValue(char name[50])
{
int i = 0;
    if(0 != iTableSize)
    {
        for(i ; i < iTableSize; i++)
        {
            if( strcmp(name, symTab[i].name) == 0)
            {
                return i;
            }
        }
        
    }
    else
    {
        return -1;
    }
}

void updateVal (char *val, char *id)
	{
		int index= getIntValue(id);
		strcpy(symTab[index].value,val);
	}

int yyerror(char *s)
{
	printf(" Parsing Error at Line number %d\n%s\n",yylineno,s);
	return 0;
}

	int typeerror(const char *s)
	{
	printf("Line %d: %s\n", yylineno, s);
	return 0;
	}

int main()
{
   yyparse();
   return 0;
}
