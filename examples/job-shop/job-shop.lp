
operation(O):- operation(J,O,M,D).
job(O,J):- operation(J,O,M,D).
machine(O,M):- operation(J,O,M,D).
duration(O,D):- operation(J,O,M,D).


wait(O);start_run(O) :- operation(O), not has_run(O).

always((0,D),run(O))  :- start_run(O), duration(O,D).
always((D,w),has_run(O)):- start_run(O), duration(O,D).

:- run(O), run(O'), O'>O, machine(O, M), machine(O', M).
:- job(O+1,J), job(O,J), machine(O+1, M),
   start_run(O+1), not has_run(O).

:- operation(O), not has_run(O), finally.


#external initially.
#external finally.
#external run(O):operation(O).
#external has_run(O):operation(O).


#show _show(start_run(O)):start_run(O).
% #show _show(has_run(O)):has_run(O).
% #show _show(wait(O)):wait(O).
% #show _show(run(O)):run(O).
% #show _show(all_ran):all_ran.
% #show _show(has_run(O)):has_run(O).
