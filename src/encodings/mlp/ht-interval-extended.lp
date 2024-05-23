%================================================
% Intervals HT
%================================================

interval(I):-output(next(I,V),_).

% {s(K,K',I)}:- interval(I), time(K), time(K'), K<K'.

s(K, K', (M,N)) :- t(K,D), t(K',D'),
    interval((M,N)), N!=w, D + M <= D', D' < D + N, K<K'.

s(K, K', (M,w)) :-  t(K,D), t(K',D'),
    interval((M,w)), D + M <= D', K<K'.

% Keep the two arity which should be equivalent
{s(K,I)}:- interval(I), time(K), K<lambda-1.
:- s(K,K+1,I), not s(K,I).
:- not s(K,K+1,I), s(K,I).