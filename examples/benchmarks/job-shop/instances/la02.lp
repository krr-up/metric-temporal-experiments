% ========= Metadata =========
   meta(name,la02).
   meta(num_jobs,10).
   meta(num_machines,5).
   meta(num_operations,50).
   meta(optimum,655).
   meta(upper_bound,655).
   meta(lower_bound,655).
% ==========================


machine(0..5).

%--- Job 0
job(0).
operation(0,0,0,20).
operation(0,1,3,87).
operation(0,2,1,31).
operation(0,3,4,76).
operation(0,4,2,17).

%--- Job 1
job(1).
operation(1,5,4,25).
operation(1,6,2,32).
operation(1,7,0,24).
operation(1,8,1,18).
operation(1,9,3,81).

%--- Job 2
job(2).
operation(2,10,1,72).
operation(2,11,2,23).
operation(2,12,4,28).
operation(2,13,0,58).
operation(2,14,3,99).

%--- Job 3
job(3).
operation(3,15,2,86).
operation(3,16,1,76).
operation(3,17,4,97).
operation(3,18,0,45).
operation(3,19,3,90).

%--- Job 4
job(4).
operation(4,20,4,27).
operation(4,21,0,42).
operation(4,22,3,48).
operation(4,23,2,17).
operation(4,24,1,46).

%--- Job 5
job(5).
operation(5,25,1,67).
operation(5,26,0,98).
operation(5,27,4,48).
operation(5,28,3,27).
operation(5,29,2,62).

%--- Job 6
job(6).
operation(6,30,4,28).
operation(6,31,1,12).
operation(6,32,3,19).
operation(6,33,0,80).
operation(6,34,2,50).

%--- Job 7
job(7).
operation(7,35,1,63).
operation(7,36,0,94).
operation(7,37,2,98).
operation(7,38,3,50).
operation(7,39,4,80).

%--- Job 8
job(8).
operation(8,40,4,14).
operation(8,41,0,75).
operation(8,42,2,50).
operation(8,43,1,41).
operation(8,44,3,55).

%--- Job 9
job(9).
operation(9,45,4,72).
operation(9,46,2,18).
operation(9,47,1,37).
operation(9,48,3,79).
operation(9,49,0,61).

