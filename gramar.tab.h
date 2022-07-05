/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     INT = 259,
     ASSIGN = 260,
     CLOSEP = 261,
     OPENP = 262,
     MAIOR = 263,
     MENOR = 264,
     MAIS = 265,
     MENOS = 266,
     MULT = 267,
     DIVI = 268,
     ENTRADA = 269,
     SAIDA = 270,
     FIM = 271,
     INC = 272,
     ZERA = 273,
     ENQUANTO = 274,
     FACA = 275,
     VEZES = 276,
     ENTAO = 277,
     SE = 278,
     SENAO = 279
   };
#endif
/* Tokens.  */
#define ID 258
#define INT 259
#define ASSIGN 260
#define CLOSEP 261
#define OPENP 262
#define MAIOR 263
#define MENOR 264
#define MAIS 265
#define MENOS 266
#define MULT 267
#define DIVI 268
#define ENTRADA 269
#define SAIDA 270
#define FIM 271
#define INC 272
#define ZERA 273
#define ENQUANTO 274
#define FACA 275
#define VEZES 276
#define ENTAO 277
#define SE 278
#define SENAO 279




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 37 "gramar.y"
{
  int ival;
  char *sval;
}
/* Line 1529 of yacc.c.  */
#line 102 "gramar.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

