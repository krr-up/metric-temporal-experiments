%
% Metric program
%
always((1,10),a) :- initially.

next((1,2),top):- not finally.

yes :- eventually((2,3),a).

#external if(initially,eventually((2,3),a)).
#external eventually((2,3),a).
#external initially.
#external finally.
#external a.