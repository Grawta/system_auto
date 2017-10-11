%{
#include <stdio.h>
%}

%token tInt tId tPo tPf tAo tAf tVir tEq tPlus tLess tStar tPv tPipe tAnd tIf tElse tNb tWhile tReturn tNot tInf tSup tDiv
%left tInf tSup tEq tPipe tAnd
%left tPlus tLess
%left tStar tDiv
%left tNot
%error-verbose

%start Prg
%%

Prg : Fonction Prg
	| /* epsilon */
Fonction : tInt tId tPo Args tPf Body
Args : /* epsilon */
	 | Arg ListeArgs
ListeArgs : tVir Arg ListeArgs
		  | /* epsilon */
Arg : tInt tId
Body : tAo {indiceProfondeur ++ ;} ListeInstr {suprProfondeur(indiceProfondeur) ; indiceProfondeur -- ;} tAf
ListeInstr : Instr ListeInstr 
	          | /*epsilon */
Instr : Decl | If | While | Affect | Invoc tPv | Ret
Ret : tReturn Expr tPv
Invoc : tId tPo Params tPf
Params :
	   | Param | Param tVir ParamNext
ParamNext : Param
		  | Param tVir ParamNext
Param : Expr
If : tIf tPo Expr tPf Body
   | tIf tPo Expr tPf Body tElse Body
While : tWhile tPo Expr tPf Body
Affect : tId tEq Expr tPv
Expr : Expr tPlus Expr
	{
		suprLastElement() ;
	}
	 | tNot Expr
	 | Expr tInf Expr
	 {
		suprLastElement() ;
	}
	 | Expr tSup Expr
	 {
		suprLastElement() ;
	}
	 | Expr tLess Expr
	 {
		suprLastElement() ;
	}
	 | Expr tDiv Expr
	 {
		suprLastElement() ;
	}
	 | Expr tStar Expr
	 {
		suprLastElement() ;
	}
	 | Expr tEq tEq Expr
	 {
		suprLastElement() ;
	}
	 | Expr tPipe tPipe Expr
	 {
		suprLastElement() ;
	}
	 | Expr tAnd tAnd Expr
	 {
		suprLastElement() ;
	}
	 | tPo Expr tPf 
	 | tNb
	 {
	 	ajoutElement($1, "int" ,0 ,0) ;
	 } 
	 | tId
	 {
	 	ajoutElement($1, "int" ,0 ,0) ;
	 } 
	 | Invoc
Decl : tInt DeclX tPv
DeclX : Decl1
	  | Decl1 tVir DeclX
Decl1 : tId
	  | tId tEq Expr




%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {
  yyparse();
}
