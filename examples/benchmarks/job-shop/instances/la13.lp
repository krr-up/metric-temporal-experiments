% ========= Metadata =========
   meta(name,la13).
   meta(num_jobs,20).
   meta(num_machines,5).
   meta(num_operations,100).
   meta(optimum,1150).
   meta(upper_bound,1150).
   meta(lower_bound,1150).
% ==========================


machine(0..5).

%--- Job 0
job(0).
operation(0,0,3,60).
operation(0,1,0,87).
operation(0,2,1,72).
operation(0,3,4,95).
operation(0,4,2,66).

%--- Job 1
job(1).
operation(1,5,1,54).
operation(1,6,0,48).
operation(1,7,2,39).
operation(1,8,3,35).
operation(1,9,4,5).

%--- Job 2
job(2).
operation(2,10,3,20).
operation(2,11,1,46).
operation(2,12,0,97).
operation(2,13,2,21).
operation(2,14,4,55).

%--- Job 3
job(3).
operation(3,15,2,37).
operation(3,16,0,59).
operation(3,17,3,19).
operation(3,18,1,34).
operation(3,19,4,46).

%--- Job 4
job(4).
operation(4,20,2,73).
operation(4,21,3,25).
operation(4,22,1,24).
operation(4,23,0,28).
operation(4,24,4,23).

%--- Job 5
job(5).
operation(5,25,1,78).
operation(5,26,3,28).
operation(5,27,2,83).
operation(5,28,0,45).
operation(5,29,4,5).

%--- Job 6
job(6).
operation(6,30,3,71).
operation(6,31,1,37).
operation(6,32,2,12).
operation(6,33,4,29).
operation(6,34,0,53).

%--- Job 7
job(7).
operation(7,35,4,12).
operation(7,36,3,33).
operation(7,37,1,55).
operation(7,38,2,87).
operation(7,39,0,38).

%--- Job 8
job(8).
operation(8,40,0,48).
operation(8,41,1,40).
operation(8,42,2,49).
operation(8,43,3,83).
operation(8,44,4,7).

%--- Job 9
job(9).
operation(9,45,0,90).
operation(9,46,4,27).
operation(9,47,2,65).
operation(9,48,3,17).
operation(9,49,1,23).

%--- Job 10
job(10).
operation(10,50,0,62).
operation(10,51,3,85).
operation(10,52,1,66).
operation(10,53,2,84).
operation(10,54,4,19).

%--- Job 11
job(11).
operation(11,55,3,59).
operation(11,56,2,46).
operation(11,57,4,13).
operation(11,58,1,64).
operation(11,59,0,25).

%--- Job 12
job(12).
operation(12,60,2,53).
operation(12,61,1,73).
operation(12,62,3,80).
operation(12,63,4,88).
operation(12,64,0,41).

%--- Job 13
job(13).
operation(13,65,2,57).
operation(13,66,4,47).
operation(13,67,0,14).
operation(13,68,1,67).
operation(13,69,3,74).

%--- Job 14
job(14).
operation(14,70,2,41).
operation(14,71,4,64).
operation(14,72,3,84).
operation(14,73,1,78).
operation(14,74,0,84).

%--- Job 15
job(15).
operation(15,75,4,52).
operation(15,76,3,28).
operation(15,77,2,26).
operation(15,78,0,63).
operation(15,79,1,46).

%--- Job 16
job(16).
operation(16,80,1,11).
operation(16,81,0,64).
operation(16,82,3,10).
operation(16,83,4,73).
operation(16,84,2,17).

%--- Job 17
job(17).
operation(17,85,4,38).
operation(17,86,3,95).
operation(17,87,0,85).
operation(17,88,1,97).
operation(17,89,2,67).

%--- Job 18
job(18).
operation(18,90,3,93).
operation(18,91,1,65).
operation(18,92,2,95).
operation(18,93,0,59).
operation(18,94,4,46).

%--- Job 19
job(19).
operation(19,95,0,60).
operation(19,96,1,85).
operation(19,97,2,43).
operation(19,98,4,85).
operation(19,99,3,32).

