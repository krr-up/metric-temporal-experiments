%----------
% Domain
%----------
person(ram).
item(icard). item(cash).
loc(dentist). loc(office). loc(atm). loc(home).

distance(dentist,home,20).
distance(dentist,office,30).
distance(dentist,atm,40).
distance(home,office,15).
distance(home,atm,15).
distance(office,atm,20).
distance(Y,X,D):-distance(X,Y,D).

%----------
% Initial state
%----------

h(at_loc(ram,office)):-initially.
h(at_loc(cash,atm)):-initially.
h(at_loc(icard,home)):-initially.

%----------
% Occurs
%----------

% 1 { o(go_to(P,L')) : loc(L'), L'!=L} 1 :- h(at_loc(P,L)), person(P), not finally.
{ o(go_to(P,L')) } :- h(at_loc(P,L)), person(P), not finally, loc(L'), L'!=L.
:- o(go_to(P,L')), o(go_to(P,L)), L'!=L.
:- not o(go_to(_,_)), not finally.
%----------
% Fluents
%----------

% Indirect efects
h(has(P,I)) :- h(at_loc(P,L)), h(at_loc(I,L)), person(P), item(I).
h(at_loc(P,L)) :- h(has(P,I)), h(at_loc(P,L)).

% Innertia for `has/2 predicate`. NOT EXPLICIT IN PAPER!
next((0,w),h(has(P,I))) :- h(has(P,I)), not finally.
% Innertia for `at_loc/2 predicate`. NOT EXPLICIT IN PAPER!
next((0,w),h(at_loc(I,L))) :- h(at_loc(I,L)), item(I), not h(has(_,I)), not finally.

% Effects of actions (We include the distance in this same rule) 
next((D,D+1),h(at_loc(P,L'))) :- h(at_loc(P,L)), o(go_to(P,L')), distance(L,L',D).
%   h(at_loc(P,L'),S+1)     <-    h(at_loc(P,L),S), o(go_to(P,L'),S)
%   h(at_loc(P,L'),S+1)     ->    h(at_loc(P,L),S), o(go_to(P,L'),S)
%           The second one doesn't really seam needed in this case. 
%             Whould it be needed with a next apearing in the body?



%----------
% Goal
%----------

goal :- h(at_loc(ram,dentist)), h(has(ram,icard)), h(has(ram,cash)).

% How could we represent this if we dont have eventually?
% From the initial state you need to access the time of the state where the goal is reached, I think you need eventually for that
:- not eventually((0,60),goal), initially.
% :- not eventually((0,w),goal), initially. 
% :- goal, t>60. %Might be nice to have access to the time in the current step...



%----------
% Show
%----------

_show(h(X)):-h(X).
% _show(next(I,X)):-next(I,X).
_show(o(X)):-o(X).
_show(goal).
% _show. %Show all

%----------
% Externals
%----------

#external initially.
#external finally.
#external h(at_loc(P,L)): person(P), loc(L).
#external h(at_loc(I,L)): item(I), loc(L).
#external h(has(P,I)): person(P), item(I).
#external eventually((0,60),goal).
#external eventually((0,w),goal).
