%================================================
% Intervals HT
%================================================

interval(I):-output(next(I,V),_).

{s(K,K',I)}:- interval(I), time(K), time(K'), K<K'.

:- t(K,D), t(K',D'), not s(K, K', (M,N)),
    interval((M,N)), N!=w, D + M <= D', D' < D + N, K<K'.

:-  t(K,D), t(K',D'), not s(K, K', (M,w)),
    interval((M,w)), D + M <= D', K<K'.

:-  t(K,D), t(K',D'), s(K, K', (_,N)),
    N!=w, D' >= D + N, K<K'.

:-  t(K,D), t(K',D'), s(K, K', (M,_)),
    D + M > D', K<K'.

% Keep the two arity which should be equivalent
{s(K,I)}:- interval(I), time(K), K<lambda-1.
:- s(K,K+1,I), not s(K,I).
:- not s(K,K+1,I), s(K,I).