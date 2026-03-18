% ========= Metadata =========
   meta(name,ft06).
   meta(num_jobs,6).
   meta(num_machines,6).
   meta(num_operations,36).
   meta(optimum,55).
   meta(upper_bound,55).
   meta(lower_bound,55).
   % Lambda 11
% ==========================


machine(0..6).

%--- Job 0
job(0).
operation(0,0,2,1).
operation(0,1,0,3).
operation(0,2,1,6).
operation(0,3,3,7).
operation(0,4,5,3).
operation(0,5,4,6).

%--- Job 1
job(1).
operation(1,6,1,8).
operation(1,7,2,5).
operation(1,8,4,10).
operation(1,9,5,10).
operation(1,10,0,10).
operation(1,11,3,4).

%--- Job 2
job(2).
operation(2,12,2,5).
operation(2,13,3,4).
operation(2,14,5,8).
operation(2,15,0,9).
operation(2,16,1,1).
operation(2,17,4,7).

%--- Job 3
job(3).
operation(3,18,1,5).
operation(3,19,0,5).
operation(3,20,2,5).
operation(3,21,3,3).
operation(3,22,4,8).
operation(3,23,5,9).

%--- Job 4
job(4).
operation(4,24,2,9).
operation(4,25,1,3).
operation(4,26,4,5).
operation(4,27,5,4).
operation(4,28,0,3).
operation(4,29,3,1).

%--- Job 5
job(5).
operation(5,30,1,3).
operation(5,31,3,3).
operation(5,32,5,9).
operation(5,33,0,10).
operation(5,34,4,4).
operation(5,35,2,1).

