SRC = lexique.yy.c y.tab.c symbole.c tabl_instr.c
OBJ = $(SRC : .c=.o)
all : compilo
y.pdf : y.dot
	dot -Tpdf y.dot > y.pdf

y.tab.c y.tab.h y.dot y.output : syntaxe.y
	yacc -dvg syntaxe.y

lex.yy.c: lexique.l y.tab.h
	flex lexique.l
	
compilo : y.tab.o lex.yy.o symbole.o tabl_instr.o $(OBJ)
	gcc -g y.tab.o lex.yy.o symbole.o tabl_instr.o $(OBJ) -ll -o compilo
	
test : compilo 
	./compilo < test.c

mrproper: clean
		rm -rf compilo

