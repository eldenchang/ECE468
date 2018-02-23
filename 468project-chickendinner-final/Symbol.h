/*
	The Symbol class
*/
#ifndef SYMBOL_H
#define SYMBOL_H
#include <string>

namespace std{
	class Symbol
	{
	private:
		string * name;
		string * value_s;
		int value_i;
		float value_f;
		int type;
		int stack_pointer;
	public:
		Symbol(string* name_v, string* value_v, int type_t, int stack_p);
		virtual ~Symbol();
		string * get_name();
		string * get_value();
		int get_type();
		int get_stack_pointer();

	};
}
#endif
