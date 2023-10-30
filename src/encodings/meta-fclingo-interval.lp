
%================================================
%  Intervals using fclingo
%================================================

&fsum{t(0)} = 0 :- time(0).
:- time(T), time(T'), T'=T+1, 
    &fsum{t(T')}=t(T'), 
    &fsum{t(T)}=t(T), 
    &fsum{-t(T') ; t(T)}>0. % Strict semantics (founded)

%------- Intervals
in_interval(X,Y,(M,N)):- interval((M,N)), time(X), time(Y),
    &fsum{t(Y); -t(X)}<N, &fsum{t(X); -t(Y)}<= -M, N!=w.
in_interval(X,Y,(M,w)):- interval((M,w)), time(X), time(Y),
    &fsum{t(X) -t(Y)}<= -M.

&fsum{t(Y); -t(X)}<N :- in_interval(X,Y,(_,N)), N!=w.
&fsum{t(X); -t(Y)}<= -M :- in_interval(X,Y,(M,_)).


% TODO:
% Maybe this could be restrictied ro X<Y????