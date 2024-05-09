%
% Metric program
%
% {next((3,4),a)} :- initially.
1{next((3,4),a);next((3,4),b)}1 :- initially.
% {next((3,4),a)} :- initially.
% {next((3,4),b)} :- initially.
% :- a, b.
% :- not next((3,4),a), not next((3,4),b), initially.
% next((1,3),b) :- a.

#external initially.
#external b.
#external a.