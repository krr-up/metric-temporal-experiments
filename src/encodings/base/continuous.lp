

output(eventually((X,X+1), V),auxout):-before(X,M,V).
% output(always((X,M+1),bot),auxout):-before(X,M), output(cont(_,V), _).

% That always is not external
true(cont(M,V),K):- true(always((X,M+1),bot),K), true(eventually((X,X+1), V),K), time(K), before(X,M,V).


true(always((X,M+1),bot),K):-witness(X,M,V,K).
true(eventually((X,X+1), V),K):-witness(X,M,V,K).


witness(X,M,V,K): before(X,M,V) :- true(cont(M,V),K).



before(0..M,M,V) :- output(cont(M,V),B).


&diff{t(K) - t(K+1)} <= -1:- time(K), time(K+1).
