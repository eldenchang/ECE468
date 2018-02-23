#include "Tiny.h"

namespace std{
	Tiny::Tiny(std::vector<std::IR_code*> IR_vector_in){
		IR_vector = IR_vector_in;
		reg_counter = -1;
		reg_counter_str = "";
		s = "";
	}

	Tiny::~Tiny(){}

	void Tiny::genTiny(){
		int regcnt = 0;
		int curr_reg;
		std::string cmpr_val;
		std::stack<int> reg_stack;
		std::stack<int> IR_ct_stack;
		std::stack<std::string> label_stack;
//--------------------------Pre-Tiny code generation(for optimization)-----------------------
		for (int i = 0; i < IR_vector.size(); i++)
		{
			if (IR_vector[i]->get_op_type() == "STOREI" ||
				IR_vector[i]->get_op_type() == "STOREF"){
					if((IR_vector[i]->get_result()).find('!T') == std::string::npos){
						if (var_dict.find(IR_vector[i]->get_result()) != var_dict.end()){
							//creating reg_dict
							if((IR_vector[i]->get_op1()).find('!T') != std::string::npos){
								reg_dict[IR_vector[i]->get_op1()] = IR_vector[i]->get_result();
							}
							//cout << IR_vector[i]->get_op1() << " : " << reg_dict[IR_vector[i]->get_op1()] << endl;
						}
						else{
		 				   //creating var_dict
							//   "r" + std::to_string(static_cast<long long>(regcnt++));
						   var_dict[IR_vector[i]->get_result()] = IR_vector[i]->get_result();
						   if((IR_vector[i]->get_op1()).find('!T') != std::string::npos){
						   	   reg_dict[IR_vector[i]->get_op1()] = IR_vector[i]->get_result();
						   }
						   //cout << IR_vector[i]->get_op1() << " : " << reg_dict[IR_vector[i]->get_op1()] << endl;
						   //cout << IR_vector[i]->get_result() << " : " << var_dict[IR_vector[i]->get_result()] << endl;
						}
					}
				}
			else if (IR_vector[i]->get_op_type() == "READI" ||
				IR_vector[i]->get_op_type() == "READF") {
					if((IR_vector[i]->get_result()).find('!T') == std::string::npos){
						if (var_dict.find(IR_vector[i]->get_result()) == var_dict.end()){
							//var_dict[IR_vector[i]->get_result()] =
							//   "r" + std::to_string(static_cast<long long>(regcnt++));
							var_dict[IR_vector[i]->get_result()] = IR_vector[i]->get_result();
						}
					}
				}
		}
		//regcnt = 0;
//--------------------------generate tiny code-----------------------
		for (int i = 0; i < IR_vector.size(); i++)
		{

			std::IR_code* curr3ac = IR_vector[i];
			string curr_op_type = IR_vector[i] -> get_op_type();
			if( curr_op_type == "INT_DECL"){cout << "var " << IR_vector[i] -> get_op1() << endl;}
			if( curr_op_type == "FLOAT_DECL"){cout << "var " << IR_vector[i] -> get_op1() << endl;}
			if( curr_op_type == "STRING_DECL"){
				cout << "str " << IR_vector[i] -> get_op1() << " " << IR_vector[i] -> get_result() << endl;
			}

			else if( curr_op_type == "ADDI"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				cout << "addi " << curr3ac->get_op1() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "SUBI"){
				cout << "move " << curr3ac->get_op1() << " r0" << endl;
				cout << "subi " << curr3ac->get_op2() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "MULI"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				cout << "muli " << curr3ac->get_op1() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "DIVI"){
				cout << "move " << curr3ac->get_op1() << " r0" << endl;
				cout << "divi " << curr3ac->get_op2() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "ADDF"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				cout << "addr " << curr3ac->get_op1() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "SUBF"){
				cout << "move " << curr3ac->get_op1() << " r0" << endl;
				cout << "subr " << curr3ac->get_op2() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "MULF"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				cout << "mulr " << curr3ac->get_op1() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "DIVF"){
				cout << "move " << curr3ac->get_op1() << " r0" << endl;
				cout << "divr " << curr3ac->get_op2() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "LABEL"){
				if (curr3ac -> get_op1() == "main") {cout << "label " << curr3ac -> get_op1() << endl;}
				else{
					cout << "label " << curr3ac -> get_result() << endl;
					//cout << "heeere pre" << endl;
					if (i + 1< IR_vector.size()){
						if (IR_vector[i+1] -> get_op_type() == "FOR_START"){label_stack.push(curr3ac -> get_result());}
					}
					//cout << "heeere post" << endl;
				}
			}

			else if( curr_op_type == "JUMP"){
				cout << "jmp " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "FOR_START"){}

			else if( curr_op_type == "FOR_END"){
				int temp_i = i;
				i = IR_ct_stack.top();
				IR_ct_stack.pop();
				IR_ct_stack.push(temp_i);
				
			}

			else if( curr_op_type == "INCR_START"){
				IR_ct_stack.push(i);
				int j = i;
				while(IR_vector[j]->get_op_type() != "INCR_END"){j++;}
				i = j;
			}

			else if( curr_op_type == "INCR_END"){
				i = IR_ct_stack.top();
				IR_ct_stack.pop();
				cout << "jmp " << label_stack.top() << endl;
				label_stack.pop();
			}

			else if( curr_op_type == "GT"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				if (curr3ac->get_reg_counter() == 1){
					//comparing float
					cout << "cmpr " << curr3ac->get_op1() << " r0" << endl;
				}
				else if (curr3ac->get_reg_counter() == 0){
					//comparing int
					cout << "cmpi " << curr3ac->get_op1() << " r0" << endl;
				}
				cout << "jgt " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "GE"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				if (curr3ac->get_reg_counter() == 1){
					//comparing float
					cout << "cmpr " << curr3ac->get_op1() << " r0" << endl;
				}
				else if (curr3ac->get_reg_counter() == 0){
					//comparing int
					cout << "cmpi " << curr3ac->get_op1() << " r0" << endl;
				}
				cout << "jge " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "LT"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				if (curr3ac->get_reg_counter() == 1){
					//comparing float
					cout << "cmpr " << curr3ac->get_op1() << " r0" << endl;
				}
				else if (curr3ac->get_reg_counter() == 0){
					//comparing int
					cout << "cmpi " << curr3ac->get_op1() << " r0" << endl;
				}
				cout << "jlt " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "LE"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				if (curr3ac->get_reg_counter() == 1){
					//comparing float
					cout << "cmpr " << curr3ac->get_op1() << " r0" << endl;
				}
				else if (curr3ac->get_reg_counter() == 0){
					//comparing int
					cout << "cmpi " << curr3ac->get_op1() << " r0" << endl;
				}
				cout << "jle " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "EQ"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				if (curr3ac->get_reg_counter() == 1){
					//comparing float
					cout << "cmpr " << curr3ac->get_op1() << " r0" << endl;
				}
				else if (curr3ac->get_reg_counter() == 0){
					//comparing int
					cout << "cmpi " << curr3ac->get_op1() << " r0" << endl;
				}
				cout << "jeq " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "NE"){
				cout << "move " << curr3ac->get_op2() << " r0" << endl;
				if (curr3ac->get_reg_counter() == 1){
					//comparing float
					cout << "cmpr " << curr3ac->get_op1() << " r0" << endl;
				}
				else if (curr3ac->get_reg_counter() == 0){
					//comparing int
					cout << "cmpi " << curr3ac->get_op1() << " r0" << endl;
				}
				cout << "jne " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "PUSH"){
				if ( curr3ac->get_result().empty() ){
					cout << "push" << endl;
				}
				else{
					cout << "push " << curr3ac->get_result() << endl;
				}
			}

			else if( curr_op_type == "POP"){
				if ( curr3ac->get_result().empty() ){
					cout << "pop" << endl;
				}
				else{
					cout << "pop " << curr3ac->get_result() << endl;
				}
			}

			else if( curr_op_type == "PUSHREG"){
				cout << "push r0\n";
			}

			else if( curr_op_type == "POPREG"){
				cout << "pop r0\n";
			}

			else if( curr_op_type == "LINK"){
				cout << "link" << " " << curr3ac->get_op1() << endl;
			}

			else if( curr_op_type == "UNLINK"){
				cout << "unlnk" << endl;
			}

			else if( curr_op_type == "JSR"){
				cout << "jsr " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "RET"){
				cout << "ret" << endl;
			}

			else if( curr_op_type == "HALT"){
				cout << "sys halt" << endl;
			}

			else if( curr_op_type == "STOREI"){
				cout << "move " << curr3ac->get_op1() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "STOREF"){
				cout << "move " << curr3ac->get_op1() << " r0" << endl;
				cout << "move r0 " << curr3ac->get_result() << endl;
			}

			else if( curr_op_type == "READI"){
				cout << "sys readi " << IR_vector[i]->get_result() <<endl;
			}

			else if( curr_op_type == "READF"){
				cout << "sys readr " << IR_vector[i]->get_result() <<endl;
			}

			else if( curr_op_type == "WRITEI"){
				cout << "sys writei " << IR_vector[i]->get_op1() <<endl;
			}

			else if( curr_op_type == "WRITEF"){
				cout << "sys writer " << IR_vector[i]->get_op1() <<endl;
			}

			else if( curr_op_type == "WRITES"){
				cout << "sys writes " << IR_vector[i]->get_op1() <<endl;
			}

			else if (IR_vector[i+2]->get_op_type() == "GT" ||
					IR_vector[i+2]->get_op_type() == "GE" ||
					IR_vector[i+2]->get_op_type() == "LT" ||
					IR_vector[i+2]->get_op_type() == "LE" ||
					IR_vector[i+2]->get_op_type() == "NE" ||
					IR_vector[i+2]->get_op_type() == "EQ"   ){
				if ( IR_vector[i+1]->get_op_type() == "STOREI" ||
					 IR_vector[i+1]->get_op_type() == "STOREF"){i++;}
			}
		}
		cout << "sys halt" <<endl;


	}


}
