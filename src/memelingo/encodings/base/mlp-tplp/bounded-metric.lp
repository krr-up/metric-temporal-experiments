%================================================
% Bounded translation
%================================================

%--------- Next
% ->
true(V,K+1) :- true(next(I,V),K), time(K), K<lambda-1.
:- true(next(_,_),K), time(K), K=lambda-1.
:- true(next(I,_),K), outside(I,(K,K+1)), time(K), K<lambda-1.
% <-
true(next(I,V),K) :-  true(V,K+1), not outside(I,(K,K+1)), time(K), K<lambda-1,
                      output(next(I,V),_).

% --------- Always
% ->
true(always(I,V),K) :- witness(always(I,V),(K,J)) : time(J), K<=J;
                       output(always(I,V),_), time(K).
witness(always(I,V),(K,J)) :- true(always(I,V),K),
                              time(K), time(J), K<=J.
witness(always(I,V),(K,J)) :- outside(I,(K,J)), output(always(I,V),_),
                              time(K), time(J), K<=J.
witness(always(I,V),(K,J)) :- true(V,J), output(always(I,V),_),
                              time(K), time(J), K<=J.
true(V,J) :- witness(always(I,V),(K,J)), not outside(I,(K,J)),
             time(K), time(J), K<=J.

% --------- Eventually
witness(eventually(I,V),(K,J)): time(J), K<=J :- true(eventually(I,V),K).
true(eventually(I,V),K) :- witness(eventually(I,V),(K,J)),
                           time(K), time(J), K<=J.
                        :- witness(eventually(I,V),(K,J)), outside(I,(K,J)),
                           time(K), time(J), K<=J.
true(V,J):-witness(eventually(I,V),(K,J)),
           time(K), time(J), K<=J.
witness(eventually(I,V),(K,J)):- true(V,J), not outside(I,(K,J)), output(eventually(I,V),_),
                                 time(K), time(J), K<=J.
