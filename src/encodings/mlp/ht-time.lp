%================================================
% Time HT
%================================================

timepoint(0..v).

t(0,0).

{t(K,D)}:- timepoint(D), time(K).
:- time(K), not t(K,D) : timepoint(D).
:- t(K,D), t(K,D'), D>D'.
% 1{t(K,D):timepoint(D)}1:- time(K). %Alternative chice to the three lines above

:- t(K,D), t(K+1,D'), D>D'.

#show t/2.


