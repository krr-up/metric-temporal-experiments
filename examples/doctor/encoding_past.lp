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
1 { o(go_to(P,L')) : loc(L'), L'!=L} 1 :- h(at_loc(P,L)), person(P), not finally.
%----------
% Fluents
%----------

% Indirect efects
h(has(P,I)) :- h(at_loc(P,L)), h(at_loc(I,L)), person(P), item(I).
h(at_loc(P,L)) :- h(has(P,I)), h(at_loc(P,L)).

% Innertia for `has/2 predicate`. NOT EXPLICIT IN PAPER!
h(has(P,I)) :- previous((0,w),h(has(P,I))).
% Innertia for `at_loc/2 predicate`. NOT EXPLICIT IN PAPER!
h(at_loc(I,L)) :- previous((0,w),h(at_loc(I,L))), item(I), not previous((0,w),h(has(_,I))).

% Effects of actions (We include the distance in this same rule) 
h(at_loc(P,L')):- previous((D,D+1),h(at_loc(P,L))), previous((D,D+1),o(go_to(P,L'))), distance(L,L',D).



%----------
% Goal
%----------

goal :- h(at_loc(ram,dentist)), h(has(ram,icard)), h(has(ram,cash)).

% How could we represent this if we dont have eventually?
% From the initial state you need to access the time of the state where the goal is reached, I think you need eventually for that

% :- not eventually((0,60),goal), initially.
% :- not eventually((0,80),finally), initially.

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
#external previous((0,w),h(has(P,I))): person(P), item(I).
#external previous((0,w),h(at_loc(P,L))): person(P), loc(L).
#external previous((0,w),h(at_loc(I,L))): item(I), loc(L).
#external previous((D,D+1),h(at_loc(P,L))): person(P), loc(L), distance(_,_,D).
#external previous((D-1,D),h(at_loc(P,L))): person(P), loc(L), distance(_,_,D).
