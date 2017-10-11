#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabl_instr.h"


typedef struct {
  char * instru;
  int val1;
  int val2;
} instr ;



typedef struct {
  char * nom;
  int addr;
} fonct ;


fonct fonctions[1048];
instr instructions[4096] ;
int tab_cond[1024];
int compteur_cond = 0;
int compteur_instru = 0 ;
int compteur_while = 0;
int compteur_fonction = 0;
int tab_while[1024];

void addFonction(char *fonction){
	if(compteur_fonction <1028){
		fonctions[compteur_fonction].nom = fonction;
		fonctions[compteur_fonction].addr = compteur_instru;
		compteur_fonction ++;
	}else{
   		fprintf(stderr, "trop de symboles\n");
   		exit(2);
 	}

}

void addWhile(void){
	tab_while[compteur_while] = compteur_instru;
	compteur_while ++;
}

void print_test_cond(void){
	printf("On va changer l'instru !!!!!! %d \n \n",tab_cond[compteur_cond]);
}
void changeInstrIf(void){
	instructions[tab_cond[compteur_cond-1]].val1 = compteur_instru;
	compteur_cond --;
}
void changeInstrIfElse(void){
	instructions[tab_cond[compteur_cond-1]].val1 = compteur_instru+1;
	compteur_cond --;
}
int ajoutInstruWhile(){
 if (compteur_instru < 4096){
   instructions[compteur_instru].instru = "JMP";
   instructions[compteur_instru].val1 = tab_while[compteur_while-1];
   compteur_while --;
   instructions[compteur_instru].val2 = -100000;
    compteur_instru ++ ; 
    return compteur_instru - 1;
  }else{
    fprintf(stderr, "trop de symboles\n");
    exit(2);
  }
}
int adrFonct(char * nom){
	int compteurInter = compteur_fonction - 1; 

  	while (compteurInter >= 0 && !(strcmp(fonctions[compteurInter].nom, nom))){
  	   compteurInter -- ;
	 }
	  if (compteurInter == -1) {
 	   fprintf(stderr, "symbole inexistant: '%s'\n", nom);
 	   exit(2);
	  }
  	return compteurInter ;
}
int ajoutInstru(char *instru, int registre1, int registre2){
  if (compteur_instru < 4096){
  if((strcmp(instru,"JMP")==0)||(strcmp(instru,"JMPC")==0)){
  	tab_cond[compteur_cond] = compteur_instru;
  	compteur_cond ++;
  }  
   instructions[compteur_instru].instru = instru;
   instructions[compteur_instru].val1 = registre1;
   instructions[compteur_instru].val2 = registre2;
    compteur_instru ++ ; 
    return compteur_instru - 1;
  }else{
    fprintf(stderr, "trop de symboles\n");
    exit(2);
  }
}

int getCompt(){
	return compteur_instru;
}
void supprLastInstru(void){
  if (compteur_instru > 0){
    compteur_instru -- ;
  }else{
    fprintf(stderr, "pas assez de symboles\n");
    exit(2);
  }
}


void afficherTab(FILE *fichier){
	int i = 0;
	for(i = 0 ; i < compteur_instru ; i++){
		 fprintf(fichier,"%d %s %d %d \n",i,instructions[i].instru,instructions[i].val1,instructions[i].val2);
	}
}

