% ========= Metadata =========
   meta(name,la03).
   meta(num_jobs,10).
   meta(num_machines,5).
   meta(num_operations,50).
   meta(optimum,597).
   meta(upper_bound,597).
   meta(lower_bound,597).
% ==========================


machine(0..5).

%--- Job 0
job(0).
operation(0,0,1,23).
operation(0,1,2,45).
operation(0,2,0,82).
operation(0,3,4,84).
operation(0,4,3,38).

%--- Job 1
job(1).
operation(1,5,2,21).
operation(1,6,1,29).
operation(1,7,0,18).
operation(1,8,4,41).
operation(1,9,3,50).

%--- Job 2
job(2).
operation(2,10,2,38).
operation(2,11,3,54).
operation(2,12,4,16).
operation(2,13,0,52).
operation(2,14,1,52).

%--- Job 3
job(3).
operation(3,15,4,37).
operation(3,16,0,54).
operation(3,17,2,74).
operation(3,18,1,62).
operation(3,19,3,57).

%--- Job 4
job(4).
operation(4,20,4,57).
operation(4,21,0,81).
operation(4,22,1,61).
operation(4,23,3,68).
operation(4,24,2,30).

%--- Job 5
job(5).
operation(5,25,4,81).
operation(5,26,0,79).
operation(5,27,1,89).
operation(5,28,2,89).
operation(5,29,3,11).

%--- Job 6
job(6).
operation(6,30,3,33).
operation(6,31,2,20).
operation(6,32,0,91).
operation(6,33,4,20).
operation(6,34,1,66).

%--- Job 7
job(7).
operation(7,35,4,24).
operation(7,36,1,84).
operation(7,37,0,32).
operation(7,38,2,55).
operation(7,39,3,8).

%--- Job 8
job(8).
operation(8,40,4,56).
operation(8,41,0,7).
operation(8,42,3,54).
operation(8,43,2,64).
operation(8,44,1,39).

%--- Job 9
job(9).
operation(9,45,4,40).
operation(9,46,1,83).
operation(9,47,0,19).
operation(9,48,2,8).
operation(9,49,3,7).

