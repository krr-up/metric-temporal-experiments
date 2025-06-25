always((5,10),eat) :- initially.
tr(5,eat) :- initially.

% This formula makes the eventually founded and adds things to wrong states
% always((X,M+1),bot) :-always_witness(X,M,eat).
% eventually((X,X+1), eat) :-always_witness(X,_,eat).
% always_witness(X,5,eat):before(X,5):-tr(5,eat).

:-tr(5,eat), not always_witness(X,5,eat):before(X,5).
always_witness(X,M,eat):- always((X+1,M+1),bot), eventually((X,X+1), eat).







eventually((2,3),top) :- initially.
eventually((8,9),top) :- initially.
hungry :- eventually((2,3),eat).
hungry :- tr(2,eat).
tr(2,eat):- always((X,3),bot), eventually((X,X+1), eat).

% true(always((X,M+1),bot),K), true(eventually((X,X+1), V),K)
% hungry :- cont(4,eat).

% #external cont(4,eat).

% For each interval (M,N)
% before(0..M,M).
before(0..2,2).
before(0..5,5).


#external eventually((X,X+1),eat):before(X,_).
#external always((X+1,M+1),bot):before(X,M).

#external eventually((2,3),eat).
#external eat.
#external initially.



eventually((2,3),a) :- initially.
#external eventually((X,X+1),a):before(X,_).
#external a.
