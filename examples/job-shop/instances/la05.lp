% ========= Metadata =========
   meta(name,la05).
   meta(num_jobs,10).
   meta(num_machines,5).
   meta(num_operations,50).
   meta(optimum,593).
   meta(upper_bound,593).
   meta(lower_bound,593).
% ==========================


machine(0..5).

%--- Job 0
job(0).
operation(0,0,1,72).
operation(0,1,0,87).
operation(0,2,4,95).
operation(0,3,2,66).
operation(0,4,3,60).

%--- Job 1
job(1).
operation(1,5,4,5).
operation(1,6,3,35).
operation(1,7,0,48).
operation(1,8,2,39).
operation(1,9,1,54).

%--- Job 2
job(2).
operation(2,10,1,46).
operation(2,11,3,20).
operation(2,12,2,21).
operation(2,13,0,97).
operation(2,14,4,55).

%--- Job 3
job(3).
operation(3,15,0,59).
operation(3,16,3,19).
operation(3,17,4,46).
operation(3,18,1,34).
operation(3,19,2,37).

%--- Job 4
job(4).
operation(4,20,4,23).
operation(4,21,2,73).
operation(4,22,3,25).
operation(4,23,1,24).
operation(4,24,0,28).

%--- Job 5
job(5).
operation(5,25,3,28).
operation(5,26,0,45).
operation(5,27,4,5).
operation(5,28,1,78).
operation(5,29,2,83).

%--- Job 6
job(6).
operation(6,30,0,53).
operation(6,31,3,71).
operation(6,32,1,37).
operation(6,33,4,29).
operation(6,34,2,12).

%--- Job 7
job(7).
operation(7,35,4,12).
operation(7,36,2,87).
operation(7,37,3,33).
operation(7,38,1,55).
operation(7,39,0,38).

%--- Job 8
job(8).
operation(8,40,2,49).
operation(8,41,3,83).
operation(8,42,1,40).
operation(8,43,0,48).
operation(8,44,4,7).

%--- Job 9
job(9).
operation(9,45,2,65).
operation(9,46,3,17).
operation(9,47,0,90).
operation(9,48,4,27).
operation(9,49,1,23).

