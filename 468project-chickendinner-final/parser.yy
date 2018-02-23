%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
	#include <vector>
	#include <utility>
	#include "main.h"
	//#include "Symbol.h"
	extern int yylex();
	extern char* yytext();
	extern int yyparse();
	extern int yylineno;
	using namespace std;

//std::string * global_name = new std::string("GLOBAL");
std::string global_name = "GLOBAL";
std::string block_name = "BLOCK";
std::string temp_name = "T";
std::string stack_sign = "$";
std::string lable_name = "label";
int block_counter = 0;
int temp_counter = -1;
int label_num = 0;
int scope_counter = 0;
int link_counter = 1;
int param_counter = 1;
int local_counter = 0;
bool in_function = false;
std::map<string, bool> func_var_map;
std::map<string, bool> func_type_map;
//int map_index = 0;


//---------------Global variables------------
	std::vector<std::Scope*> SymTabHead;
	std::vector<std::IR_code*> IR_vector;
	std::stack<int> label_counter;
	//std::ASTNode * test = new std::ASTNode();
	//------------ Local variables-------------
	std::map<Symbol*, int> newMap;
	std::map<Symbol*, int>* currMap = &newMap;
	std::vector<std::string*> scope_table;
	//----------------------------------------------


	void yyerror(char const* msg)
	{
		printf("Not accepted");
	}
%}

//%option yylineno

%token TOKEN_EOF
%token TOKEN_INTLITERAL
%token TOKEN_FLOATLITERAL

%token TOKEN_PROGRAM
%token TOKEN_BEGIN
%token TOKEN_END
%token TOKEN_FUNCTION
%token TOKEN_READ
%token TOKEN_WRITE
%token TOKEN_IF
%token TOKEN_ELSE
%token TOKEN_FI
%token TOKEN_FOR
%token TOKEN_ROF
%token TOKEN_RETURN
%token <tok_numer> TOKEN_INT
%token TOKEN_VOID
%token TOKEN_STRING
%token <tok_numer> TOKEN_FLOAT
%token TOKEN_OP_NE
%token TOKEN_OP_PLUS
%token TOKEN_OP_MINS
%token TOKEN_OP_STAR
%token TOKEN_OP_SLASH
%token TOKEN_OP_EQ
%token TOKEN_OP_NEQ
%token TOKEN_OP_LESS
%token TOKEN_OP_GREATER
%token TOKEN_OP_LP
%token TOKEN_OP_RP
%token TOKEN_OP_SEMIC
%token TOKEN_OP_COMMA
%token TOKEN_OP_LE
%token TOKEN_OP_GE

%token TOKEN_STRINGLITERAL
%token <str> TOKEN_IDENTIFIER
%start program

%union{
	std::string * str;
	int tok_numer;
	std::vector <std::string*> * svec;
	std::ASTNode* ast_node;
	std::vector <std::ASTNode*>* expr_vector;
}

%type <tok_numer> var_type compop any_type
%type <str> id str
%type <svec> id_tail id_list
%type <ast_node> primary factor_prefix postfix_expr mulop addop factor expr_prefix expr assign_expr call_expr
%type <expr_vector> expr_list_tail expr_list



%%
program:	TOKEN_PROGRAM id TOKEN_BEGIN{//add global scope
	std::Scope * globalScope = new std::Scope(global_name);
	SymTabHead.push_back(globalScope);
	//map_index = 0;
	//add start of the IR code
	std::IR_code * start_code = new std::IR_code("IR", "code", "", "", temp_counter);
	IR_vector.push_back(start_code);

}
pgm_body TOKEN_END{};

id:			TOKEN_IDENTIFIER{$$ = yylval.str;};

pgm_body:	decl{
				std::IR_code * push_code = new std::IR_code("PUSH", "", "", "", temp_counter);
				IR_vector.push_back(push_code);
				IR_vector.push_back(push_code);
				IR_vector.push_back(push_code);
				IR_vector.push_back(push_code);
				IR_vector.push_back(push_code);
				std::IR_code * main_code = new std::IR_code("JSR", "", "", "main", temp_counter);
				IR_vector.push_back(main_code);
				std::IR_code * halt_code = new std::IR_code("HALT", "", "", "", temp_counter);
				IR_vector.push_back(halt_code);

} func_declarations{};

decl:		string_decl decl{}
		|	var_decl decl{}
		|	;

string_decl:	TOKEN_STRING id TOKEN_OP_NE str TOKEN_OP_SEMIC{
	Symbol *newSym = new std::Symbol($2, $4, TOKEN_STRING, 0);
	SymTabHead.back() -> insert_record(*($2) ,newSym);
	std::IR_code * string_decl = new std::IR_code("STRING_DECL", *$2, "", *$4, temp_counter);
	if (in_function == false){
		IR_vector.push_back(string_decl);
	}
	else{
		link_counter = link_counter + 1;
	}
	func_var_map[*$2] = in_function;
	//IR_vector.push_back(string_decl);
};

str:		TOKEN_STRINGLITERAL{$$ = yylval.str;};

var_decl:	var_type id_list TOKEN_OP_SEMIC{
	std::string s_type = "";
	for(int i = $2 -> size() -1; i >= 0; i--){
		if (in_function == true)
		{
			local_counter = local_counter - 1;
		}
		std::Symbol * newSym = new std::Symbol((*$2)[i], NULL, $1, local_counter);
		cout << ";" <<  *( (*$2)[i] ) << " the local counter: " << local_counter <<endl;
		SymTabHead.back() -> insert_record(*( (*$2)[i] ) , newSym);
		func_var_map[*( (*$2)[i] )] = in_function;
		if($1 == TOKEN_INT){
			s_type = "INT_DECL";
		}
		else if($1 == TOKEN_FLOAT){
			s_type = "FLOAT_DECL";
		}
		std::IR_code * string_decl = new std::IR_code(s_type, *( (*$2)[i] ), "", "", temp_counter);
		if (in_function == false){
			IR_vector.push_back(string_decl);
		}
		else{
			link_counter = link_counter + 1;
		}
		//IR_vector.push_back(string_decl);
	}
};

var_type:	TOKEN_FLOAT{$$ = TOKEN_FLOAT;}
		|	TOKEN_INT{$$ = TOKEN_INT; };

any_type:	var_type{$$ = $1;}
		|	TOKEN_VOID{$$ = TOKEN_VOID;};

id_list:	id id_tail{
						$$ = $2; $$ -> push_back($1);
						}

id_tail:	TOKEN_OP_COMMA id id_tail{$$ = $3; $$ -> push_back($2);}
		|	{std::vector<std::string*>* temp = new std::vector<std::string*>; $$ = temp; };

param_decl_list:	param_decl param_decl_tail{}
				|	;

param_decl:	var_type id{
	std::Symbol * newSym = new std::Symbol($2, NULL, $1, ++param_counter);

	SymTabHead.back() -> insert_record(*($2) , newSym);
	func_var_map[*($2)] = in_function;

};

param_decl_tail:	TOKEN_OP_COMMA param_decl param_decl_tail{}
				|	;

func_declarations:   func_decl func_declarations{}
				|	;

func_decl:	TOKEN_FUNCTION any_type id {//add function scope
	std::Scope * funcScope = new std::Scope(*$3);
	SymTabHead.push_back(funcScope);
	//map_index = 0;
	//add label name
	std::IR_code *func_code = new std::IR_code("LABEL", "", "", *$3, temp_counter);
	IR_vector.push_back(func_code);
	in_function = true;
	if($2 == TOKEN_INT){
		func_type_map[*($3)] = true;
	}
	else{
		func_type_map[*($3)] = false;
	}
	}TOKEN_OP_LP{param_counter = 1; local_counter = 0;} param_decl_list TOKEN_OP_RP TOKEN_BEGIN func_body TOKEN_END{in_function = false;};

func_body:	{link_counter = 1;}
			decl{
				std::string link_counter_str = std::to_string(static_cast<long long>(link_counter));
				std::IR_code *link_code = new std::IR_code("LINK", link_counter_str, "", "", link_counter);
				IR_vector.push_back(link_code);
			} stmt_list{};

stmt_list:	stmt stmt_list{};
		|

stmt:		base_stmt{}
		|	if_stmt{}
		|	for_stmt{};

base_stmt:	assign_stmt{}
		|	read_stmt{}
		|	write_stmt{}
		|	return_stmt{};

assign_stmt:	assign_expr TOKEN_OP_SEMIC{/*print the 3 address code to vector*/
											if(($1->get_right_node())->get_int_or_float() == ($1->get_left_node())->get_int_or_float()){
												if(($1->get_right_node())->get_int_or_float() == true){
												//cout << "assign to int" <<endl;
													std::string temp_counter_str = std::to_string(static_cast<long long>(temp_counter));
													std::string s = temp_name + temp_counter_str;
													if(($1->get_right_node())->get_node_type() == name_value){
														s = ($1->get_right_node())->get_name();
													}
													std::IR_code * assign_int = new IR_code("STOREI", s, "", (($1->get_left_node())->get_name()), temp_counter);
													IR_vector.push_back(assign_int);
												}
												else if(($1->get_right_node())->get_int_or_float() == false){
													std::string temp_counter_str = std::to_string(static_cast<long long>(temp_counter));
													std::string s = temp_name + temp_counter_str;
													if(($1->get_right_node())->get_node_type() == name_value){
														s = ($1->get_right_node())->get_name();
													}
													std::IR_code * assign_float = new IR_code("STOREF", s, "", (($1->get_left_node())->get_name()), temp_counter);
													IR_vector.push_back(assign_float);
												}
											}
											else{
												//assign type error
											}
	};

assign_expr:	id TOKEN_OP_NE expr{
									std::ASTNode * assign_node = new ASTNode();
									assign_node->change_node_type(operator_value);
									assign_node->change_operation_type(TOKEN_OP_NE);
									//create the id node
									std::ASTNode * id_node = new ASTNode();
									id_node -> change_node_type(name_value);
									std::string s = *($1);

									//id_node -> add_name(*($1));
									//find out the type of the id by looking up the symbol table need to use for loop later
									int temp;
									if (func_var_map[*($1)])
									{
										temp = ( (SymTabHead[SymTabHead.size() - 1]->get_tab())[*($1)] -> get_type() );
										id_node -> change_int_or_float(temp == TOKEN_INT);

										int stack_num = ( (SymTabHead[SymTabHead.size() - 1]->get_tab())[s] -> get_stack_pointer() );
										std::string stack_label = std::to_string(static_cast<long long>(stack_num));
										s = stack_sign + stack_label;
										id_node -> add_name(s);
									}
									else{
										temp = ( (SymTabHead.front()->get_tab())[*($1)] -> get_type() );
										id_node -> change_int_or_float(temp == TOKEN_INT);
										id_node -> add_name(s);
									}
									//int temp = ( (SymTabHead.front()->get_tab())[*($1)] -> get_type() );
									id_node -> change_int_or_float(temp == TOKEN_INT);
									assign_node -> add_left_child(id_node);
									assign_node -> add_right_child($3);
									assign_node->change_int_or_float((temp == TOKEN_INT));

									//set the assign_expr type
									$$ = assign_node;
};

read_stmt:		TOKEN_READ TOKEN_OP_LP id_list TOKEN_OP_RP TOKEN_OP_SEMIC{
				for(int i = ($3->size()) - 1; i >= 0; --i){
					std::string s_type = "";
					//need to check the scope use loop later
					if(func_var_map[*( (*$3)[i] )]){
						if((SymTabHead[SymTabHead.size() - 1]->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_INT){
							s_type = "READI";
						}
						else if((SymTabHead[SymTabHead.size() - 1]->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_FLOAT){
							s_type = "READF";
						}
					}
					else{
						if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_INT){
							s_type = "READI";
						}
						else if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_FLOAT){
							s_type = "READF";
						}
					}
					/*if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_INT){
						s_type = "READI";
					}
					else if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_FLOAT){
						s_type = "READF";
					}*/
					std::string s = *( (*$3)[i] );
					if (func_var_map[s])
					{
						int stack_num = ( (SymTabHead[SymTabHead.size() - 1]->get_tab())[s] -> get_stack_pointer() );
						std::string stack_label = std::to_string(static_cast<long long>(stack_num));
						s = stack_sign + stack_label;
					}
					std::IR_code * read_code = new IR_code(s_type, "", "", s, temp_counter);
					IR_vector.push_back(read_code);
				}
};

write_stmt:		TOKEN_WRITE TOKEN_OP_LP id_list TOKEN_OP_RP TOKEN_OP_SEMIC{
				for(int i = ($3->size()) - 1; i >= 0; --i){
					std::string s_type = "";
					//need to check the scope use loop later
					if(func_var_map[*( (*$3)[i] )]){
						if((SymTabHead[SymTabHead.size() - 1]->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_INT){
							s_type = "WRITEI";
						}
						else if((SymTabHead[SymTabHead.size() - 1]->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_FLOAT){
							s_type = "WRITEF";
						}
						else if((SymTabHead[SymTabHead.size() - 1]->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_STRING){
							s_type = "WRITES";
						}
					}
					else{
						if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_INT){
							s_type = "WRITEI";
						}
						else if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_FLOAT){
							s_type = "WRITEF";
						}
						else if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_STRING){
							s_type = "WRITES";
						}
					}
					/*if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_INT){
						s_type = "WRITEI";
					}
					else if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_FLOAT){
						s_type = "WRITEF";
					}
					else if((SymTabHead.front()->get_tab())[*( (*$3)[i] )] -> get_type() == TOKEN_STRING){
						s_type = "WRITES";
					}*/
					std::string s = *( (*$3)[i] );
					if (func_var_map[s])
					{
						int stack_num = ( (SymTabHead[SymTabHead.size() - 1]->get_tab())[s] -> get_stack_pointer() );
						std::string stack_label = std::to_string(static_cast<long long>(stack_num));
						s = stack_sign + stack_label;
					}
					std::IR_code * write_code = new IR_code(s_type, s, "", "", temp_counter);
					IR_vector.push_back(write_code);
				}
};

return_stmt:	TOKEN_RETURN expr TOKEN_OP_SEMIC{
				//need to store the expr onto stack
				std::string return_name = "";
				std::string data_type = "";
				std::string dest = "";
				if ($2->get_node_type() == name_value){
					return_name = $2->get_name();
				}
				else{
					std::string temp_counter_str = std::to_string(static_cast<long long>(temp_counter));
					return_name = temp_name + temp_counter_str;
				}
				if ($2->get_int_or_float()){
					data_type = "STOREI";
				}
				else{
					data_type = "STOREF";
				}
				std::string param_counter_str = std::to_string(static_cast<long long>(param_counter+1));
				dest = stack_sign + param_counter_str;
				std::IR_code * ret_addr = new IR_code(data_type, return_name, "", dest, temp_counter);
				IR_vector.push_back(ret_addr);
				std::IR_code * unlink_code = new IR_code("UNLINK", "", "", "", temp_counter);
				IR_vector.push_back(unlink_code);
				std::IR_code * return_code = new IR_code("RET", "", "", "", temp_counter);
				IR_vector.push_back(return_code);
};

expr:			expr_prefix factor{
									//cout << "counting add/sub times*********" <<endl;
									if ($1 == NULL){
										$$ = $2;
										//cout << "EXPR with only facto: " << $2->get_temp_count() <<endl;
										//cout << temp_counter <<endl;
									}
									else{
											std::string s_op1 = "";
											std::string s_op2 = "" ;
											std::string s_result = "" ;
											std::string s_type = "" ;
											if($1->get_int_or_float() == $2->get_int_or_float()){
												$1 -> add_right_child($2);
												if($1->get_int_or_float()){
													//int op
													if($1->get_operation_type() == TOKEN_OP_PLUS){
														s_type = "ADDI";
													}
													else if($1->get_operation_type() == TOKEN_OP_MINS){
														s_type = "SUBI";
													}
												}
												else{
													//float op
													if($1->get_operation_type() == TOKEN_OP_PLUS){
														s_type = "ADDF";
													}
													else if($1->get_operation_type() == TOKEN_OP_MINS){
														s_type = "SUBF";
													}
												}
												//set op1
												if(($1->get_left_node())->get_node_type() == name_value){
													s_op1 = ($1->get_left_node())->get_name();
												}
												else{
													s_op1 = ($1->get_left_node())->get_temp_count();
												}
												//set op2
												if(($1->get_right_node())->get_node_type() == name_value){
													s_op2 = ($1->get_right_node())->get_name();
												}
												else{
													s_op2 = ($1->get_right_node())->get_temp_count();
												}
												std::string temp_counter_str = std::to_string(static_cast<long long>(++temp_counter));
												s_result = temp_name + temp_counter_str;
												//set the temp counter in node factor
												$1->change_temp_count(s_result);
												std::IR_code * add_code = new IR_code(s_type, s_op1, s_op2, s_result, temp_counter);
												IR_vector.push_back(add_code);
												//cout << "if factor called " << $1->get_temp_count() << endl;
										}
										else{
											//wrong type
										}
									$$ = $1;
								}
							};

expr_prefix:	expr_prefix factor addop{
											if($1 == NULL){
												$3 -> add_left_child($2);
												$3 -> change_int_or_float($2->get_int_or_float());
											}
											else{
												//$1 -> add_right_child($2);
												//$3 -> add_left_child($1);
												std::string s_op1 = "";
												std::string s_op2 = "" ;
												std::string s_result = "" ;
												std::string s_type = "" ;
												if($1->get_int_or_float() == $2->get_int_or_float()){
														$1 -> add_right_child($2);
														$3 -> add_left_child($1);
														$3 -> change_int_or_float($1->get_int_or_float());

														if($1->get_int_or_float()){
															//int op
															if($1->get_operation_type() == TOKEN_OP_PLUS){
																s_type = "ADDI";
															}
															else if($1->get_operation_type() == TOKEN_OP_MINS){
																s_type = "SUBI";
															}
														}
														else{
															//float op
															if($1->get_operation_type() == TOKEN_OP_PLUS){
																s_type = "ADDF";
															}
															else if($1->get_operation_type() == TOKEN_OP_MINS){
																s_type = "SUBF";
															}
														}

														if(($1->get_left_node())->get_node_type() == name_value){
															s_op1 = ($1->get_left_node())->get_name();
														}
														else{
															s_op1 = ($1->get_left_node())->get_temp_count();
															//cout << "test factor_prefix op1 " << s_type << " temp: " << s_op1 <<endl;
														}
														if(($1->get_right_node())->get_node_type() == name_value){
															s_op2 = ($1->get_right_node())->get_name();
														}
														else{
															s_op2 = ($1->get_right_node())->get_temp_count();
															//cout << "test factor_prefix op2 " << s_type << " temp: " << s_op2 <<endl;
														}
														std::string temp_counter_str = std::to_string(static_cast<long long>(++temp_counter));
														s_result = temp_name + temp_counter_str;
														//set the temp counter in node factor
														$1->change_temp_count(s_result);
														std::IR_code * add_code = new IR_code(s_type, s_op1, s_op2, s_result, temp_counter);
														IR_vector.push_back(add_code);

												}
												else{
													//return error cant add int with float
													//cout << "this is causing error-----------" <<endl;
													//cout << "buggggggggggggggggggggggggggggggg" <<endl;
												}
											}
											$$ = $3;
										}
			|	{$$ = NULL;};

factor:			factor_prefix postfix_expr{
											if ($1 == NULL){
												$$ = $2;
											}
											else{
												std::string s_op1 = "";
												std::string s_op2 = "" ;
												std::string s_result = "" ;
												std::string s_type = "" ;
												if($1->get_int_or_float() == $2->get_int_or_float()){
													$1 -> add_right_child($2);
													if($1->get_int_or_float()){
														//int op
														if($1->get_operation_type() == TOKEN_OP_STAR){
															s_type = "MULI";
														}
														else if($1->get_operation_type() == TOKEN_OP_SLASH){
															s_type = "DIVI";
														}
													}
													else{
														//float op
														if($1->get_operation_type() == TOKEN_OP_STAR){
															s_type = "MULF";
														}
														else if($1->get_operation_type() == TOKEN_OP_SLASH){
															s_type = "DIVF";
														}
													}
													//set op1
													if(($1->get_left_node())->get_node_type() == name_value){
														s_op1 = ($1->get_left_node())->get_name();
													}
													else{
														s_op1 = ($1->get_left_node())->get_temp_count();
													}
													//set op2
													if(($1->get_right_node())->get_node_type() == name_value){
														s_op2 = ($1->get_right_node())->get_name();
													}
													else{
														s_op2 = ($1->get_right_node())->get_temp_count();
													}
													std::string temp_counter_str = std::to_string(static_cast<long long>(++temp_counter));
													s_result = temp_name + temp_counter_str;
													//set the temp counter in node factor
													$1->change_temp_count(s_result);
													std::IR_code * factor_code = new IR_code(s_type, s_op1, s_op2, s_result, temp_counter);
													IR_vector.push_back(factor_code);
													//cout << "if factor called " << $1->get_temp_count() << endl;
												}
												else{
													//wrong type
												}


												$$ = $1;
											}
										};

factor_prefix:	factor_prefix postfix_expr mulop{
												if($1 == NULL){
													$3 -> add_left_child($2);
													//set the node int_or_float type
													$3->change_int_or_float($2->get_int_or_float());

												}
												else{
													if($1->get_int_or_float() == $2->get_int_or_float()){
														$1 -> add_right_child($2);
														$3 -> add_left_child($1);
														$3 -> change_int_or_float($1->get_int_or_float());

														std::string s_op1 = "";
														std::string s_op2 = "" ;
														std::string s_result = "" ;
														std::string s_type = "" ;

														if($1->get_int_or_float()){
															//int op
															if($1->get_operation_type() == TOKEN_OP_STAR){
																s_type = "MULI";
															}
															else if($1->get_operation_type() == TOKEN_OP_SLASH){
																s_type = "DIVI";
															}
														}
														else{
															//float op
															if($1->get_operation_type() == TOKEN_OP_STAR){
																s_type = "MULF";
															}
															else if($1->get_operation_type() == TOKEN_OP_SLASH){
																s_type = "DIVF";
															}
														}

														if(($1->get_left_node())->get_node_type() == name_value){
															s_op1 = ($1->get_left_node())->get_name();
														}
														else{
															s_op1 = ($1->get_left_node())->get_temp_count();
															//cout << "test factor_prefix op1 " << s_type << " temp: " << s_op1 <<endl;
														}
														if(($1->get_right_node())->get_node_type() == name_value){
															s_op2 = ($1->get_right_node())->get_name();
														}
														else{
															s_op2 = ($1->get_right_node())->get_temp_count();
															//cout << "test factor_prefix op2 " << s_type << " temp: " << s_op2 <<endl;
														}
														std::string temp_counter_str = std::to_string(static_cast<long long>(++temp_counter));
														s_result = temp_name + temp_counter_str;
														//set the temp counter in node factor
														$1->change_temp_count(s_result);
														std::IR_code * factor_code = new IR_code(s_type, s_op1, s_op2, s_result, temp_counter);
														IR_vector.push_back(factor_code);

													}
													else{
													//	//return error cant add int with float
													}
												}
												$$ = $3;
												//try to add IR code

											}
			|	{$$ = NULL;};

postfix_expr:	primary{$$=$1;}
			|	call_expr{$$=$1;};

call_expr:		id TOKEN_OP_LP expr_list TOKEN_OP_RP{
				std::IR_code * push_code = new IR_code("PUSH", "", "", "", temp_counter);
				std::IR_code * push_reg = new IR_code("PUSHREG", "", "", "", temp_counter);
				IR_vector.push_back(push_reg);
				IR_vector.push_back(push_code);
				std::string s = "";
				for (int x = 0; x < $3->size(); x++)
				{
					if ((*$3)[x] -> get_node_type() == name_value)
					{
						s = (*$3)[x] -> get_name();
					}
					else{
						//int temp_num = (*$3)[x-1] -> get_temp_count();
						//std::string temp_counter_str = std::to_string(static_cast<long long>(temp_num));
						s = (*$3)[x] -> get_temp_count();
					}
					std::IR_code * push_para = new IR_code("PUSH", "", "", s, temp_counter);
					IR_vector.push_back(push_para);
				}
				//need to push the result of expr_list
				//
				std::IR_code * jump_func = new IR_code("JSR", "", "", *$1, temp_counter);
				IR_vector.push_back(jump_func);
				std::IR_code * pop_code = new IR_code("POP", "", "", "", temp_counter);
				std::IR_code * pop_reg = new IR_code("POPREG", "", "", "", temp_counter);

				IR_vector.push_back(pop_code);
				for (int x = 0; x < $3->size()-1; x++)
				{
					std::IR_code * pop_para = new IR_code("POP", "", "", "", temp_counter);
					IR_vector.push_back(pop_para);
				}
				std::string temp_counter_str = std::to_string(static_cast<long long>(++temp_counter));
				s = temp_name + temp_counter_str;
				std::IR_code * pop_ret = new IR_code("POP", "", "", s, temp_counter);
				IR_vector.push_back(pop_ret);
				IR_vector.push_back(pop_reg);
				//need to pop the result of function into an temp
				//and store the temp into the call_expr node with the type of the function
				std::ASTNode * caller_node = new ASTNode();
				caller_node -> change_node_type(name_value);
				caller_node -> add_name(s);
				caller_node -> change_int_or_float(func_type_map[*($1)]);
				$$ = caller_node;
};

expr_list:		expr expr_list_tail{
				//cout << $1->get_name() << "-------------" <<endl;
				//std::IR_code * push_code = new IR_code("PUSH", "", "", s, temp_counter);
				$$ = $2;
				$$ -> push_back($1);
}
			|	{std::vector<std::ASTNode*>* temp = new std::vector<std::ASTNode*>; $$ = temp;};;

expr_list_tail:	TOKEN_OP_COMMA expr expr_list_tail{/*add the expr to the expr vector*/
				$$ = $3;
				$$ -> push_back($2);
		}
			|	{std::vector<std::ASTNode*>* temp = new std::vector<std::ASTNode*>; $$ = temp;};

primary:		TOKEN_OP_LP expr TOKEN_OP_RP{$$=$2;}
			|	id{
								std::ASTNode * id_node = new ASTNode();
								id_node -> change_node_type(name_value);
								//id_node -> add_name(*($1));
								std::string s = (*($1));
								if(func_var_map[*($1)] == true){
									int stack_num = ( (SymTabHead[SymTabHead.size() - 1]->get_tab())[s] -> get_stack_pointer() );
									std::string stack_label = std::to_string(static_cast<long long>(stack_num));
									s = stack_sign + stack_label;
									id_node -> add_name(s);
									//cout << "the primary: " << *$1 <<endl;
									//cout << "the size of the scope: " << SymTabHead.size() <<endl;
									//cout << (SymTabHead[SymTabHead.size() - 1]->get_tab())[*($1)] -> get_type() <<endl;
									int temp = ( (SymTabHead[SymTabHead.size() - 1]->get_tab())[*($1)] -> get_type() );
									id_node -> change_int_or_float(temp == TOKEN_INT);
								}
								else{
									int temp = ( (SymTabHead.front()->get_tab())[*($1)] -> get_type() );
									id_node -> change_int_or_float(temp == TOKEN_INT);
									id_node -> add_name(s);
								}

								//int temp = ( (SymTabHead.front()->get_tab())[*($1)] -> get_type() );
								//id_node -> change_int_or_float(temp == TOKEN_INT);
								/*for(int sym_size = 0; sym_size < SymTabHead.size(); sym_size++){
									cout << sym_size <<endl;
									std::map< string, Symbol*>::iterator test = (SymTabHead.front()->get_tab()).find(*($1));
									cout << *($1) << endl;
									if(test == (SymTabHead.front()->get_tab()).end()){
										cout << "not found"<<endl;
									}
									else{
										cout <<"aaaaaaaaaaaaaaaaaaaaaaaaaaaaa" <<endl;
									}
									//if((SymTabHead.front()->get_tab())[*($1)])
								}*/
								$$ = id_node;
							}
			|	TOKEN_INTLITERAL{//AST node
								std::ASTNode * int_node = new ASTNode();
								int_node -> change_node_type(int_value);
								int_node -> add_value(*(yylval.str));
								int_node -> change_int_or_float(true);
								$$ = int_node;
								//try to store IR_code
								std::string temp_counter_str = std::to_string(static_cast<long long>(++temp_counter));
								std::string s = temp_name + temp_counter_str;
								std::IR_code * int_code = new IR_code("STOREI", *(yylval.str), "", s , temp_counter);
								int_node -> change_temp_count(s);
								IR_vector.push_back(int_code);
							}
			|	TOKEN_FLOATLITERAL{//AST node
									std::ASTNode * float_node = new ASTNode();
									float_node -> change_node_type(float_value);
									float_node -> add_value(*(yylval.str));
									float_node -> change_int_or_float(false);
									//cout << float_node -> get_value() << " this is f value" << endl;
									$$ = float_node;
									//try to store IR_code
									std::string temp_counter_str = std::to_string(static_cast<long long>(++temp_counter));
									std::string s = temp_name + temp_counter_str;
									std::IR_code * float_code = new IR_code("STOREF", *(yylval.str), "", s, temp_counter );
									//set the temp counter
									float_node -> change_temp_count(s);
									IR_vector.push_back(float_code);
								};

addop:			TOKEN_OP_PLUS{
								std::ASTNode * op_node = new ASTNode();
								op_node -> change_node_type(operator_value);
								op_node -> change_operation_type(TOKEN_OP_PLUS);
								$$ = op_node;
							}
			|	TOKEN_OP_MINS{
								std::ASTNode * op_node = new ASTNode();
								op_node -> change_node_type(operator_value);
								op_node -> change_operation_type(TOKEN_OP_MINS);
								$$ = op_node;
							};

mulop:			TOKEN_OP_STAR{
								std::ASTNode * op_node = new ASTNode();
								op_node -> change_node_type(operator_value);
								op_node -> change_operation_type(TOKEN_OP_STAR);
								$$ = op_node;
							}
			|	TOKEN_OP_SLASH{
								std::ASTNode * op_node = new ASTNode();
								op_node -> change_node_type(operator_value);
								op_node -> change_operation_type(TOKEN_OP_SLASH);
								$$ = op_node;
							};

if_stmt:		TOKEN_IF{//add if block
	/*std::string block_counter_str = std::to_string(static_cast<long long>(++block_counter));
	std::string s = block_name + " " + block_counter_str;
	std::Scope * if_blockScope = new std::Scope(s);
	SymTabHead.push_back(if_blockScope);*/
	label_num = label_num + 2;
	label_counter.push(label_num - 1);
	//map_index = 0;
} TOKEN_OP_LP cond TOKEN_OP_RP decl stmt_list{	//jump to the end of for
												std::string jump_label = std::to_string(static_cast<long long>(label_counter.top()+1));
												std::string jump_s = lable_name + jump_label;
												std::IR_code * jump_IR = new IR_code("JUMP", "", "", jump_s, temp_counter);
												IR_vector.push_back(jump_IR);
												//label for the beginning of the else
												std::string else_label = std::to_string(static_cast<long long>(label_counter.top()));
												std::string else_s = lable_name + else_label;
												std::IR_code * else_IR = new IR_code("LABEL", "", "", else_s, temp_counter);
												IR_vector.push_back(else_IR);
} else_part TOKEN_FI{
						std::string end_label = std::to_string(static_cast<long long>(label_counter.top()+1));
						std::string end_s = lable_name + end_label;
						std::IR_code * end_IR = new IR_code("LABEL", "", "", end_s, temp_counter);
						IR_vector.push_back(end_IR);
						label_counter.pop();
};

else_part:		TOKEN_ELSE{//add else block
	/*std::string block_counter_str = std::to_string(static_cast<long long>(++block_counter));
	std::string s = block_name + " " + block_counter_str;
	std::Scope * else_blockScope = new std::Scope(s);
	SymTabHead.push_back(else_blockScope);*/

} decl stmt_list{}
			|	;

cond:			expr compop expr{
									std::string compop_str = "";
									switch($2){
										case TOKEN_OP_LESS:
											compop_str = "GE";
											break;
										case TOKEN_OP_GREATER:
											compop_str = "LE";
											break;
										case TOKEN_OP_EQ:
											compop_str = "NE";
											break;
										case TOKEN_OP_NEQ:
											compop_str = "EQ";
											break;
										case TOKEN_OP_LE:
											compop_str = "GT";
											break;
										case TOKEN_OP_GE:
											compop_str = "LT";
											break;
									}
									std::string s1 = "";
									std::string s2 = "";
									int cmp_type = 0;
									if($1->get_int_or_float() == $3->get_int_or_float()){
										if($1->get_node_type() == name_value){
											s1 = $1->get_name();
											if (func_var_map[s1])
											{
												int stack_num = ( (SymTabHead[SymTabHead.size() - 1]->get_tab())[s1] -> get_stack_pointer() );
												std::string stack_label = std::to_string(static_cast<long long>(stack_num));
												s1 = stack_sign + stack_label;
											}
										}
										else{
											s1 = $1->get_temp_count();
										}
										if($3->get_node_type() == name_value){
											s2 = $3->get_name();
											if (func_var_map[s2])
											{
												int stack_num = ( (SymTabHead[SymTabHead.size() - 1]->get_tab())[s2] -> get_stack_pointer() );
												std::string stack_label = std::to_string(static_cast<long long>(stack_num));
												s2 = stack_sign + stack_label;
											}
										}
										else{
											s2 = $3->get_temp_count();
										}
										if($1->get_int_or_float() == true){
											cmp_type = 0;
										}
										else if($1->get_int_or_float() == false){
											cmp_type = 1;
										}
									}
									else{
										//compare different type data
									}
									std::string jump_label = std::to_string(static_cast<long long>(label_counter.top()));
									std::string jump_s = lable_name + jump_label;
									std::IR_code * cond_IR = new IR_code(compop_str, s1, s2, jump_s, cmp_type);
									IR_vector.push_back(cond_IR);

};

compop:			TOKEN_OP_LESS{$$ = TOKEN_OP_LESS;}
			|	TOKEN_OP_GREATER{$$ = TOKEN_OP_GREATER;}
			|	TOKEN_OP_EQ{$$ = TOKEN_OP_EQ;}
			|	TOKEN_OP_NEQ{$$ = TOKEN_OP_NEQ;}
			|	TOKEN_OP_LE{$$ = TOKEN_OP_LE;}
			|	TOKEN_OP_GE{$$ = TOKEN_OP_GE;};

init_stmt:		assign_expr{
							if(($1->get_right_node())->get_int_or_float() == ($1->get_left_node())->get_int_or_float()){
								if(($1->get_right_node())->get_int_or_float() == true){
								//cout << "assign to int" <<endl;
									std::string temp_counter_str = std::to_string(static_cast<long long>(temp_counter));
									std::string s = temp_name + temp_counter_str;
									if(($1->get_right_node())->get_node_type() == name_value){
										s = ($1->get_right_node())->get_name();
									}
									std::IR_code * assign_int = new IR_code("STOREI", s, "", (($1->get_left_node())->get_name()), temp_counter);
									IR_vector.push_back(assign_int);
								}
								else if(($1->get_right_node())->get_int_or_float() == false){
									std::string temp_counter_str = std::to_string(static_cast<long long>(temp_counter));
									std::string s = temp_name + temp_counter_str;
									if(($1->get_right_node())->get_node_type() == name_value){
										s = ($1->get_right_node())->get_name();
									}
									std::IR_code * assign_float = new IR_code("STOREF", s, "", (($1->get_left_node())->get_name()), temp_counter);
									IR_vector.push_back(assign_float);
								}
							}
							else{
								//assign type error
							}
}
			|	;

incr_stmt:		assign_expr{
							if(($1->get_right_node())->get_int_or_float() == ($1->get_left_node())->get_int_or_float()){
								if(($1->get_right_node())->get_int_or_float() == true){
								//cout << "assign to int" <<endl;
									std::string temp_counter_str = std::to_string(static_cast<long long>(temp_counter));
									std::string s = temp_name + temp_counter_str;
									if(($1->get_right_node())->get_node_type() == name_value){
										s = ($1->get_right_node())->get_name();
									}
									std::IR_code * assign_int = new IR_code("STOREI", s, "", (($1->get_left_node())->get_name()), temp_counter);
									IR_vector.push_back(assign_int);
								}
								else if(($1->get_right_node())->get_int_or_float() == false){
									std::string temp_counter_str = std::to_string(static_cast<long long>(temp_counter));
									std::string s = temp_name + temp_counter_str;
									if(($1->get_right_node())->get_node_type() == name_value){
										s = ($1->get_right_node())->get_name();
									}
									std::IR_code * assign_float = new IR_code("STOREF", s, "", (($1->get_left_node())->get_name()), temp_counter);
									IR_vector.push_back(assign_float);
								}
							}
							else{
								//assign type error
							}
}
			|	;

for_stmt:		TOKEN_FOR{//add for block
							/*std::string block_counter_str = std::to_string(static_cast<long long>(++block_counter));
							std::string s = block_name + " " + block_counter_str;
							std::Scope * for_blockScope = new std::Scope(s);
							SymTabHead.push_back(for_blockScope);*/

} TOKEN_OP_LP init_stmt TOKEN_OP_SEMIC{
										label_num = label_num + 2;
										label_counter.push(label_num);
										std::string label_counter_str = std::to_string(static_cast<long long>(label_counter.top() - 1));
										std::string label_s = lable_name + label_counter_str;
										std::IR_code * label_IR = new IR_code("LABEL", "", "", label_s, temp_counter);
										IR_vector.push_back(label_IR);
										std::IR_code * label_for = new IR_code("FOR_START", "", "", "", temp_counter);
										IR_vector.push_back(label_for);
} cond TOKEN_OP_SEMIC{/*start for the incr_stmt*/
															std::IR_code * incr = new IR_code("INCR_START", "", "", "", temp_counter);
															IR_vector.push_back(incr);
						} incr_stmt{/*end for the incr_stmt*/
									std::IR_code * jump_code = new IR_code("INCR_END", "", "", "", temp_counter);
									IR_vector.push_back(jump_code);
						} TOKEN_OP_RP decl stmt_list{/*end of the for loop*/
														std::IR_code * end_sig = new IR_code("FOR_END", "", "", "", label_counter.top());
														IR_vector.push_back(end_sig);
														std::string end_label = std::to_string(static_cast<long long>(label_counter.top()));
														std::string end_lable_s = lable_name + end_label;
														std::IR_code * end_code = new IR_code("LABEL", "", "", end_lable_s, temp_counter);
														IR_vector.push_back(end_code);
														label_counter.pop();
						} TOKEN_ROF{};


%%
