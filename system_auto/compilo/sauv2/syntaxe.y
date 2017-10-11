%{
#include <stdio.h>
#include <stdlib.h>
#include "symbole.h"
#include "tabl_instr"
FILE* fichier = NULL;
int indiceProfondeur = -1 ;
int cpt = 0 ;

int add_arith(char *op, int a, int b) {
 	fprintf(fichier, "%d LOAD R0 %d \n", cpt, a);
 	cpt ++;
	fprintf(fichier, "%d LOAD R1 %d \n", cpt, b);
	cpt ++;
	fprintf(fichier, "%d %s R0 R1 \n", cpt, op);  
	cpt ++;
	fprintf(fichier, "%d STORE %d R0 \n", cpt, a);
	cpt ++;
	suprLastElement() ;
	return a;
}
void if_ass(int adr, int a){
	fprintf(fichier, "%d LOAD R3 %d \n", cpt, a); 
	cpt ++;
	fprintf(fichier, "%d LOAD R4 1 \n", cpt);
	cpt ++;
	fprintf(fichier, "%d SOU R3 R4 \n", cpt); 			 
	cpt ++;
	fprintf(fichier, "%d JMPC %d R3 \n", cpt, adr); 
	cpt ++;
}

%}

%union { int nb; char id[16]; }
%token tInt tId tPo tPf tAo tAf tVir tEq tPlus tLess tStar tPv tPipe tAnd tIf tElse tNb tWhile tReturn tNot tInf tSup tDiv
%left tInf tSup tEq tPipe tAnd
%left tPlus tLess
%left tStar tDiv
%left tNot
%error-verbose
%type <nb> Expr tNb
%type <id> tId
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

If : tIf tPo Expr tPf {if_ass(-1,$3);} Body {fprintf(fichier, "%d JMP -2 \n", cpt); cpt ++;} Else 
   
Else : /* epsilon */ 
	| tElse Body
	
While : tWhile tPo Expr tPf Body

Affect : tId tEq Expr tPv
 	{ 	
 		fprintf(fichier, "%d AFC R3 %d \n", cpt, $3);
 		cpt ++;
    		suprLastElement() ;
	}
	
Expr :     Expr tPlus Expr	{ $$ = add_arith("ADD", $1,$3); }
	 | tNot Expr
	 {
		fprintf(fichier, "%d LOAD R0 %d \n", cpt, $2);
		cpt ++;
    		fprintf(fichier, "%d NOT R0 \n", cpt);  
    		cpt ++;
    		fprintf(fichier, "%d STORE %d R0 \n", cpt, $2);	
    		cpt ++;	
		$$ = $2;
	}
	 | Expr tInf Expr		{ $$ = add_arith("INF", $1,$3); }
	 | Expr tSup Expr		{ $$ = add_arith("SUP", $1,$3); }
	 | Expr tLess Expr		{ $$ = add_arith("SOU", $1,$3); }
	 | Expr tDiv Expr		{ $$ = add_arith("DIV", $1,$3); }
	 | Expr tStar Expr		{ $$ = add_arith("MUL", $1,$3); }
	 | Expr tEq tEq Expr		{ $$ = add_arith("EQU", $1,$4); }
	 | Expr tPipe tPipe Expr	{ $$ = add_arith("OR", $1,$4); }
	 | Expr tAnd tAnd Expr		{ $$ = add_arith("AND", $1,$4); }
	 | tPo Expr tPf 		{ $$ = $2; }
	 | tNb
	 {
	 	fprintf(fichier, "%d LOAD R3 %d \n", cpt, $1);
	 	cpt ++;
	 	int adr = ajoutElement("tmp", "int" ,0 ,indiceProfondeur) ;
	 	fprintf(fichier, "%d STORE %d R3 \n", cpt, adr);
	 	cpt ++;
    		$$ = adr;
    		printTab() ;
	 } 
	 | tId
	 {	 	
	 printf("recherche de '%s'\n", $1);
	 	fprintf(fichier, "%d LOAD R3 %d \n", cpt, rechercheElement($1));	 	
	 	cpt ++;
	 	int adr = ajoutElement("tmp", "int" ,0 ,indiceProfondeur) ;
    		fprintf(fichier, "%d STORE %d R3 \n", cpt, adr);
    		cpt ++;
    		$$ = adr;
    		printTab() ;
	 } 
	 | Invoc
	 
Decl : tInt DeclX tPv

DeclX : Decl1
	  | Decl1 tVir DeclX
	  
Decl1 : tId {ajoutElement($1, "int" ,0 ,indiceProfondeur) ; printTab() ;} 
	  | tId tEq Expr
	  { 	
		suprLastElement() ;
	  	int adr = ajoutElement($1, "int" ,1 ,indiceProfondeur) ;
	  	printTab() ;
	  	//La var prend la place de la tmp
 		//fprintf(fichier, "LOAD R3 %d \n", $3);
    		//fprintf(fichier, "STORE %d R3 \n", adr);
	  }
	  




%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {

fichier = fopen("assembleur.ass", "w");
  yyparse();
  fclose(fichier);
}
