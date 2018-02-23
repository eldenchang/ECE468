// the main c++ file for the compiler
// team chickendinner
#include <iostream>
#include <stdio.h>
#include <vector>
#include <map>
#include <string>
#include <set>
#include <vector>
#include "main.h"
#include "parser.hpp"
using namespace std;

// Define Global Variables
int var_ct = 0;
bool reg_only_flag = false;
std::map<string, string> var_dict;
std::map<string, string> reg_dict;
//std::vector<std::set<string>> GEN_vect;
//std::vector<std::set<string>> KILL_vect;

//extern int yyparse();
extern FILE* yyin;
//extern char* yytext;
/*
std::map<yytokentype, std::string> typeName;
std::string typeName[TOKEN_INT] = "INT";
*/
int main(int argc, char **argv)
{
	//printf("%s\n", typeName[TOKEN_INT]);
	FILE *scanfile = fopen( argv[1], "r");
	if(!scanfile)
	{
		printf("Can't open the file\n");
		return -1;
	}
	yyin = scanfile;

	int check = yyparse();

	if(check == 0)
	{
		//printf("Accepted");
	}
	//print the 3 address code
	//cout << IR_vector.size() <<endl;
	std::set<string> tempVarSet;
	for (int i = 0; i < IR_vector.size(); i++)
	{
		cout << ";";
		cout << IR_vector[i]->get_op_type();
		if(IR_vector[i]->get_op1() != ""){
			cout << " op1:" << IR_vector[i]->get_op1();
			if((IR_vector[i]->get_op1()).find('T') != std::string::npos){
				tempVarSet.insert(IR_vector[i]->get_op1());
			}
		}
		if(IR_vector[i]->get_op2() != ""){
			cout << " op2:" << IR_vector[i]->get_op2();
			if((IR_vector[i]->get_op2()).find('T') != std::string::npos){
				tempVarSet.insert(IR_vector[i]->get_op2());
			}
		}
		if(IR_vector[i]->get_result() != ""){
			cout << " result:" << IR_vector[i]->get_result();
			if((IR_vector[i]->get_result()).find('T') != std::string::npos){
				tempVarSet.insert(IR_vector[i]->get_result());
			}
		}
		cout << endl;
	}
		cout << endl;
		set<string>::iterator iter;
		for(iter=tempVarSet.begin(); iter!=tempVarSet.end();++iter) {
			cout << "var " << *iter << endl;
		}
//--------------------------Pre-Tiny code generation(for optimization)-----------------------	
		std::Tiny* optTiny = new std::Tiny(IR_vector);
		optTiny -> genTiny();

			
		
		
	return 0;
}
