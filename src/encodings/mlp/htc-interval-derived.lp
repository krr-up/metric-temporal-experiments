%================================================
% Intervals HT
%================================================

interval(I):-output(next(I,V),_).

%------- Intervals
s(X,(M,N)):- interval((M,N)), time(X), time(X+1),
    &sum{t(X+1); -t(X)}<N, &sum{t(X); -t(X+1)}<= -M, N!=w.
s(X,(M,w)):- interval((M,w)), time(X), time(X+1),
    &sum{t(X); -t(X+1)}<= -M.

&sum{t(X+1); -t(X)}<N :- s(X,(_,N)), N!=w.
&sum{t(X); -t(X+1)}<= -M :- s(X,(M,_)).

