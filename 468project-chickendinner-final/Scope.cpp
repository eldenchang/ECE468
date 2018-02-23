#include "Scope.h"
#include <iostream>

namespace std{
	Scope::Scope(string name_v){
		name = name_v;
		//static std::map<std::Symbol*, int> newMap;
		static std::vector<std::string> newVector;
		err_checker = newVector;
		static std::map< string, Symbol*> newMap;
		ScopeTab = newMap;
	}
	Scope::~Scope(){

	}

	string Scope::get_name(){
		return name;
	}
	//std::map<std::Symbol*, int>  Scope::get_tab()
	std::map< string, Symbol*> Scope::get_tab(){
		return ScopeTab;
	}
	void Scope::insert_record(string key_name, Symbol* symRecord){
		//ScopeTab.insert(std::pair<Symbol*, int>(symRecord, type));
		string sym_name = *(symRecord -> get_name());
		if (std::find(err_checker.begin(), err_checker.end(), sym_name ) != err_checker.end()){
			//printf("DECLARATION ERROR %s%x%x", sym_name, 0x0D, 0x6E);
			cout << "DECLARATION ERROR " << sym_name << "\r\n";
			exit(1);
		}
		//ScopeTab.insert(std::pair< string, Symbol*>(key_name, symRecord));
		ScopeTab[key_name] = symRecord;
		err_checker.push_back(*(symRecord -> get_name()));
	}
}
