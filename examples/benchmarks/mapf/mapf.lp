at(A,V) :- start(A,V), initially.

% { move(A,U,V) : myedge(U,V,D)} 1 :- at(A,U), not moving(A,_,_).
wait(A); move(A,U,V) : myedge(U,V,D) :- at(A,U), not moving(A,_,_).

% % - move ------------------------------------------------------------------
% next((0,w),at(A,V)) :- move(A,U,V).
always((1,D),moving(A,U,V)) :- move(A,U,V), myedge(U,V,D).
always((1,D),at(A,U)) :- move(A,U,V), myedge(U,V,D).
eventually((D,D+1),at(A,V)) :- move(A,U,V), myedge(U,V,D).

next((0,w),at(A,U)) :- wait(A), at(A,U), not finally.


% % - vertex collision ------------------------------------------------------
:- at(A,V), at(A',V), vertex(V), A>A'.

% % % - edge collision --------------------------------------------------------
taken(A,U,V) :- move(A,U,V).
taken(A,V,U) :- moving(A,V,U).
:- taken(_,U,V), taken(_,V,U), U < V.

% % - query -----------------------------------------------------------------
:- goal(A,V), not at(A,V), finally.


#external initially.
#external finally.
#external at(A,V):agent(A), vertex(V).
#external moving(A,U,V):agent(A), vertex(U), vertex(V).

#show _show(at(A,V)):at(A,V).
#show _show(wait(A)):wait(A).
#show _show(move(A,U,V)):move(A,U,V).
#show _show(moving(A,U,V)):moving(A,U,V).
