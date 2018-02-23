#include <stdio.h>
#include <stdlib.h>
#include <list>
#include <map>
#include <utility>
#include <algorithm>
#include "Symbol.h"
#include "Scope.h"
#include "ASTNode.h"
#include "Tiny.h"

extern std::vector<std::Scope*> SymTabHead;
extern std::vector<std::IR_code*> IR_vector;
