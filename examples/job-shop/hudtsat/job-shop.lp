#const timepoint_limit = 80.

% Extra
{start_run(J)}:-job(J).
% Can only start once
:- start_run(J), next((0,w),eventually((0,w), start_run(J))).

% start_run(J):-job(J),initially.
neg_start_run(J):-not start_run(J), job(J).
neg_has_run(J):- job(J), not has_run(J).
:- has_run(J), eventually((0,w), neg_has_run(J)).
neg_run(J):- job(J), not run(J,M): machine(M).

% 1
start_run(J,M):machine(M):-start_run(J).
:- start_run(J,M), not duration(J,M,_).
% 2
run(J,M):-start_run(J,M).

% 3
:- run(J,M'), run(J,M), M'>M.
:- run(J,M), run(J',M), J'>J.


% 4
next((0,w),always((0,w),neg_start_run(J))):-start_run(J).

% 5
always((0,T-1),run(J,M)):-start_run(J,M), duration(J,M,T).
always((0,T-1),neg_has_run(J)):-start_run(J,M), duration(J,M,T).

% 6
always((T,w),neg_run(J)):-start_run(J,M), duration(J,M,T).
always((T,w),has_run(J)):-start_run(J,M), duration(J,M,T).

% 7
% No needed since we are non-monotonic

% 8
next(neg_has_run(J)):-neg_has_run(J), neg_run(J).

% GOAL (Defined as in the evaluation section of the paper)
all_ran :- has_run(J):job(J).
:- not eventually((0,timepoint_limit), all_ran), initially.
#external eventually((0,timepoint_limit), all_ran).


next((0,1),true):-all_ran, not finally.

#external initially.
#external finally.
#external always((0,w), neg_start_run(J)):job(J).
#external next((0,w),eventually((0,w), start_run(J))):job(J).
#external eventually((0,w), start_run(J)):job(J).
#external neg_start_run(J):job(J).
#external neg_run(J):job(J).
#external has_run(J):job(J).
#external neg_has_run(J):job(J).


#show _show(start_run(J,M)):start_run(J,M).
