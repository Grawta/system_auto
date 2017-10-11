/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tInt = 258,
    tId = 259,
    tPo = 260,
    tPf = 261,
    tAo = 262,
    tAf = 263,
    tVir = 264,
    tEq = 265,
    tPlus = 266,
    tLess = 267,
    tStar = 268,
    tPv = 269,
    tPipe = 270,
    tAnd = 271,
    tIf = 272,
    tElse = 273,
    tNb = 274,
    tWhile = 275,
    tReturn = 276,
    tNot = 277,
    tInf = 278,
    tSup = 279,
    tDiv = 280
  };
#endif
/* Tokens.  */
#define tInt 258
#define tId 259
#define tPo 260
#define tPf 261
#define tAo 262
#define tAf 263
#define tVir 264
#define tEq 265
#define tPlus 266
#define tLess 267
#define tStar 268
#define tPv 269
#define tPipe 270
#define tAnd 271
#define tIf 272
#define tElse 273
#define tNb 274
#define tWhile 275
#define tReturn 276
#define tNot 277
#define tInf 278
#define tSup 279
#define tDiv 280

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
