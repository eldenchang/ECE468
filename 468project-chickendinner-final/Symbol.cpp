#include "Symbol.h"

namespace std{
	Symbol::Symbol(string* name_v, string* value_v, int type_t, int stack_p){
		name = name_v;
		value_s = value_v;
		type = type_t;
		stack_pointer = stack_p;
	}
	Symbol::~Symbol(){

	}

	string * Symbol::get_name(){
		return name;
	}
	string * Symbol::get_value(){
		return value_s;
	}
	int Symbol::get_type(){
		return type;
	}
	int Symbol::get_stack_pointer(){
		return stack_pointer;
	}
}
