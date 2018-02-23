/*
	The Scope class
*/
#ifndef SCOPE_H
#define SCOPE_H
#include <string>
#include <utility>
#include <algorithm>
#include <map>
#include <vector>
#include "Symbol.h"


namespace std{
	class Scope
	{
	private:
		string name;
	 	//std::map<Symbol*, int> ScopeTab;
	 	std::map< string, Symbol*> ScopeTab;
	 	//std::map< string* , std::pair <Symbol*, int>> ScopeTab;
	 	std::vector<std::string> err_checker;
	public:
		Scope(string name_v);
		virtual ~Scope();
		string get_name();
		//std::map<Symbol*, int> get_tab();
		std::map< string, Symbol*> get_tab();
		//std::map<string* , std::pair <Symbol*, int>> get_tab();
		void insert_record(string ,Symbol*);
		//void insert_record(string* ,Symbol*, int);

	};
}
#endif
