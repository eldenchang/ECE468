/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_PARSER_HPP_INCLUDED
# define YY_YY_PARSER_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOKEN_EOF = 258,
    TOKEN_INTLITERAL = 259,
    TOKEN_FLOATLITERAL = 260,
    TOKEN_PROGRAM = 261,
    TOKEN_BEGIN = 262,
    TOKEN_END = 263,
    TOKEN_FUNCTION = 264,
    TOKEN_READ = 265,
    TOKEN_WRITE = 266,
    TOKEN_IF = 267,
    TOKEN_ELSE = 268,
    TOKEN_FI = 269,
    TOKEN_FOR = 270,
    TOKEN_ROF = 271,
    TOKEN_RETURN = 272,
    TOKEN_INT = 273,
    TOKEN_VOID = 274,
    TOKEN_STRING = 275,
    TOKEN_FLOAT = 276,
    TOKEN_OP_NE = 277,
    TOKEN_OP_PLUS = 278,
    TOKEN_OP_MINS = 279,
    TOKEN_OP_STAR = 280,
    TOKEN_OP_SLASH = 281,
    TOKEN_OP_EQ = 282,
    TOKEN_OP_NEQ = 283,
    TOKEN_OP_LESS = 284,
    TOKEN_OP_GREATER = 285,
    TOKEN_OP_LP = 286,
    TOKEN_OP_RP = 287,
    TOKEN_OP_SEMIC = 288,
    TOKEN_OP_COMMA = 289,
    TOKEN_OP_LE = 290,
    TOKEN_OP_GE = 291,
    TOKEN_STRINGLITERAL = 292,
    TOKEN_IDENTIFIER = 293
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 94 "parser.yy" /* yacc.c:1915  */

	std::string * str;
	int tok_numer;
	std::vector <std::string*> * svec;
	std::ASTNode* ast_node;
	std::vector <std::ASTNode*>* expr_vector;

#line 101 "parser.hpp" /* yacc.c:1915  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_HPP_INCLUDED  */
