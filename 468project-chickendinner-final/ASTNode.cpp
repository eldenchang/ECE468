#include "ASTNode.h"

namespace std{
	ASTNode::ASTNode(){
		type = undefinded;
		left_node = NULL;
		right_node = NULL;
		Operation_type = 0;
		value = "";
		id_name = "";
		int_or_float = true;
		temp_count = "";
	}

	ASTNode::~ASTNode(){
	}

	void ASTNode::change_node_type(AST_Node_type n_type){
		type = n_type;
	}

	AST_Node_type ASTNode::get_node_type(){
		return type;
	}

	void ASTNode::change_operation_type(int op_type){
		Operation_type = op_type;
	}

	int ASTNode::get_operation_type(){
		return Operation_type;
	}

	void ASTNode::add_name(string name_string){
		id_name = name_string;
	}

	void ASTNode::add_value(string var_value){
		value = var_value;
	}

	string ASTNode::get_name(){
		return id_name;
	}

	string ASTNode::get_value(){
		return value;
	}

	void ASTNode::add_left_child(ASTNode* left){
		left_node = left;
	}

	void ASTNode::add_right_child(ASTNode* right){
		right_node = right;
	}

	ASTNode* ASTNode::get_left_node(){
		return left_node;
	}

	ASTNode* ASTNode::get_right_node(){
		return right_node;
	}

	void ASTNode::change_int_or_float(bool set){
		int_or_float = set;
	}

	bool ASTNode::get_int_or_float(){
		return int_or_float;
	}

	void ASTNode::change_temp_count(string number){
		temp_count = number;
	}

	string ASTNode::get_temp_count(){
		return temp_count;
	}

	IR_code::IR_code(string op_type, string op1, string op2, string result, int count){
		op_type_code = op_type;
		op1_code = op1;
		op2_code = op2;
		result_code = result;
		reg_counter = count;
	}
	IR_code::~IR_code(){

	}
	string IR_code::get_op_type(){
		return op_type_code;
	}
	string IR_code::get_op1(){
		return op1_code;
	}
	string IR_code::get_op2(){
		return op2_code;
	}
	string IR_code::get_result(){
		return result_code;
	}
	int IR_code::get_reg_counter(){
		return reg_counter;
	}


}
