timepoint_limit(X):-meta(optimum,X).
timepoint_limit(100):-not meta(optimum,_).

% Extra
operation(O):- operation(J,O,M,D).
before(O1,O1+1):- operation(J,O1,M1,D1), operation(J,O1+1,M2,D2).

{start_run(O)}:-operation(O).
% Can only start once
:- start_run(O), next((0,w),eventually((0,w), start_run(O))).

neg_start_run(O):-not start_run(O), operation(O).
neg_has_run(O):- operation(O), not has_run(O).
:- has_run(O), eventually((0,w), neg_has_run(O)).
neg_run(O):- operation(O), not run(O,M): machine(M).

% 1
start_run(O,M):machine(M):-operation(O),start_run(O).
:- start_run(O,M), not operation(_,O,M,_). %Needs to be executable in that machine

% 2
run(O,M):-start_run(O,M).

% 3
:- run(O,M'), run(O,M), M'>M.
:- run(O,M), run(O',M), O'>O.


% 4
next((0,w),always((0,w),neg_start_run(O))):-start_run(O).

% 5
always((0,D-1),run(O,M)):-start_run(O,M), operation(_,O,M,D).
always((0,D-1),neg_has_run(O)):-start_run(O,M), operation(_,O,M,D).

% 6
always((D,w),neg_run(O)):-start_run(O,M), operation(_,O,M,D).
always((D,w),has_run(O)):-start_run(O,M), operation(_,O,M,D).

% 7
% No needed since we are non-monotonic

% 8
next(neg_has_run(O)):-neg_has_run(O), neg_run(O).

% GOAL (Defined as in the evaluation section of the paper)
all_ran :- has_run(O):operation(O).

% SUSANA Why is this rule making it so much slower? More complex solving?
% :- not eventually((0,L), all_ran), initially, timepoint_limit(L).
:- not all_ran, finally.

#external eventually((0,L), all_ran):timepoint_limit(L).
% Limit the timepoint_limit to the optimum if known
:- not eventually((0,L), finally), initially, timepoint_limit(L).
#external eventually((0,L), finally):timepoint_limit(L).

% Operations performed in order
:- before(O1,O2), start_run(O2,_), eventually((1,w), start_run(O1,_)).

% next((0,1),true):- not finally.
% next((0,1),true):-all_ran, not finally.
% SOmething to limit the time limit
% :- not eventually((0,time_point_limit), finally), initially.

#external initially.
#external finally.
#external always((0,w), neg_start_run(O)):operation(O).
#external next((0,w),eventually((0,w), start_run(O))):operation(O).
#external eventually((0,w), start_run(O)):operation(O).
#external neg_start_run(O):operation(O).
#external neg_run(O):operation(O).
#external has_run(O):operation(O).
#external neg_has_run(O):operation(O).
#external eventually((1,w), start_run(O,M)):operation(O),machine(M).
#external eventually((0,w), neg_has_run(O)):operation(O).

#show _show(start_run(O,M)):start_run(O,M).
% #show _show(all_ran):all_ran.
% #show _show(has_run(O)):has_run(O).
