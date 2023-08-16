
%================================================
%  Intervals using clingcon
%================================================

&sum{t(0)}=0 :- time(0).
&sum{-t(T+1) ; t(T)}<=0:- time(T), time(T+1). % Strict semantics

%------- Intervals
in_interval(X,Y,(M,N)):- interval((M,N)), time(X), time(Y),
    &sum{t(Y); -t(X)}<N, &sum{t(X); -t(Y)}<= -M, N!=w.
in_interval(X,Y,(M,w)):- interval((M,w)), time(X), time(Y),
    &sum{t(X); -t(Y)}<= -M.

&sum{t(Y); -t(X)}<N :- in_interval(X,Y,(_,N)), N!=w.
&sum{t(X); -t(Y)}<= -M :- in_interval(X,Y,(M,_)).
