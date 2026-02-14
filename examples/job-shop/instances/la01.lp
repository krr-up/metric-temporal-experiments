% ========= Metadata =========
   meta(name,la01).
   meta(num_jobs,10).
   meta(num_machines,5).
   meta(num_operations,50).
   meta(optimum,666).
   meta(upper_bound,666).
   meta(lower_bound,666).
% ==========================


machine(0..5).

%--- Job 0
job(0).
operation(0,0,1,21).
operation(0,1,0,53).
operation(0,2,4,95).
operation(0,3,3,55).
operation(0,4,2,34).

%--- Job 1
job(1).
operation(1,5,0,21).
operation(1,6,3,52).
operation(1,7,4,16).
operation(1,8,2,26).
operation(1,9,1,71).

%--- Job 2
job(2).
operation(2,10,3,39).
operation(2,11,4,98).
operation(2,12,1,42).
operation(2,13,2,31).
operation(2,14,0,12).

%--- Job 3
job(3).
operation(3,15,1,77).
operation(3,16,0,55).
operation(3,17,4,79).
operation(3,18,2,66).
operation(3,19,3,77).

%--- Job 4
job(4).
operation(4,20,0,83).
operation(4,21,3,34).
operation(4,22,2,64).
operation(4,23,1,19).
operation(4,24,4,37).

%--- Job 5
job(5).
operation(5,25,1,54).
operation(5,26,2,43).
operation(5,27,4,79).
operation(5,28,0,92).
operation(5,29,3,62).

%--- Job 6
job(6).
operation(6,30,3,69).
operation(6,31,4,77).
operation(6,32,1,87).
operation(6,33,2,87).
operation(6,34,0,93).

%--- Job 7
job(7).
operation(7,35,2,38).
operation(7,36,0,60).
operation(7,37,1,41).
operation(7,38,3,24).
operation(7,39,4,83).

%--- Job 8
job(8).
operation(8,40,3,17).
operation(8,41,1,49).
operation(8,42,4,25).
operation(8,43,0,44).
operation(8,44,2,98).

%--- Job 9
job(9).
operation(9,45,4,77).
operation(9,46,3,79).
operation(9,47,2,43).
operation(9,48,1,75).
operation(9,49,0,96).

