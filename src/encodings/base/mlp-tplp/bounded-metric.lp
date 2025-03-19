%================================================
% Bounded translation
%================================================

%--------- Next
% ->
true(V,K+1) :- true(next(I,V),K), time(K), K<lambda-1.
:- true(next(_,_),K), time(K), K=lambda-1.
% <-
:- true(next(I,_),K), _outside(I,(K,K+1)), time(K), K<lambda-1.
true(next(I,V),K) :-  output(next(I,V),_), true(V,K+1), not _outside(I,(K,K+1)), _i(I), time(K), K<lambda-1.

% --------- Always
% ->
true(always(I,V),K) :- output(always(I,V),_), time(K), _witness(always(I,V),(K,J)):time(J),K<=J.
_witness(always(I,V),(K,J)) :- true(always(I,V),K), time(K), time(J), K<=J.
% <-
_witness(always(I,V),(K,J)) :- output(always(I,V),_), _outside(I,(K,J)), time(K), time(J), K<=J.
_witness(always(I,V),(K,J)) :- output(always(I,V),_), true(V,J), time(K), time(J), K<=J.
true(V,J):-_witness(always(I,V),(K,J)), not _outside(I,(K,J)), time(K), time(J), K<=J.

% --------- Eventually
% ->
_witness(eventually(I,V),(K,J)): time(J), K<=J :- true(eventually(I,V),K).
true(eventually(I,V),K):-_witness(eventually(I,V),(K,J)), time(K), time(J), K<=J.
% <-
:- true(eventually(I,_),K), _outside(I,(K,J)), time(K), time(J), K<=J.
true(V,J):-_witness(eventually(I,V),(K,J)), time(K), time(J), K<=J.
_witness(eventually(I,V),(K,J)):- output(eventually(I,V),_), true(V,J), not _outside(I,(K,J)), time(K), time(J), K<=J.
