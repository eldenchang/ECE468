.PHONY: team
.PHONY: clean

compiler:
	bison -d -t -o parser.cpp parser.yy
	flex scanner.ll
	g++ -w -std=c++0x -o parser.o -c parser.cpp
	g++ -w -std=c++0x -c -o scanner.o lex.yy.c
	g++ -w -std=c++0x -c -o main.o main.cpp
	g++ -w -std=c++0x -o Micro main.o scanner.o parser.o Symbol.cpp Scope.cpp ASTNode.cpp Tiny.cpp

clean:
	@rm -f *.o scanner.cpp parser.cpp lex.yy.c Micro *.out
	@echo "ALL CLEANED!"

team:
	@echo "Team: ChickenDinner"
	@echo " "
	@echo "Qifan Chang"
	@echo "eldenchang"
	@echo " "
	@echo "Zixian Lai"
	@echo "laizixian"
