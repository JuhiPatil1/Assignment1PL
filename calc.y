%{
  #include <stdio.h>
  #include <string.h>
  extern int l;
  int yylex();
  int yyerror();

  struct table
  {
    char identifier[50];
    int table_value;
  }SyTab[1000];
   struct s{
		int id_type;
		int expr_type;
		double value;
	} s;
    int var=0;
    int findVar(char* VaNam)
    {
      int i=0;
      for(i=0;i<var;i++)
      {
        if(!strcmp(SyTab[i].identifier,VaNam))
        {
          return SyTab[i].table_value;
        }
      }
      return 0;
    }

    void upVar(char* VaNam, int NewVal)
    {
      int f=0, i=0;
      for(i=0;i<var;i++)
      {
        if(!strcmp(SyTab[i].identifier,VaNam))
        {
          SyTab[i].table_value = NewVal;
          f=1;
          break;
        }
      }
      if(f==0)
      {
        strcpy(SyTab[i].identifier,VaNam);
        SyTab[i].table_value=NewVal;
        var++;
      }
    }
    %}

    %token TOK_SEMICOLON TOK_ADD TOK_MUL TOK_NUM TOK_PRINT
    %token TOK_OPEN_BRAC TOK_CLOSE_BRAC TOK_EQUAL TOK_ID TOK_BRAC_SUB
	%token TOK_INT
	/*%token<int_val> expr TOK_NUM*/
	%token<int_val> INT 

    %union
    {
      int int_val;
      char id[100];
    }


    /*%type <int_val> expr TOK_NUM*/
    %type <int_val> expr TOK_NUM
    %type <id> TOK_ID

    %left TOK_ADD 
    %left TOK_MUL 

    %%

    Prog:
	|
     Vardefs stmts
    ;
	Vardefs:
		|
		Vardef TOK_SEMICOLON Vardefs;

    stmts: | stmt TOK_SEMICOLON stmts;
    ;
	Vardef:	TOK_INT TOK_ID
		{
			s.id_type = 1;
		}
;
Stmt:
		TOK_ID TOK_EQUAL expr
		{
			if(s.id_type != 1 && s.id_type != 2)
			{
				return typeerror("Variable is used but not declared");
			}
			if(s.id_type != s.expr_type)
			{
				fprintf(stdout, "Type error EXP: %d ID: %d\n", s.expr_type, s.id_type);
				return typeerror("Type error");
			}
			upVar($1,$3);

		}
		|
		TOK_PRINT TOK_ID
		{
			fprintf(stdout, "The value is: %.2f \n", s.value);
		}
		|
		{
			fprintf(stdout, "Unable to read statement\n");
		}

;
expr:
		INT
		{
			s.expr_type = s.id_type;
			$<result_val>$ = (int)$1;
			s.value = (int)$1;
		}
		| TOK_NUM
		{
            s.expr_type = s.id_type;
			$<result_val>$ = (int)$1;
			s.value = (int)$1;
		}
		|
		TOK_ID
		{
			s.expr_type = s.id_type;
			$<result_val>$ = s.value;
		}
		|
		expr TOK_MUL expr
	  	{
			$<result_val>$ = (int)$1 * (int)$3;
			s.value = (int)$1 * (int)$3;
			
		}
		|
		expr TOK_ADD expr
	  	{
			s.value = (int)$1 + (int)$3;
			$<result_val>$ = s.value;
			
		}
		|
		{
			fprintf(stdout, "Unable to find a match\n");
		}
;



    %%

    int yyerror(char *s)
    {
      //printf("Reaching here");
      printf("\nParsing Error: Line %d \n",l);
      return 0;
    }
	
	int typeerror(const char *s)
	{
	printf("Line %d: %s\n", line_no, s);
	return 0;
	}a

    int main()
    {
      yyparse();
      return 0;
    }
