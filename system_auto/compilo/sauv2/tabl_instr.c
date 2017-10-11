#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabl_instru.h"


typedef struct {
  char * instru;
  char * val1;
  char * val2;
} instr ;

instr instructions[4096] ;
int tab_cond[1024];
int compteur_cond = 0;
int compteur_instru = 0 ;

void changeInstr(void){
	instructions[tab_cond[compteur_cond-1]].val1 = compteur_instru;
	compteur_cond --;
}

int ajoutInstru(char *instru, char *registre1, char * registre2){
  if (compteur_instru < 4096){
  if(strcmp(instru,"JMP")||strcmp(instru,"JMPC")){
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


void supprLastInstru(void){
  if (compteur_instru > 0){
    compteur_instru -- ;
  }else{
    fprintf(stderr, "pas assez de symboles\n");
    exit(2);
  }
}

void instruToString(FILE *fichier, instr entree){
	 fprintf(fichier,"%d %s %s %s \n",compteur_instru,entree.instru,entree.val1,entree.val2);
}


void afficherTab(FILE *fichier, instr *instructions){
	int i = 0;
	for(i = 0 ; i < compteur_instru ; i++){
		instruToString(fichier, instructions[i]);
	}
}

