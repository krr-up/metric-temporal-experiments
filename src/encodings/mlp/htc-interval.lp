%================================================
% Intervals HT
%================================================
interval(I):-output(next(I,V),_).

s(K, (M,N)) :- &sum{t(K); -t(K+1)} <= -M, &sum{t(K+1); -t(K)} <= N-1,
    interval((M,N)), N!=w, time(K), time(K+1).
s(K, (M,w)) :- &sum{t(K); -t(K+1)} <= -M,
    interval((M,w)), time(K), time(K+1).
