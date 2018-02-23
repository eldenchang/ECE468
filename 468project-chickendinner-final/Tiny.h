/*
	The Tiny.h
*/
#ifndef TINY_H
#define TINY_H
#include <string>
#include <utility>
#include <algorithm>
#include <map>
#include <vector>
#include <stack>
#include <iostream>
#include "main.h"

namespace std{
	class Tiny{
	private:
		std::vector<std::IR_code*> IR_vector;
		std::map<string, string> var_dict;
		std::map<string, string> reg_dict;
		std::map<string, string> act_record;
		string reg_prefix;
		int reg_counter;
		string reg_counter_str;
		string s;
		size_t pos_t;
		string temp_num;
	public:
		virtual ~Tiny();
		Tiny(std::vector<std::IR_code*> IR_vector_in);
		void genTiny();
	};

}
#endif
