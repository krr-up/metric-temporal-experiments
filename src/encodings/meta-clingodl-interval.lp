
%================================================
%  Intervals using clingodl
%================================================

&diff{t(0)}=0 :- time(0).
:- time(T), time(T'), T'>T, &diff{t(T) -t(T')}>0 . % Strict semantics

%------- Intervals
in_interval(X,Y,(M,N)):- interval((M,N)), time(X), time(Y),
    &diff{t(Y) -t(X)}<N, &diff{t(X) -t(Y)}<= -M.

&diff{t(Y) -t(X)}<N :- in_interval(X,Y,(M,N)).
&diff{t(X) -t(Y)}<= -M :- in_interval(X,Y,(M,N)).
