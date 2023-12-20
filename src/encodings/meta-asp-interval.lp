
%================================================
%  Intervals using plain ASP
%================================================

% #const tplimit=100. Passed in python

timepoint(0..100).

1{t(T,TP):timepoint(TP)}1:- time(T).

t(0,0).
:- t(T,TP), t(T+1,TP'), TP>TP'.

%------- Intervals
in_interval(X,Y,(M,N)):- interval((M,N)), time(X), time(Y),
    t(X,TX), t(Y,TY),
    TY< TX+N, N!=w,
    TX<= TY - M.
in_interval(X,Y,(M,w)):- interval((M,w)), time(X), time(Y),
    t(X,TX), t(Y,TY),
    TX<= TY - M.

:- in_interval(X,Y,(_,N)),
    t(X,TX), t(Y,TY),
    TY>= TX+N, N!=w.

:- in_interval(X,Y,(M,_)),
    t(X,TX), t(Y,TY),
    TX> TY - M.