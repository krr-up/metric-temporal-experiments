
operation(O):- operation(J,O,M,D).
{start_run(O,M):operation(_,O,M,_)}:-operation(O).

% Can only start once (Once started can't be started again)
:- start_run(O,M), next((0,w),eventually((0,w), start_run(O,M'))).

run(O,M):-start_run(O,M).

% Can't run the same operation in two machines
:- run(O,M'), run(O,M), M'>M.
% Can't run two operations in the same machine at the same time
:- run(O,M), run(O',M), O'>O.

% Once started it will run until completion
always((0,D-1),run(O,M)):-start_run(O,M), operation(_,O,M,D).
% always((0,1),run(O,M)):-start_run(O,M), operation(_,O,M,D).
% Then it will be forever done
always((D,w),has_run(O)):-start_run(O,M), operation(_,O,M,D).
% always((1,w),has_run(O)):-start_run(O,M), operation(_,O,M,D).

% Operations are performed in order
before(O1,O1+1):- operation(J,O1,M1,D1), operation(J,O1+1,M2,D2).
:- before(O1,O2), start_run(O1,_), not eventually((1,w), start_run(O2,_)).

% GOAL
all_ran :- has_run(O):operation(O).
:- not all_ran, finally. %This only makes sense with the rules below
% next((0,1),true):-all_ran, not finally.
% :- not eventually((0,L), all_ran), timepoint_limit(L).
% #external eventually((0,L), all_ran):timepoint_limit(L).

% Limit the timepoint_limit to the optimum if known
% :- not eventually((0,L), finally), initially, timepoint_limit(L).
% #external eventually((0,L), finally):timepoint_limit(L).

#external initially.
#external finally.
#external next((0,w),eventually((0,w), start_run(O,M))):operation(_,O,M,_).
#external eventually((0,w), start_run(O,M)):operation(_,O,M,_).
#external has_run(O):operation(O).
#external eventually((1,w), start_run(O,M)):operation(_,O,M,_).


#show _show(start_run(O,M)):start_run(O,M).
% #show _show(run(O,M)):run(O,M).
% #show _show(all_ran):all_ran.
% #show _show(has_run(O)):has_run(O).
