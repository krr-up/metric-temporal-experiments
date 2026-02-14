%
% Metric program
%
eventually((2,4),push) :- initially.
eventually((2,10),finally) :- initially.
% next((2,4),next((1,2),top)) :- initially.

#external initially.
#external push.