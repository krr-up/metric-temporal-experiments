%================================================
% Intervals HT
%================================================

interval(I):-output(next(I,V),_).

{s(K,I)}:- interval(I), time(K), K<lambda-1.

:- t(K,D), t(K+1,D'), not s(K, (M,N)),
    interval((M,N)), N!=w, D + M <= D', D' < D + N.

:-  t(K,D), t(K+1,D'), not s(K, (M,w)),
    interval((M,w)), D + M <= D'.
%     Timepoint limit is already infered in t

:-  t(K,D), t(K+1,D'), s(K, (_,N)),
    N!=w, D' >= D + N.

:-  t(K,D), t(K+1,D'), s(K, (M,_)),
    D + M > D'.

