%
% Metric program
%
a :- initially.

a :- previous((0,w),a).
b :- previous((0,w),a).

% Without this line there is no restriction and clingcon is stuck in solving without showing an answe
:- not eventually((0,10),finally), initially.

#external eventually((0,10),finally).
#external previous((0,w), a).
#external initially.
#external finally.
#external a.
#external b.