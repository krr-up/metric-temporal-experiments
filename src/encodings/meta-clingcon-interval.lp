
%================================================
%  Intervals using clingcon
%================================================

&sum{t(0)}=0 :- time(0).
:- time(T), time(T'), T'>T, &sum{-t(T') ; t(T)}>0 . % Strict semantics

%------- Intervals
in_interval(X,Y,(M,N)):- interval((M,N)), time(X), time(Y),
    &sum{t(Y); -t(X)}<N, &sum{t(X); -t(Y)}<= -M.

&sum{t(Y); -t(X)}<N :- in_interval(X,Y,(M,N)).
&sum{t(X); -t(Y)}<= -M :- in_interval(X,Y,(M,N)).
