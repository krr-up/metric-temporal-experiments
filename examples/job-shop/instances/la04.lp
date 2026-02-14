% ========= Metadata =========
   meta(name,la04).
   meta(num_jobs,10).
   meta(num_machines,5).
   meta(num_operations,50).
   meta(optimum,590).
   meta(upper_bound,590).
   meta(lower_bound,590).
% ==========================


machine(0..5).

%--- Job 0
job(0).
operation(0,0,0,12).
operation(0,1,2,94).
operation(0,2,3,92).
operation(0,3,4,91).
operation(0,4,1,7).

%--- Job 1
job(1).
operation(1,5,1,19).
operation(1,6,3,11).
operation(1,7,4,66).
operation(1,8,2,21).
operation(1,9,0,87).

%--- Job 2
job(2).
operation(2,10,1,14).
operation(2,11,0,75).
operation(2,12,3,13).
operation(2,13,4,16).
operation(2,14,2,20).

%--- Job 3
job(3).
operation(3,15,2,95).
operation(3,16,4,66).
operation(3,17,0,7).
operation(3,18,3,7).
operation(3,19,1,77).

%--- Job 4
job(4).
operation(4,20,1,45).
operation(4,21,3,6).
operation(4,22,4,89).
operation(4,23,0,15).
operation(4,24,2,34).

%--- Job 5
job(5).
operation(5,25,3,77).
operation(5,26,2,20).
operation(5,27,0,76).
operation(5,28,4,88).
operation(5,29,1,53).

%--- Job 6
job(6).
operation(6,30,2,74).
operation(6,31,1,88).
operation(6,32,0,52).
operation(6,33,3,27).
operation(6,34,4,9).

%--- Job 7
job(7).
operation(7,35,1,88).
operation(7,36,3,69).
operation(7,37,0,62).
operation(7,38,4,98).
operation(7,39,2,52).

%--- Job 8
job(8).
operation(8,40,2,61).
operation(8,41,4,9).
operation(8,42,0,62).
operation(8,43,1,52).
operation(8,44,3,90).

%--- Job 9
job(9).
operation(9,45,2,54).
operation(9,46,4,5).
operation(9,47,3,59).
operation(9,48,1,15).
operation(9,49,0,88).

