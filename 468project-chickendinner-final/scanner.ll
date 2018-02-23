%{
#include <string>
#include <vector>
#include "main.h"
#include "parser.hpp"
#include <stdio.h>
#include<iostream>

using namespace std;
%}

DIGIT	[0-9]
LETTER	[A-Za-z]
ID		{LETTER}({LETTER}|{DIGIT})*

%option noyywrap
%option yylineno

%%
PROGRAM	{return TOKEN_PROGRAM;}
BEGIN	{return TOKEN_BEGIN;}
END	{return TOKEN_END;}
FUNCTION	{return TOKEN_FUNCTION;}
READ	{return TOKEN_READ;}
WRITE	{return TOKEN_WRITE;}
IF 	{return TOKEN_IF;}
ELSE	{return TOKEN_ELSE;}
FI 	{return TOKEN_FI;}
FOR	{return TOKEN_FOR;}
ROF	{return TOKEN_ROF;}
RETURN 	{return TOKEN_RETURN;}
INT 	{yylval.str = new string(yytext); return TOKEN_INT;}
VOID	{return TOKEN_VOID;}
STRING 	{yylval.str = new string(yytext); return TOKEN_STRING;}
FLOAT {yylval.str = new string(yytext); return TOKEN_FLOAT;}

{ID}					{yylval.str = new string(yytext); return TOKEN_IDENTIFIER;}

{DIGIT}+				{yylval.str = new string(yytext); return TOKEN_INTLITERAL;}

{DIGIT}*"."{DIGIT}+		{yylval.str = new string(yytext); return TOKEN_FLOATLITERAL;}

":="	{return TOKEN_OP_NE;}
"+"	{return TOKEN_OP_PLUS;}
"-"	{return TOKEN_OP_MINS;}
"*"	{return TOKEN_OP_STAR;}
"/"	{return TOKEN_OP_SLASH;}
"="	{return TOKEN_OP_EQ;}
"!="	{return TOKEN_OP_NEQ;}
"<"	{return TOKEN_OP_LESS;}
">"	{return TOKEN_OP_GREATER;}
"("	{return TOKEN_OP_LP;}
")"	{return TOKEN_OP_RP;}
";"	{return TOKEN_OP_SEMIC;}
","	{return TOKEN_OP_COMMA;}
"<="	{return TOKEN_OP_LE;}
">=" {return TOKEN_OP_GE;}

\"([^\"\n]|\"\")*\"			{yylval.str = new string(yytext); return TOKEN_STRINGLITERAL;}
"--".*\n			{/* deleted */}
[ \t\n\r]+			{/* deleted */}



%%
