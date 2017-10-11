#define C_VARIABLE_GLOBALE 1
#define C_VARIABLE_LOCALE 2
#define C_ARGUMENT 3
#define T_ENTIER 1
#define T_TABLEAU_ENTIER 2
#define T_FONCTION 3

typedef struct
{
char * id;
char * type;
int init;
int profondeur;
} symbole;


