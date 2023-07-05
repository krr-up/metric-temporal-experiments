%================================================
% INTERVALS
%================================================
interval(I):- formula(next(I,_)).
interval(I):- formula(previous(I,_)).
interval(I):- formula(relase(I,_,_)).
interval(I):- formula(until(I,_,_)).
interval(I):- formula(since(I,_,_)).
interval(I):- formula(trigger(I,_,_)).

%================================================
% Connect true/2 with hold/2
%================================================


true(O,T) :- output(O,B), time(T), hold(L,T) : literal_tuple(B,L).
hold(L,T) :- output(O,B), time(T), true(O,T),  literal_tuple(B,L).


%================================================
% Subformulas lables
%================================================

formula(O) :- output(O,_).
formula(bot).
formula(A) :- formula(and(A,B)).        formula(B) :- formula(and(A,B)).
formula(A) :- formula(or(A,B)).         formula(B) :- formula(or(A,B)).
formula(A) :- formula(if(A,B)).         formula(B) :- formula(if(A,B)).
formula(A) :- formula(next(I,A)).
formula(A) :- formula(until(I,A,B)).    formula(B) :- formula(until(I,A,B)).
formula(A) :- formula(release(I,A,B)).  formula(B) :- formula(release(I,A,B)).
formula(A) :- formula(previous(I,A)).
formula(A) :- formula(since(I,A,B)).    formula(B) :- formula(since(I,A,B)).
formula(A) :- formula(trigger(I,A,B)).  formula(B) :- formula(trigger(I,A,B)).

%================================================
% Definitions df(mu,x)
%================================================

%++++++++++++++++++++++++++++
% BOOLEAN
%++++++++++++++++++++++++++++

%---------  bot
:- true(bot,X).

%--------- and
true(and(A,B),X) :- true(A,X), true(B,X), time(X), formula(and(A,B)).
true(A,X)            :- true(and(A,B),X), time(X), formula(and(A,B)).
true(B,X)            :- true(and(A,B),X), time(X), formula(and(A,B)).

%--------- or
true(or(A,B),X)             :- true(A,X), time(X), formula(or(A,B)).
true(or(A,B),X)             :- true(B,X), time(X), formula(or(A,B)).
true(A,X) | true(B,X) :- true(or(A,B),X), time(X), formula(or(A,B)).

%--------- if
true(if(A,B),X) :- true(B,X) : true(A,X); time(X), formula(if(A,B)).
true(B,X)  :- true(A,X), true(if(A,B),X), time(X), formula(if(A,B)).

%++++++++++++++++++++++++++++
% AUXILIARY
%++++++++++++++++++++++++++++

%--------- initially
true(initially,X)  :- #false : time(Y), Y=X-1; time(X), formula(initially).
:- true(initially,X),          time(Y), Y=X-1, time(X), formula(initially).

%--------- finally
true(finally,X)    :- #false : time(Y), Y=X+1; time(X), formula(finally).
:- true(finally,X),            time(Y), Y=X+1, time(X), formula(finally).

%++++++++++++++++++++++++++++
% TEMPORAL FUTURE
%++++++++++++++++++++++++++++

%--------- next
          :- true(next(I,A),X), not time(Y), Y=X+1, time(X), formula(next(I,A)).
selected(Y,X,next(I,A)) :- true(next(I,A),X),  time(Y), Y=X+1, time(X), formula(next(I,A)).
true(A,Y) :- selected(Y,X,next(I,A)).
in_interval(X,Y,I) :- selected(Y,X,next(I,A)).

true(next(I,A),X) :- true(A,Y),     time(Y), Y=X+1, time(X),
                in_interval(X,Y,I),
                formula(next(I,A)).

%--------- until
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

%--------- release
selected(Y,X,release(I,A,B)) :- true(release(I,A,B),X),
                                time(Y), X<=Y.
true(release(I,A,B),X) :- selected(Y,X,release(I,A,B)):
                                time(Y), X<=Y;
                          time(X), formula(release(I,A,B)).
%
true(B,Y) | true(A,Z): time(Z), X<=Z, Z<Y :- selected(Y,X,release(I,A,B)), in_interval(X,Y,I).
selected(Y,X,release(I,A,B)):- formula(release(I,A,B)), time(X), time(Y), X<=Y,
                                true(B,Y).
selected(Y,X,release(I,A,B)):- formula(release(I,A,B)), time(X), time(Y), X<=Y,
                                time(Z),  X<=Z, Z<Y, true(A,Z).
selected(Y,X,release(I,A,B)):- formula(release(I,A,B)), time(X), time(Y), X<=Y,
                               not in_interval(X,Y,I).


%++++++++++++++++++++++++++++
% TEMPORAL PAST
%++++++++++++++++++++++++++++

%--------- previous
          :- true(previous(I,A),X), not time(Y), Y=X-1, time(X), formula(previous(I,A)).
selected(Y,X,previous(I,A)) :- true(previous(I,A),X),  time(Y), Y=X-1, time(X), formula(previous(I,A)).
true(A,Y) :- selected(Y,X,previous(I,A)).
in_interval(Y,X,I) :- selected(Y,X,previous(I,A)).
true(previous(I,A),X) :- true(A,Y),     time(Y), Y=X-1, time(X),
                in_interval(Y,X,I),
                formula(previous(I,A)).


%--------- since
selected(Y,X,since(I,A,B)) : time(Y), Y<=X :- true(since(I,A,B),X), time(X), formula(since(I,A,B)).
true(since(I,A,B),X) :- selected(Y,X,since(I,A,B)).
true(B,Y):- selected(Y,X,since(I,A,B)).
in_interval(Y,X,I):- selected(Y,X,since(I,A,B)).
true(A,Z):- selected(Y,X,since(I,A,B)), time(Z), Y<Z, Z<=X.
selected(Y,X,since(I,A,B)):- formula(since(I,A,B)),
                                true(B,Y),
                                time(X), time(Y),
                                in_interval(Y,X,I),
                                true(A,Z) : time(Z), Y<Z, Z<=X.

%--------- trigger
selected(Y,X,trigger(I,A,B)) :- true(trigger(I,A,B),X),
                                time(Y), Y<=X.
true(trigger(I,A,B),X) :- selected(Y,X,trigger(I,A,B)):
                                time(Y), Y<=X;
                          time(X), formula(trigger(I,A,B)).
true(B,Y) | true(A,Z): time(Z), Y<=Z, Z<X :- selected(Y,X,trigger(I,A,B)), in_interval(Y,X,I).
selected(Y,X,trigger(I,A,B)):- formula(trigger(I,A,B)), time(X), time(Y), Y<=X,
                                true(B,Y).
selected(Y,X,trigger(I,A,B)):- formula(trigger(I,A,B)), time(X), time(Y), Y<=X,
                                time(Z),  Y<=Z, Z<X, true(A,Z).
selected(Y,X,trigger(I,A,B)):- formula(trigger(I,A,B)), time(X), time(Y), Y<=X,
                               not in_interval(Y,X,I).


%++++++++++++++++++++++++++++
%  DERIVED
%++++++++++++++++++++++++++++

%--------- wnext

%--------- wprevious

%--------- always
formula(release(I,bot,A)) :- formula(always(I,A)).
true(release(I,bot,A),T) :- true(always(I,A),T), time(T).
true(always(I,A),T) :- true(release(I,bot,A),T), time(T).

%--------- always_before
formula(trigger(I,bot,A)) :- formula(always_before(I,A)).
true(trigger(I,bot,A),T) :- true(always_before(I,A),T), time(T).
true(always_before(I,A),T) :- true(trigger(I,bot,A),T), time(T).

%--------- eventually
formula(until(I,top,A)) :- formula(eventually(I,A)).
true(until(I,top,A),T) :- true(eventually(I,A),T), time(T).
true(eventually(I,A),T) :- true(until(I,top,A),T), time(T).

%--------- eventually_before
formula(since(I,top,A)) :- formula(eventually_before(I,A)).
true(since(I,top,A),T) :- true(eventually_before(I,A),T), time(T).
true(eventually_before(I,A),T) :- true(since(I,top,A),T), time(T).

