%================================================
% Intervals HT
%================================================

interval(I):-output(next(I,V),_).

{s(K,I)}:- interval(I), time(K), K<lambda-1.

:-  &sum{t(K); -t(K+1)} <= -M, &sum{t(K+1); -t(K)} <= N-1, not s(K, (M,N)),
    interval((M,N)), N!=w, time(K+1), time(K).

:-  &sum{t(K); -t(K+1)} <= -M, not s(K, (M,w)),
    interval((M,w)), time(K+1), time(K).

:-  not &sum{t(K+1); -t(K)} <= N-1, s(K, (_,N)),
    N!=w, time(K+1), time(K).

:-  not &sum{t(K); -t(K+1)} <= -M, s(K, (M,_)), time(K+1), time(K).
