
goal :- at(ram,dentist), has(ram,icard), has(ram,cash).

% Represent the goal!
:- not eventually((0,60*size),goal), initially.

#external eventually((0,60*size),goal).
