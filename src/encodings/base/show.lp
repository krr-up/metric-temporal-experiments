% Shown atoms
no_show :- not true(_show(_),_).
_show(S,T):-true(S,T), true(_show(S),T).
_show(S,T):-true(S,T), true(_show,T).
_show(S,T):- no_show, true(S,T).
#show (S,T) : _show(S,T).
#show .
#show cont_______(M,V) : true(cont(M,V),K).
