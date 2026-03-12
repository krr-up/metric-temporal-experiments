% guess moves
% { move(A,U,V,T): myedge(U,V,_) } <= 1 :- agent(A), T=1..horizon.
move(A,U,V) , not move(A,U,V) :- agent(A), myedge(U,V,D), not finally. % changed move to 0..horizon-1
:- move(A,U,V), move(A,U',V'), (U,V) != (U',V').
% or
% :- agent(A), 2 { move(A,U,V) }.

% infer agent positions
% at(A,U,0) :- start(A,U).
at(A,U) :- start(A,U), initially.
% at(A,V,T) :- move(A,U,V,T-D+1), myedge(U,V,D), T=1..horizon.
eventually((D,D+1), at(A,V)) :- move(A,U,V), myedge(U,V,D). % this requires move at 0..horizon-1
% at(A,U,T) :- at(A,U,T-1), not move(A,U,_,T), T=1..horizon.
next((0,w),at(A,U)) :- not finally, at(A,U), not move(A,U,V) : myedge(U,V,_).

% ensure path-like strolls
% :- move(A,U,_,T), not at(A,U,T-1).
:- move(A,U,V), not at(A,U).
% :- goal(A,U), not at(A,U,horizon).
:- goal(A,U), not at(A,U), finally.

% handle vertex/swap/follow conflicts
% :- { at(A,U,T) } > 1, vertex(U), T=0..horizon.
:- at(A,U), at(A',U), A > A'.
% :- move(_,U,V,T), move(_,V,U,T+S), myblock_edge(U,V,S).
% can be simplified to
% :- move(_,U,V,T), move(_,V,U,T+S), myedge(U,V,D), S=0..D-1.
% that in MEL can be represented as
% :- move(_,U,V), eventually((0,D), move(_,V,U)), myedge(U,V,D).
% :- at(A,U,T), move(B,U,V,T-S), A!=B, block_vertex(U,V,S).
% skip

% adding this
% :- not finally, not move(A,U,V) : agent(A), myedge(U,V,_).
% we obtain 1-to-1 correspondence with the Routing encoding
% where this metric encoding only has the states with moves
%
% adding this
% :- not finally, not next((1,2),#true).
% we obtain a (closer) 1-to-1 correspondence with the Routing encoding


#show _show(at(A,V)):at(A,V).
#show _show(move(A,U,V)):move(A,U,V).

#external initially.
#external finally.
#external at(A,V):agent(A), vertex(V).
% #external eventually((0,D), move(A,V,U)):agent(A), myedge(U,V,D).
