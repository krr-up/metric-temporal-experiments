%
% Meta-encoding using hold(A,T)
%

conjunction(B,T) :- literal_tuple(B), time(T),
        hold(L,T) : literal_tuple(B, L), L > 0;
    not hold(L,T) : literal_tuple(B,-L), L > 0.

body(normal(B),T) :- rule(_,normal(B)), conjunction(B,T), time(T).
body(sum(B,G),T)  :- rule(_,sum(B,G)), time(T),
    #sum { W,L :     hold(L,T), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : not hold(L,T), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

  hold(A,T) : atom_tuple(H,A)   :- rule(disjunction(H),B), body(B,T), time(T).
{ hold(A,T) : atom_tuple(H,A) } :- rule(     choice(H),B), body(B,T), time(T).

time(0..lambda-1).
% Time point function for a state S using clingcon
&sum{t(0)}=0 :- time(0). % Strats in 0
:- time(T), time(T'), T'>T, &sum{-t(T') ; t(T)}>0 . % Strict semantics


% Interval idea
interval(I):- formula(relase(I,_,_)).
interval(I):- formula(until(I,_,_)).
interval(I):- formula(next(I,_)).
interval(I):- formula(wnext(I,_)).

in_interval(X,Y,(M,N)):- interval((M,N)), time(X), time(Y), &sum{t(Y); -t(X)}<N, &sum{t(X); -t(Y)}<= -M.
&sum{t(Y); -t(X)}<N :- in_interval(X,Y,(M,N)).
&sum{t(X); -t(Y)}<= -M :- in_interval(X,Y,(M,N)).


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
&sum{t(Y); -t(X)}<N :- selected(Y,X,next((M,N),A)).
&sum{t(X); -t(Y)}<= -M :- selected(Y,X,next((M,N),A)).

true(next((M,N),A),X) :- true(A,Y),     time(Y), Y=X+1, time(X),
                &sum{t(Y); -t(X)}<N,
                &sum{t(X); -t(Y)}<= -M,
                formula(next((M,N),A)).

% wnext
formula(A) :- formula(wnext(I,A)).
% %
selected(Y,X,wnext(I,A)) :- true(wnext(I,A),X), time(Y), Y=X+1, time(X), formula(wnext(I,A)).
true(A,Y) :- selected(Y,X,wnext(I,A)).
&sum{t(Y); -t(X)}<N :- selected(Y,X,wnext((M,N),A)).
&sum{t(X); -t(Y)}<= -M :- selected(Y,X,wnext((M,N),A)).

true(wnext((M,N),A),X) :- true(A,Y),     time(Y), Y=X+1, time(X),
                &sum{t(Y); -t(X)}<N,
                &sum{t(X); -t(Y)}<= -M,
                formula(wnext((M,N),A)).


% until
formula(A) :- formula(until(I,A,B)).
formula(B) :- formula(until(I,A,B)).
%
selected(Y,X,until(I,A,B)) : time(Y), X<=Y :- true(until(I,A,B),X), time(X), formula(until(I,A,B)).
true(until(I,A,B),X) :- selected(Y,X,until(I,A,B)).
%
true(B,Y):- selected(Y,X,until(I,A,B)).
&sum{t(Y); -t(X)}<N:- selected(Y,X,until((M,N),A,B)).
&sum{t(X); -t(Y)}<= -M:- selected(Y,X,until((M,N),A,B)).
true(A,Z):- selected(Y,X,until((M,N),A,B)), time(Z), X<=Z, Z<Y.
selected(Y,X,until((M,N),A,B)):- formula(until((M,N),A,B)),
                                true(B,Y),
                                time(X), time(Y),
                                &sum{t(Y); -t(X)}<N, &sum{t(X); -t(Y)}<= -M,
                                true(A,Z) : time(Z), X<=Z, Z<Y.

% eventually
formula(until(I,top,A)) :- formula(eventually(I,A)).
true(until(I,top,A),T) :- true(eventually(I,A),T), time(T).
true(eventually(I,A),T) :- true(until(I,top,A),T), time(T).

% formula(A) :- formula(eventually(I,A)).
% %
% selected(Y,X,eventually(I,A)) : time(Y), X<=Y :- true(eventually(I,A),X), time(X), formula(eventually(I,A)).
% true(A,Y):- selected(Y,X,eventually(I,A)).
% &sum{t(Y); -t(X)}<N:- selected(Y,X,eventually((M,N),A)).
% &sum{t(X); -t(Y)}<= -M:- selected(Y,X,eventually((M,N),A)).

% selected(Y,X,eventually((M,N),A)):- formula(eventually((M,N),A)),
%                         time(X), time(Y), X<=Y, true(A,Y),
%                         &sum{t(Y); -t(X)}<N, &sum{t(X); -t(Y)}<= -M.

% true(eventually((M,N),A),X):-selected(Y,X,eventually((M,N),A)).

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

% % always
% formula(A) :- formula(always(I,A)).
% %
% select(Y,X,always((M,N),A))  :- true(always((M,N),A),X),
%             time(Y), X<=Y, time(X),
%             &sum{t(X) ; -t(Y)}<= -M,
%             &sum{t(Y) ; -t(X)}< N.

% true(A,Y) :-select(Y,X,always((M,N),A)).

% true(always(I,A),X) :- true(A,Y) : select(Y,X,always(I,A));
%                         time(X), formula(always(I,A)).

%
% Defined predicates
%

#defined literal_tuple/1.
#defined literal_tuple/2.
#defined rule/2.
#defined atom_tuple/2.
#defined weighted_literal_tuple/3.


% #show.
% % #show selected/3.
% #show (S,T) : true(S,T).