
%================================================
% Bounded translation for query starting in 0
%================================================
interval(I):-output(eventually(I,V),_).

true(eventually(I,V),0) :- s(0, K, I), true(V,K), output(eventually(I,V),_).