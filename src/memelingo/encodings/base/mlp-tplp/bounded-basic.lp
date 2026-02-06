%================================================
% Bounded translation
%================================================

% Link formulas with solver literals
%     This is in general for all formulas (I,F,a,next(I,a))
%     Particularty, it handles the case for atoms directly

% True if the literal tuple for the output holds
true(O,T) :- output(O,B), time(T), hold(L,T) : literal_tuple(B,L).
% If a formula its true, its literal holds
hold(L,K) :- output(O,B), time(K), true(O,K),  literal_tuple(B,L).

%--------- top and bot, are not expicitly used so they are ignored

%--------- conjuction and rules are adressed in the general meta encoding above

%--------- the case for atoms is subsumed directly with the first rules

%--------- initially
:- true(initially,K), time(K), K!=0.
true(initially,0).

%--------- finally
:- true(finally,K), time(K), K!=lambda-1.
true(finally,lambda-1).
