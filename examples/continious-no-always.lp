always((5,10),eat) :- initially.
eventually((2,3),top) :- initially.
eventually((8,9),top) :- initially.
hungry :- eventually((2,3),eat).
hungry :- tr(2,eat).
tr(2,eat):- always((X,M+1),bot), eventually((X,X+1), eat).

% true(always((X,M+1),bot),K), true(eventually((X,X+1), V),K)
% hungry :- cont(4,eat).

% #external cont(4,eat).

% For each interval (M,N)
% before(0..M,M).
before(0..2,2).


#external eventually((X,X+1),eat):before(X,_).
#external always((X,M+1),bot):before(X,M).

#external eventually((2,3),eat).
#external eat.
#external initially.



eventually((2,3),a) :- initially.
#external eventually((X,X+1),a):before(X,_).
#external a.
