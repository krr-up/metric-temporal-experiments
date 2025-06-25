% #script (python)
% from clingo import String, SymbolType, Function

% def unify(a,b):
%     unified = unify_aux(a,b)
%     if unified:
%         return Function("true",[])
%     else:
%         return Function("false",[])

% def unify_aux(a,b):
%     reserved_words = ["_var"]
%     if a.type == SymbolType.Number and b.type == SymbolType.Number:
%         return a.number == b.number
%     elif a.type == SymbolType.String and b.type == SymbolType.String:
%         return a.string == b.string
%     elif a.type == SymbolType.Function and b.type == SymbolType.Function:
%         if a.name == "_var":
%             return True
%         if a.name == b.name and len(a.arguments) == len(b.arguments):
%             arguments_unified = True
%             for i in range(len(a.arguments)):
%                 arguments_unified = arguments_unified and unify_aux(a.arguments[i], b.arguments[i])
%             return arguments_unified
%         return False
%     else:
%         return False
%     return True
% #end.
% Initial program
% a(0) :- _initially.
% distance(2).
% _next((0,D)_eventually((0,w),a(X))) :- a(X), distance(D).

%
#const lambda=2.
time(0..lambda-1).

% Base translation done with renopro
h(a(1),T):- h(_initially, T), time(T).
h(distance(2),T):- time(T).
% h(_next((0,D),_eventually((0,w),a(X))), T):- h(a(X), T), h(distance(D),T), time(T).
h(_next((0,D),a(X)), T):- h(a(X), T), h(distance(D),T), time(T).

% We need some tool to generate this because renopro has a linearized version
formula(_initially).
formula(a(_var("X"))).
% This should be a formula since it is a subformula, we need to use the safty conditions defined ideally by the modality definiton.
% formula(_eventually((0,w),a(_var("X")))).
% formula(_next((0,var("D")),_eventually((0,w),a(_var("X"))))).
formula(_next((0,var("D")),a(_var("X")))).

% Satisfaction for initially
h(_initially, 0).
:- h(_initially, T), time(T), T>0.

% Satisfaction for eventually
% h(X, T): time(T'), T'>=T:- h(_eventually(I,X), T), time(T).
% h(_eventually(I,X), T'):- h(X, T), time(T), time(T'), T'<=T,
        % formula(_eventually(I',X')), @unify(X',X)=true, @unify(I',I)=true.

% Satisfaction for next
h(X, T+1):- h(_next(I,X), T), time(T), time(T+1).
% h(_next(I,X), T):- h(X, T+1), time(T), time(T+1),
%         formula(_next(I',Y)), @unify(Y,X)=true, @unify(I',I)=true.


% Time handling
&sum{t(0)} = 0 :- time(0).

&sum{t(K) ; -t(K+1)} <= -1:- time(K), time(K+1).


&sum{t(K); -t(K+1)} <= -M  :- h(_next((M,N),V),K),
                              time(K), time(K+1).
&sum{t(K+1); -t(K)} <= N-1 :- h(_next((M,N),V),K),
                              time(K), time(K+1), N!=w.


% outside((M,N),(K,K')):-
%     i((M,N)), time(K), time(K'), K<=K', &sum{t(K); -t(K')} > -M.
% outside((M,N),(K,K')):-
%     i((M,N)), time(K), time(K'), K<=K', &sum{t(K'); -t(K)} > N-1, N!=w.
% % ---------- I dont hace output
% i(I) :- output(eventually(I,V),B).
% i(I) :- output(always(I,V),B).
% i(I) :- output(next(I,V),B).
