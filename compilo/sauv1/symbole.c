#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbole.h"

typedef struct {
  char * id ;
  char * type ;
  int init ;
  int profondeur ;
} symbole ;

symbole symboles[1024] ;
int compteur = 0 ;

void ajoutElement(char *id, char *type,int init ,int profondeur){
  if (compteur < 1024){
    symboles[compteur].id = id ;
    symboles[compteur].type = type ;
    symboles[compteur].init = init ;
    symboles[compteur].profondeur = profondeur ;
    compteur ++ ; 
  }else{
    fprintf(stderr, "trop de symboles\n");
    exit(2);
  }
}

void suprProfondeur(int profondeur){
  while (compteur > 0 && symboles[compteur - 1].profondeur == profondeur){
    compteur -- ;
  }
}

int rechercheElement(char * id){

  int compteurInter = compteur - 1; 

  while (strcmp(symboles[compteurInter].id, id)){
    compteurInter -- ;
    if (compteurInter == -1){
      return -1 ;
    }
  }

  return compteurInter ;
}


void suprLastElement(void) {
  if (compteur > 0){
    compteur -- ;
  }else{
    fprintf(stderr, "pas assez de symboles\n");
    exit(2);
  }
}

void printTab(void){
  int i ;
  for (i = 0; i<compteur ; i++){
    printf("id : %s\n", symboles[i].id) ;
    printf("type : %s\n", symboles[i].type) ;
    printf("init : %d\n", symboles[i].init) ;
    printf("profondeur : %d\n", symboles[i].profondeur) ;
  }

}

