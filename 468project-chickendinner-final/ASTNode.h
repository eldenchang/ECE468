/*
	The ASTNode.h
*/
#ifndef ASTNODE_H
#define ASTNODE_H
#include <string>
#include <utility>
#include <algorithm>
#include <map>
#include <vector>

namespace std{

	enum AST_Node_type
	{
		undefinded,
		operator_value,
		int_value,
		float_value,
		func_value,
		name_value
	};

	class ASTNode
	{
	private:
		AST_Node_type type;
		ASTNode* left_node;
		ASTNode* right_node;
		string id_name;
		string temp_count;

		int Operation_type;
		bool int_or_float;//int = true float = false
		string value;

	public:
		ASTNode();
		virtual ~ASTNode();
		void change_node_type(AST_Node_type n_type);
		void change_operation_type(int op_type);
		void add_name(string name_string);
		void add_value(string var_value);
		string get_name();
		string get_value();
		void add_left_child(ASTNode* left);
		void add_right_child(ASTNode* right);
		ASTNode* get_left_node();
		ASTNode* get_right_node();
		AST_Node_type get_node_type();
		int get_operation_type();
		void change_int_or_float(bool set);
		bool get_int_or_float();
		void change_temp_count(string number);
		string get_temp_count();
	};
	class IR_code
	{
	private:
		string op_type_code;
		string op1_code;
		string op2_code;
		string result_code;
		int reg_counter;
	public:
		IR_code(string op_type, string op1, string op2, string result, int counter);
		virtual ~IR_code();
		string get_op_type();
		string get_op1();
		string get_op2();
		string get_result();
		int get_reg_counter();
	};
}
#endif
