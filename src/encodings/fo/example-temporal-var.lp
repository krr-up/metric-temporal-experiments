#script (python)
from clingo import String, SymbolType, Function

def unify(a,b):
    unified = unify_aux(a,b)
    if unified:
        return Function("true",[])
    else:
        return Function("false",[])

def unify_aux(a,b):
    reserved_words = ["_var"]
    if a.type == SymbolType.Number and b.type == SymbolType.Number:
        return a.number == b.number
    elif a.type == SymbolType.String and b.type == SymbolType.String:
        return a.string == b.string
    elif a.type == SymbolType.Function and b.type == SymbolType.Function:
        if a.name == "_var":
            return True
        if a.name == b.name and len(a.arguments) == len(b.arguments):
            arguments_unified = True
            for i in range(len(a.arguments)):
                arguments_unified = arguments_unified and unify_aux(a.arguments[i], b.arguments[i])
            return arguments_unified
        return False
    else:
        return False
    return True
#end.
% Initial program
% a(0) :- _initially.
% _next(_eventually(a(X))) :- a(X).

%
#const lambda=2.
time(0..lambda-1).

% Base translation done with renopro
h(a(1),T):- h(_initially, T), time(T).
% h(_eventually(a(X)), T):- h(a(X), T), time(T).
h(_next(_eventually(a(X))), T):- h(a(X), T), time(T).

% We need some tool to generate this because renopro has a linearized version
formula(_initially).
formula(a(_var("X"))).
formula(_eventually(a(_var("X")))).


% Satisfaction for initially
h(_initially, 0).
:- h(_initially, T), time(T), T>0.

% Satisfaction for eventually
h(X, T): time(T'), T'>=T:- h(_eventually(X), T), time(T).
h(_eventually(X), T'):- h(X, T), time(T), time(T'), T'<=T,
        formula(_eventually(Y)), @unify(Y,X)=true.

% Satisfaction for next
h(X, T+1):- h(_next(X), T), time(T), time(T+1).
h(_next(X), T):- h(X, T+1), time(T), time(T+1),
        formula(_next(Y)), @unify(Y,X)=true.

