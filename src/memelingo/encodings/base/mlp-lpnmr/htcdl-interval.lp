%================================================
% Intervals HT
%================================================

&diff{t(K) -t(K+1)} <= -M  :- true(next((M,N),V),K),
                              time(K), time(K+1).
&diff{t(K+1) -t(K)} <= N-1 :- true(next((M,N),V),K),
                              time(K), time(K+1), N!=w.