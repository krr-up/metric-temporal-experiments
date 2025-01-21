%========
% The syntax is restricted to the one of the LPNMR paper
% with only next in the head
%========

%----------
% Domain
%----------
item(icard). item(cash).
loc(dentist). loc(office). loc(atm). loc(home).

#const size = 1.
distance(dentist,home,20*size).
distance(dentist,office,30*size).
distance(dentist,atm,40*size).
distance(home,office,15*size).
distance(home,atm,15*size).
distance(office,atm,20*size).
distance(Y,X,D):-distance(X,Y,D).

%----------
% Program
%----------

% Initial
at(ram,office):-initially.
at(cash,atm):-initially.
at(icard,home):-initially.

% Action
go(ram,L') : loc(L'), L'!=L :- at(ram,L), not finally.

% Fulents
has(ram,I) :- at(ram,L), at(I,L), item(I).
at(ram,L) :- at(ram,L), has(ram,I).

% Effects
next((D,D+1),at(ram,L')) :- at(ram,L), go(ram,L'), distance(L,L',D).

% Innertia
next((0,w),has(ram,I)) :- has(ram,I), not finally.
next((0,w),at(I,L)) :- at(I,L), item(I), not has(_,I), not finally.


#external initially.
#external finally.
#external at(ram,L): loc(L).
#external at(I,L): item(I), loc(L).
#external has(ram,I): item(I).

#show show(go(P,L)):go(P,L).
