%{

#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

%}

blancs			[ \t\n]+
nombre 			[0-9]+
char    		[A-Za-z]
id     			{char}({char}|{nombre})*

%%

"if"			{printf("tIf "); return tIf;}
"else"			{printf("tElse "); return tElse;}
"while"			{printf("tWhile "); return tWhile;}
"return"		{printf("tReturn "); return tReturn;}
"int"			{printf("tInt "); return tInt;}
"const"			{printf("tConst ");}


"+"				{printf("tPlus "); return tPlus;}
"-"				{printf("tLess "); return tLess;}
"="				{printf("tEq "); return tEq;}
"*"				{printf("tStar "); return tStar;}
"/"				{printf("tDiv "); return tDiv;}

"."				{printf("tPoint ");}
","				{printf("tVir "); return tVir;}
";"				{printf("tPv "); return tPv;}

"("				{printf("tPo "); return tPo;}
")"				{printf("tPf "); return tPf;}

"{"				{printf("tAo "); return tAo;}
"}"				{printf("tAf "); return tAf;}

"["				{printf("tCo "); }
"]"				{printf("tCf "); }

"|"				{printf("tPipe "); return tPipe;}
"&"				{printf("tAnd "); return tAnd;}
"!"				{printf("tNot "); return tNot;}
"<"				{printf("tInf "); return tInf;}
">"				{printf("tSup "); return tSup;}


{blancs}  { /* On ignore */}
{nombre}   {
      //yylval=atof(yytext);
      printf("tNb ");
      return tNb ;
    }
{id} {printf("tId "); return tId;}

%%

