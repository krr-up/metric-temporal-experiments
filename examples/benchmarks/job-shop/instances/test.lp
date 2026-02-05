% ========= Metadata =========
   meta(name,"Example").
   meta(optimum,25).
% ==========================


machine(0..3).

%--- Job 0
job(0).
operation(0,0,0,1).
operation(0,1,1,1).
operation(0,2,2,7).

%--- Job 1
job(1).
operation(1,3,1,5).
operation(1,4,2,1).
operation(1,5,0,1).

%--- Job 2
job(2).
operation(2,6,2,1).
operation(2,7,0,3).
operation(2,8,1,2).
