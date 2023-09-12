%
% Metric program
%
next((5,6),push) :- initially.

:- red, green.
red :- not green.
eventually((1,15),always((0,30),green)):- push.

#external eventually((20,21),green).
#external initially.
#external push.
#external green.