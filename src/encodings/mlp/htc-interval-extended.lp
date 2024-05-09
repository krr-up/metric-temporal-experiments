%================================================
% Intervals HT
%================================================

interval(I):-output(next(I,V),_).

{s(K,K',I)}:- interval(I), time(K), time(K'), K<K'.

:-  not s(K, K', (M,N)), &sum{t(K); -t(K')} <= -M, &sum{t(K'); -t(K)} <= N-1,
    interval((M,N)), N!=w, time(K), time(K'), K<K'.

:-  not s(K, K', (M,w)), &sum{t(K); -t(K')} <= -M,
    interval((M,w)), time(K), time(K'), K<K'.

:-  s(K, K', (M,N)), not &sum{t(K'); -t(K)} <= N-1,
    interval((M,N)), N!=w, time(K), time(K'), K<K'.

:-  s(K, K', (M,N)), not &sum{t(K); -t(K')} <= -M,
    interval((M,N)), time(K), time(K'), K<K'.

% Keep the two arity which should be equivalent
{s(K,I)}:- interval(I), time(K), K<lambda-1.
:- s(K,K+1,I), not s(K,I).
:- not s(K,K+1,I), s(K,I).