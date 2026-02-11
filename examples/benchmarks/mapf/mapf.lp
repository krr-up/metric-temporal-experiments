at(A,P) :- start(A,P), agent(A), initially.

{ move(A,U,V,D) : myedge(U,V,D)} 1 :- at(A,U), not moving(A,_,_).

% % - move ------------------------------------------------------------------
% next((0,w),at(A,V)) :- move(A,U,V,D).
always((1,D),moving(A,U,V)) :- move(A,U,V,D).
eventually((D,D+1),at(A,V)) :- move(A,U,V,D).

% % - inertia ---------------------------------------------------------------
next((0,w),at(A,V)) :- at(A,V), not move(A,_,_,_), not finally.

% % - vertex collision ------------------------------------------------------
:- at(A,V), at(A',V), vertex(V), A>A'.

% % % - edge collision --------------------------------------------------------
in_motion(A,U,V) :- move(A,U,V,D).
in_motion(A,V,U) :- moving(A,V,U).
:- in_motion(_,U,V), in_motion(_,V,U), U < V.

% % - query -----------------------------------------------------------------
:- goal(A,V), not at(A,V), finally.


#external initially.
#external finally.
#external at(A,V):agent(A), vertex(V).
#external moving(A,U,V):agent(A), vertex(U), vertex(V).

#show _show(at(A,V)):at(A,V).
#show _show(move(A,U,V,D)):move(A,U,V,D).
#show _show(moving(A,U,V)):moving(A,U,V).
