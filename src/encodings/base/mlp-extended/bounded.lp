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

%--------- next
:- true(next(_,_),K), time(K), K=lambda-1.
_e(V,I,(K,K+1)) :- true(next(I,V),K).
% We only need to define this side of the implication because next is restricted to the head.

% --------- eventually
_e(V,I,(K,K')): time(K'), K<=K' :- true(eventually(I,V),K).
% We only need to define this side of the implication because eventually is restricted to the head.

% --------- Always
true(always(I,V),K) :- aux_alphabet(_u(V,I,(K,_))), _u(V,I,(K,K')):time(K'),K<=K'.
% We only need to define this side of the implication because always is restricted to the head.

%------ Definitions for e and u
%------- Auxiliary alphabet, we only need the ones for _u since the _e appears positive in the body so is safe
aux_alphabet(_u(V,I,(K,K'))):-output(always(I,V),_), time(K), time(K'), K<=K'.
aux_alphabet(_e(V,I,(K,K'))):-output(eventually(I,V),_), time(K), time(K'), K<=K'.

true(V,K'):-_e(V,I,(K,K')).
_u(V,I,(K,K')):-true(V,K'),aux_alphabet(_u(V,I,(K,K'))).


:- _e(V,I,(K,K')), _outside(I,(K,K')).
_e(V,I,(K,K')) :- true(V,K'), aux_alphabet(_e(V,I,(K,K'))), not _outside(I,(K,K')).
_u(V,I,(K,K')) :- _outside(I,(K,K')), aux_alphabet(_u(V,I,(K,K'))).
