%
% Connect true/2 with hold/2
%

true(O,T) :- output(O,B), time(T), hold(L,T) : literal_tuple(B,L).
hold(L,T) :- output(O,B), time(T), true(O,T),  literal_tuple(B,L).


%
% formulas from output
%
formula(O) :- output(O,_).


%
% Logical connectives using true/2
%

%  bot
formula(bot).
:- true(bot,X).

% and
formula(A) :- formula(and(A,B)).
formula(B) :- formula(and(A,B)).
%
true(and(A,B),X) :- true(A,X), true(B,X), time(X), formula(and(A,B)).
true(A,X)            :- true(and(A,B),X), time(X), formula(and(A,B)).
true(B,X)            :- true(and(A,B),X), time(X), formula(and(A,B)).

% or
formula(A) :- formula(or(A,B)).
formula(B) :- formula(or(A,B)).
%
true(or(A,B),X)             :- true(A,X), time(X), formula(or(A,B)).
true(or(A,B),X)             :- true(B,X), time(X), formula(or(A,B)).
true(A,X) | true(B,X) :- true(or(A,B),X), time(X), formula(or(A,B)).

% if
formula(A) :- formula(if(A,B)).
formula(B) :- formula(if(A,B)).
%
true(if(A,B),X) :- true(B,X) : true(A,X); time(X), formula(if(A,B)).
true(B,X)  :- true(A,X), true(if(A,B),X), time(X), formula(if(A,B)).


%
% Temporal connectives using true/2
%

% initially
true(initially,X)  :- #false : time(Y), Y=X-1; time(X), formula(initially).
:- true(initially,X),          time(Y), Y=X-1, time(X), formula(initially).
%
% finally (replace - by + in initially)
true(finally,X)    :- #false : time(Y), Y=X+1; time(X), formula(finally).
:- true(finally,X),            time(Y), Y=X+1, time(X), formula(finally).

% next
formula(A) :- formula(next(I,A)).
% %
          :- true(next(I,A),X), not time(Y), Y=X+1, time(X), formula(next(I,A)).
selected(Y,X,next(I,A)) :- true(next(I,A),X),  time(Y), Y=X+1, time(X), formula(next(I,A)).
true(A,Y) :- selected(Y,X,next(I,A)).
in_interval(X,Y,I) :- selected(Y,X,next(I,A)).

true(next(I,A),X) :- true(A,Y),     time(Y), Y=X+1, time(X),
                in_interval(X,Y,I),
                formula(next(I,A)).

% wnext
formula(A) :- formula(wnext(I,A)).
% %
selected(Y,X,wnext(I,A)) :- true(wnext(I,A),X), time(Y), Y=X+1, time(X), formula(wnext(I,A)).
true(A,Y) :- selected(Y,X,wnext(I,A)).
in_interval(X,Y,I):- selected(Y,X,wnext(I,A)).

true(wnext(I,A),X) :- true(A,Y),     time(Y), Y=X+1, time(X),
                in_interval(X,Y,I),
                formula(wnext(I,A)).


% until
formula(A) :- formula(until(I,A,B)).
formula(B) :- formula(until(I,A,B)).
%
selected(Y,X,until(I,A,B)) : time(Y), X<=Y :- true(until(I,A,B),X), time(X), formula(until(I,A,B)).
true(until(I,A,B),X) :- selected(Y,X,until(I,A,B)).
%
true(B,Y):- selected(Y,X,until(I,A,B)).
in_interval(X,Y,I):- selected(Y,X,until(I,A,B)).
true(A,Z):- selected(Y,X,until(I,A,B)), time(Z), X<=Z, Z<Y.
selected(Y,X,until(I,A,B)):- formula(until(I,A,B)),
                                true(B,Y),
                                time(X), time(Y),
                                in_interval(X,Y,I),
                                true(A,Z) : time(Z), X<=Z, Z<Y.

% eventually
formula(until(I,top,A)) :- formula(eventually(I,A)).
true(until(I,top,A),T) :- true(eventually(I,A),T), time(T).
true(eventually(I,A),T) :- true(until(I,top,A),T), time(T).

% release
formula(A) :- formula(release(I,A,B)).
formula(B) :- formula(release(I,A,B)).
%
selected(Y,X,release(I,A,B)) :- true(release(I,A,B),X),
                                time(Y), X<=Y,
                                in_interval(X,Y,I).
true(release(I,A,B),X) :- selected(Y,X,release(I,A,B)):
                                time(Y), X<=Y,
                                in_interval(X,Y,I);
                                time(X), formula(release(I,A,B)).
%
true(B,Y) | true(A,Z): time(Z), X<=Z, Z<Y :- selected(Y,X,release(I,A,B)).
selected(Y,X,release(I,A,B)):- formula(release(I,A,B)), time(X), time(Y), X<=Y, in_interval(X,Y,I),
                                true(B,Y).
selected(Y,X,release(I,A,B)):- formula(release(I,A,B)), time(X), time(Y), X<=Y, in_interval(X,Y,I),
                                time(Z),  X<=Z, Z<Y, true(A,Z).


% always
formula(release(I,bot,A)) :- formula(always(I,A)).
true(release(I,bot,A),T) :- true(always(I,A),T), time(T).
true(always(I,A),T) :- true(release(I,bot,A),T), time(T).

