%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbole.h"
#include "tabl_instr.h"
#define retour 14

FILE* fichier = NULL;
int indiceProfondeur = -1 ;
int cpt = 0 ;

int add_arith(char *op, int a, int b) {
	ajoutInstru("LOAD",0,a);
	ajoutInstru("LOAD",1,b);
	ajoutInstru(op,0,1);
	ajoutInstru("STORE",a,0);
	suprLastElement() ;
	return a;
}
void if_ass(int a){
	ajoutInstru("LOAD",3,a);
	/*On effectue une soustraction car dans la spécification les valeurs sont inversées et il nous paraissait plus clair pour la suite de faire nos tests de conditions de cette manière*/
	ajoutInstru("LOAD",4,1);
	ajoutInstru("SOU",3,4);
	ajoutInstru("JMPC",555555,3);
}

extern int compteur_instru;

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
/*On met le registre LR en int de valeur -42 comme ça on est sur de le retrouver facilement lors de la lecture de l'assembleur ( on ne lit que des int en registres)*/	
Fonction :	tInt tId
			{	ajoutElement("@retour", "int" ,0 ,indiceProfondeur) ;
				addFonction($2);
			}
		tPo Args tPf Body
			{	//printTab();
				ajoutInstru("LOAD", 14, rechercheElement("@retour"));
				ajoutInstru("JMPR", 14, -10000);
				suprLastElement();
			}

Args : /* epsilon */
	 | Arg ListeArgs
	 
ListeArgs : tVir Arg ListeArgs
		  | /* epsilon */
		  
Arg : tInt tId
		 { 	ajoutElement($2, "param" ,0 ,indiceProfondeur+1);
		 } 

Body : tAo 
		{	printTabFonction();
			indiceProfondeur ++ ;
		} 
	ListeInstr 
		{	suprProfondeur(indiceProfondeur) ; 
			indiceProfondeur -- ;	
		}
	 tAf

ListeInstr : Instr ListeInstr 
	          | /*epsilon */
	          
Instr : Decl | If | While | Affect | Invoc tPv | Ret

Ret : tReturn Expr tPv
		{	ajoutInstru("LOAD-ret", 0, $2);
			suprLastElement();
		}
/*On stocke la valeur de l'adresse de retour avant de rentrer les parametres pour etres cohérents dans notre pile*/
Invoc :	tId
		{	
			ajoutInstru("LOAD",3,getCompt());
	 		int adr = ajoutElement("@retour_invoc", "int" ,1 ,indiceProfondeur) ;
	 		ajoutInstru("STORE",adr,3);
	 		$<nb>$ = getCompt() - 2;
    		}
    	tPo Params tPf
    		{	ajoutInstru("JMP",adrFonct($1),-100000);
    			updateRetour($<nb>2, getCompt());
    		}

Params :
	   | Param | Param tVir ParamNext
	   
ParamNext : Param
		  | Param tVir ParamNext
		
		  
Param : Expr

If : tIf tPo Expr tPf {if_ass($3);} Body Else 
   
Else : /* epsilon */ {	print_test_cond();
			changeInstrIf();
		     }
	| {changeInstrIfElse();
	   ajoutInstru("JMP",55555,-100000);
	   } 
	   tElse Body 
	   	{print_test_cond();
	   	 changeInstrIf();
	   	}
	
While : tWhile {addWhile();} tPo Expr tPf {if_ass($4);}Body {changeInstrIfElse();ajoutInstruWhile();}

Affect : tId tEq Expr tPv
 	{ 	
 		ajoutInstru("LOAD",3,$3);
 		ajoutInstru("STORE",rechercheElement($1),3);
    		suprLastElement() ;
	}
	
Expr :     Expr tPlus Expr
		{	$$ = add_arith("ADD", $1,$3);
		}
	 | tNot Expr
		{	ajoutInstru("LOAD",0,$2);
    			ajoutInstru("NOT",0,-10000);
    			ajoutInstru("STORE",$2,0);
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
	 	ajoutInstru("AFC",3,$1);
	 	int adr = ajoutElement("tmp", "int" ,0 ,indiceProfondeur) ;
	 	ajoutInstru("STORE",adr,3);
    		$$ = adr;
    		//printTab() ;
	 } 
	 | tId
	 {	
	 	if(strcmp(retourType($1),"param")){ 	
	 		printf("recherche de '%s'\n", $1);
	 		ajoutInstru("LOADR",3,rechercheElement($1));
	 		int adr = ajoutElement("tmp", "int" ,0 ,indiceProfondeur) ;
    			ajoutInstru("STORE",adr,3);
    			$$ = adr;
    			//printTab() ;
    		}else{
    			printf("recherche de '%s'\n", $1);
	 		ajoutInstru("LOAD",3,rechercheElement($1));
	 		int adr = ajoutElement("tmp", "int" ,0 ,indiceProfondeur) ;
    			ajoutInstru("STORE",adr,3);
    			$$ = adr;
    			//printTab() ;
    		}
	 } 
	 | Invoc { 
	 	int adr = ajoutElement("tmp", "int" ,0 ,indiceProfondeur) ;
	 	ajoutInstru("STORE",adr,0);
	 	$$ = adr;
	 	}
	 	
	 
Decl : tInt DeclX tPv

DeclX : Decl1
	  | Decl1 tVir DeclX
	  
Decl1 : tId 
		{
			ajoutElement($1, "int" ,0 ,indiceProfondeur) ; 
			//printTab() ;
		} 
	  | tId tEq Expr
	 		 { 	
				suprLastElement() ;
	  			int adr = ajoutElement($1, "int" ,1 ,indiceProfondeur) ;
	  			//printTab() ;
	  		 }
	  




%%

int yyerror(char *s) {
  printf("%s\n",s);
}

int main(void) {

fichier = fopen("assembleur.ass", "w");
  yyparse();
  afficherTab(fichier);
  fclose(fichier);
}
