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

h(at_loc(ram,office),0).
h(at_loc(cash,atm),0).
h(at_loc(icard,home),0).

step(0..lambda-1).
%----------
% Occurs
%----------

1 { o(go_to(P,L'),S) : loc(L'), L'!=L} 1 :- h(at_loc(P,L),S), person(P), step(S+1).

%----------
% Fluents
%----------

% Automatically grab things for simplicity
h(has(P,I),S) :- h(at_loc(P,L),S), h(at_loc(I,L),S), person(P), item(I).

&sum{t(S+1); -t(S)}=D :- h(at_loc(P,L),S), o(go_to(P,L'),S), distance(L,L',D).
% If this were not exact then I need another rule for the other limit

% The (0,w) is not needed in these rules because (0,w) in (D,D+1)
h(at_loc(P,L'), S+1) :- h(at_loc(P,L),S), o(go_to(P,L'),S), distance(L,L',D).
h(at_loc(I,L),S+1) :- h(at_loc(I,L),S), item(I), not h(has(_,I),S), step(S+1).
h(has(P,I),S+1) :- h(has(P,I),S), step(S+1).

%----------
% Goal
%----------

goal(S) :- h(at_loc(ram,dentist),S), h(has(ram,icard),S), h(has(ram,cash),S).

:- goal(S), not &sum{t(S)}<=60.
:- not goal(_).
% How could we represent this if we dont have eventually?
% From the initial state you need to access the time of the state where the goal is reached, I think you need eventually for that
% :- not eventually((0,_),goal), initially. %<------- Can we can use _ for the interval? Now it needs an external so it is not really _

%----------
% Show
%----------

% _show(h(X)):-h(X).
% _show(next(I,X)):-next(I,X).
% _show(o(X)):-o(X).
% _show(goal).
% _show. %Show all

%----------
% Externals
%----------

% #external initially.
% #external finally.
% #external h(at_loc(P,L)): person(P), loc(L).
% #external h(at_loc(I,L)): item(I), loc(L).
% #external h(has(P,I)): person(P), item(I).
% #external eventually((0,100),goal).


&sum{t(0)}=0.
% The strict semantics are not needed here because no time values are left open
#show o/2.