%================================================
% Operators and Alphabet
% metric_formula(FORMULA,ARGUMENTS,INTERVAL)
%================================================
% Boolean
metric_formula(and(A,B),(A,B), ()):- formula(and(A,B)).
metric_formula(or(A,B),(A,B), ()):- formula(or(A,B)).
metric_formula(if(A,B),(A,B), ()):- formula(if(A,B)).
metric_formula(bot, (), ()):- formula(bot).
metric_formula(top, (), ()):- formula(top).
% Metric
metric_formula(next(I,A),(A,),I):- formula(next(I,A)).
metric_formula(previous(I,A),(A,),I):- formula(previous(I,A)).
metric_formula(release(I,A,B),(A,B),I):- formula(release(I,A,B)).
metric_formula(until(I,A,B),(A,B),I):- formula(until(I,A,B)).
metric_formula(since(I,A,B),(A,B),I):- formula(since(I,A,B)).
metric_formula(trigger(I,A,B),(A,B),I):- formula(trigger(I,A,B)).
% Derived
metric_formula(initially,(),()):- formula(initially).
metric_formula(finally,(),()):- formula(finally).
metric_formula(always(I,A),(A,),I):- formula(always(I,A)).
metric_formula(always_before(I,A),(A,),I):- formula(always_before(I,A)).
metric_formula(eventually(I,A),(A,),I):- formula(eventually(I,A)).
metric_formula(eventually_before(I,A),(A,),I):- formula(eventually_before(I,A)).
% Propositions
prop_formula(F):- formula(F), not metric_formula(F,_,_).

%================================================
% INTERVALS
%================================================
interval((M,N)):- metric_formula(_,_,(M,N)).

%================================================
% Connect true/2 with hold/2
%================================================

true(O,T) :- output(O,B), time(T), hold(L,T) : literal_tuple(B,L).
hold(L,T) :- output(O,B), time(T), true(O,T),  literal_tuple(B,L).

%================================================
% Subformulas
%================================================

formula(O) :- output(O,_).
formula(bot).
% Operators
formula(A) :-metric_formula(_,(A,),_).
formula(A) :-metric_formula(_,(A,B),_).  formula(B) :-metric_formula(_,(A,B),_).
% Derived
formula(release(I,bot,A)) :- formula(always(I,A)).
formula(trigger(I,bot,A)) :- formula(always_before(I,A)).
formula(until(I,top,A)) :- formula(eventually(I,A)).
formula(since(I,top,A)) :- formula(eventually_before(I,A)).



%================================================
% Definitions n(mu,x)
%================================================

%++++++++++++++++++++++++++++
% BOOLEAN
%++++++++++++++++++++++++++++

%---------  bot
:- true(bot,X).

%---------  top
true(top,X):- time(X).

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
selected(X,Y,next(I,A)) :- true(next(I,A),X),  time(Y), Y=X+1, time(X), formula(next(I,A)).
true(A,Y) :- selected(X,Y,next(I,A)).
in_interval(X,Y,I) :- selected(X,Y,next(I,A)).

true(next(I,A),X) :- true(A,Y),     time(Y), Y=X+1, time(X),
                in_interval(X,Y,I),
                formula(next(I,A)).

%--------- until
selected(X,Y,until(I,A,B)) : time(Y), X<=Y :- true(until(I,A,B),X), time(X), formula(until(I,A,B)).
true(until(I,A,B),X) :- selected(X,Y,until(I,A,B)).
%
true(B,Y):- selected(X,Y,until(I,A,B)).
in_interval(X,Y,I):- selected(X,Y,until(I,A,B)).
true(A,Z):- selected(X,Y,until(I,A,B)), time(Z), X<=Z, Z<Y.
selected(X,Y,until(I,A,B)):- formula(until(I,A,B)),
                                true(B,Y),
                                time(X), time(Y),
                                in_interval(X,Y,I),
                                true(A,Z) : time(Z), X<=Z, Z<Y.

%--------- release
selected(X,Y,release(I,A,B)) :- true(release(I,A,B),X),
                                time(Y), X<=Y.
true(release(I,A,B),X) :- selected(X,Y,release(I,A,B)):
                                time(Y), X<=Y;
                          time(X), formula(release(I,A,B)).
%
true(B,Y) | true(A,Z): time(Z), X<=Z, Z<Y :- selected(X,Y,release(I,A,B)), in_interval(X,Y,I).
selected(X,Y,release(I,A,B)):- formula(release(I,A,B)), time(X), time(Y), X<=Y,
                                true(B,Y).
selected(X,Y,release(I,A,B)):- formula(release(I,A,B)), time(X), time(Y), X<=Y,
                                time(Z),  X<=Z, Z<Y, true(A,Z).
selected(X,Y,release(I,A,B)):- formula(release(I,A,B)), time(X), time(Y), X<=Y,
                               not in_interval(X,Y,I).


%++++++++++++++++++++++++++++
% TEMPORAL PAST
%++++++++++++++++++++++++++++

%--------- previous
          :- true(previous(I,A),X), not time(Y), Y=X-1, time(X), formula(previous(I,A)).
selected(X,Y,previous(I,A)) :- true(previous(I,A),X),  time(Y), Y=X-1, time(X), formula(previous(I,A)).
true(A,Y) :- selected(X,Y,previous(I,A)).
in_interval(Y,X,I) :- selected(X,Y,previous(I,A)).
true(previous(I,A),X) :- true(A,Y),     time(Y), Y=X-1, time(X),
                in_interval(Y,X,I),
                formula(previous(I,A)).


%--------- since
selected(X,Y,since(I,A,B)) : time(Y), Y<=X :- true(since(I,A,B),X), time(X), formula(since(I,A,B)).
true(since(I,A,B),X) :- selected(X,Y,since(I,A,B)).
true(B,Y):- selected(X,Y,since(I,A,B)).
in_interval(Y,X,I):- selected(X,Y,since(I,A,B)).
true(A,Z):- selected(X,Y,since(I,A,B)), time(Z), Y<Z, Z<=X.
selected(X,Y,since(I,A,B)):- formula(since(I,A,B)),
                                true(B,Y),
                                time(X), time(Y),
                                in_interval(Y,X,I),
                                true(A,Z) : time(Z), Y<Z, Z<=X.

%--------- trigger
selected(X,Y,trigger(I,A,B)) :- true(trigger(I,A,B),X),
                                time(Y), Y<=X.
true(trigger(I,A,B),X) :- selected(X,Y,trigger(I,A,B)):
                                time(Y), Y<=X;
                          time(X), formula(trigger(I,A,B)).
true(B,Y) | true(A,Z): time(Z), Y<=Z, Z<X :- selected(X,Y,trigger(I,A,B)), in_interval(Y,X,I).
selected(X,Y,trigger(I,A,B)):- formula(trigger(I,A,B)), time(X), time(Y), Y<=X,
                                true(B,Y).
selected(X,Y,trigger(I,A,B)):- formula(trigger(I,A,B)), time(X), time(Y), Y<=X,
                                time(Z),  Y<=Z, Z<X, true(A,Z).
selected(X,Y,trigger(I,A,B)):- formula(trigger(I,A,B)), time(X), time(Y), Y<=X,
                               not in_interval(Y,X,I).


%++++++++++++++++++++++++++++
%  DERIVED
%++++++++++++++++++++++++++++

%--------- wnext

%--------- wprevious

%--------- always
true(release(I,bot,A),T) :- true(always(I,A),T), time(T).
true(always(I,A),T) :- true(release(I,bot,A),T), time(T).

%--------- always_before
true(trigger(I,bot,A),T) :- true(always_before(I,A),T), time(T).
true(always_before(I,A),T) :- true(trigger(I,bot,A),T), time(T).

%--------- eventually
true(until(I,top,A),T) :- true(eventually(I,A),T), time(T).
true(eventually(I,A),T) :- true(until(I,top,A),T), time(T).

%--------- eventually_before
true(since(I,top,A),T) :- true(eventually_before(I,A),T), time(T).
true(eventually_before(I,A),T) :- true(since(I,top,A),T), time(T).

