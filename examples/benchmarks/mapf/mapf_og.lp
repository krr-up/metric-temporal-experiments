% #const horizon=10.
% time(A,1..horizon) :- agent(A).

horizon(A,H) :- agent(A), makespan(H).
% time(A,1..H) :- agent(A), makespan(H).
time(1..H) :-makespan(H).


at(A,P,0) :- start(A,P), agent(A).

{ move(A,U,V,T) : edge(U,V)} 1 :- agent(A), time(T).


% - move ------------------------------------------------------------------
at(A,V,T) :- move(A,_,V,T).
          :- move(A,U,_,T), not at(A,U,T-1).

% - inertia ---------------------------------------------------------------
{at(A,V,T)} :- at(A,V,T-1), time(T).

% - vertex collision ------------------------------------------------------
 :- { at(A,V,T) } > 1, vertex(V), time(T).

% % - edge collision --------------------------------------------------------
 :- move(_,U,V,T), move(_,V,U,T), U < V.

% - auxiliaries -------------------------------------------- redundant ----
:- { at(A,V,T) } != 1, agent(A), time(T).
 % - query -----------------------------------------------------------------
:- goal(A,V), not at(A,V,T), horizon(A,T).
