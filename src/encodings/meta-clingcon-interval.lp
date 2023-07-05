% Time point function for a state S using clingcon
&sum{t(0)}=0 :- time(0). % Strats in 0
:- time(T), time(T'), T'>T, &sum{-t(T') ; t(T)}>0 . % Strict semantics

interval(I):- formula(relase(I,_,_)).
interval(I):- formula(until(I,_,_)).
interval(I):- formula(next(I,_)).
interval(I):- formula(wnext(I,_)).

in_interval(X,Y,(M,N)):- interval((M,N)), time(X), time(Y),
    &sum{t(Y); -t(X)}<N, &sum{t(X); -t(Y)}<= -M.
&sum{t(Y); -t(X)}<N :- in_interval(X,Y,(M,N)).
&sum{t(X); -t(Y)}<= -M :- in_interval(X,Y,(M,N)).
