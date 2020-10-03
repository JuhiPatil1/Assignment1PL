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
	%token<int_val> INT TOK_INT

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
    %left TOK_EQUAL

    %%

    Prog:
    stmts
    ;

    stmts: | stmt TOK_SEMICOLON stmts;
    ;

    stmt:
     TOK_INT TOK_ID TOK_EQUAL expr
    {
      upVar($2,$4);
    }
	|  TOK_ID TOK_EQUAL expr
    {
      upVar($1,$3);
    }
    | TOK_ADD TOK_EQUAL expr
    {
      upVar($1, findVar($1) + $4);
    }
    | TOK_PRINT expr
    {
      fprintf(stdout, "%d\n", $2);
    }
    | TOK_PRINT TOK_ID
    {
      fprintf(stdout, "%d\n",findVar($2));
    }
    ;


    expr:
     expr TOK_ADD expr
    {
      $$ = $1 + $3;
    }
    | expr TOK_MUL expr
    {
      $$ = $1 * $3;
    }
    | TOK_NUM
    {
      $$ = $1;
    }
    | TOK_ID
    {
      $$ = findVar($1);
    }
    | TOK_BRAC_SUB TOK_NUM TOK_CLOSE_BRAC
    {
      $$ = $2 * -1;
    }
    ;


    %%

    int yyerror(char *s)
    {
      //printf("Reaching here");
      printf("\nParsing Error: Line %d \n",l);
      return 0;
    }

    int main()
    {
      yyparse();
      return 0;
    }
