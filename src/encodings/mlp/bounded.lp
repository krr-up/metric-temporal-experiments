
%================================================
% General meta-encoding (Used in How to build your own ASP system)
%================================================

conjunction(B,T) :- literal_tuple(B), time(T),
        hold(L,T) : literal_tuple(B, L), L > 0;
    not hold(L,T) : literal_tuple(B,-L), L > 0.

body(normal(B),T) :- rule(_,normal(B)), conjunction(B,T), time(T).
body(sum(B,G),T)  :- rule(_,sum(B,G)), time(T),
    #sum { W,L :     hold(L,T), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : not hold(L,T), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

  hold(A,T) : atom_tuple(H,A)   :- rule(disjunction(H),B), body(B,T), time(T).
{ hold(A,T) : atom_tuple(H,A) } :- rule(     choice(H),B), body(B,T), time(T).

%================================================
% Lambda
%================================================

time(0..lambda-1).

%================================================
% Bounded translation
%================================================

%--------- initially
:- true(initially,K), time(K), K!=0.
true(initially,0).

%--------- finally
:- true(finally,K), time(K), K!=lambda-1.
true(finally,lambda-1).

%--------- next is treated as different rules
:- true(next(_,_),K), time(K), K=lambda-1.
true(V,K+1) :- true(next(I,V),K).
:- true(next(I,V),K), not s(K,I).

%--------- top and bot, are not expicitly used so they are ignored

%--------- conjuction and rules are adressed in the general meta encoding above

%--------- the case for atoms is subsumed directly with the rules below

% Link formulas with solver literals
%     This is in general for all formulas (I,F,a,next(I,a))
%     Particularty, it handles the case for atoms directly

% True if the literal tuple for the output holds
true(O,T) :- output(O,B), time(T), hold(L,T) : literal_tuple(B,L).
% If a formula its true, its literal holds
hold(L,K) :- output(O,B), time(K), true(O,K),  literal_tuple(B,L).

% #show true/2.