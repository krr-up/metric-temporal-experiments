at(A,P) :- start(A,P), agent(A), initially.

{ move(A,U,V) : edge(U,V)} 1 :- agent(A).


% % - move ------------------------------------------------------------------
at(A,V) :- move(A,_,V).
        :- next((0,w),move(A,U,_)), not at(A,U).

% % - inertia ---------------------------------------------------------------
{next((0,w),at(A,V))} :- at(A,V), not finally.

% % - vertex collision ------------------------------------------------------
 :- at(A,V), at(A',V), vertex(V), A>A'.

% % % - edge collision --------------------------------------------------------
 :- move(_,U,V), move(_,V,U), U < V.

% % - auxiliaries -------------------------------------------- redundant ----
:- { at(A,V) } != 1, agent(A).

% % - query -----------------------------------------------------------------
:- goal(A,V), not at(A,V), finally.

% timepoint_limit(50).
% :- not eventually((0,L), finally), initially, timepoint_limit(L).
% #external eventually((0,L), finally):timepoint_limit(L).


#external initially.
#external finally.
#external next((0,w),move(A,U,V)):agent(A), edge(U,V).
#external at(A,V):agent(A), vertex(V).
