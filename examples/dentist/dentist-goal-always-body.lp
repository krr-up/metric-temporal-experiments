goal :- at(ram,dentist), has(ram,icard), has(ram,cash).
not_goal :- not goal.

:- always((0,60),not_goal), initially.

show(goal).
#external always((0,60), not_goal).
