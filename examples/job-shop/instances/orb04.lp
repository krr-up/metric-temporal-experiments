% ========= Metadata =========
   meta(name,orb04).
   meta(num_jobs,10).
   meta(num_machines,10).
   meta(num_operations,100).
   meta(optimum,1005).
   meta(upper_bound,1005).
   meta(lower_bound,1005).
% ==========================


machine(0..10).

%--- Job 0
job(0).
operation(0,0,0,8).
operation(0,1,1,10).
operation(0,2,2,35).
operation(0,3,3,44).
operation(0,4,4,15).
operation(0,5,5,92).
operation(0,6,6,70).
operation(0,7,7,89).
operation(0,8,8,50).
operation(0,9,9,12).

%--- Job 1
job(1).
operation(1,10,0,63).
operation(1,11,8,39).
operation(1,12,3,80).
operation(1,13,5,22).
operation(1,14,2,88).
operation(1,15,1,39).
operation(1,16,9,85).
operation(1,17,6,27).
operation(1,18,7,74).
operation(1,19,4,69).

%--- Job 2
job(2).
operation(2,20,0,52).
operation(2,21,6,22).
operation(2,22,1,33).
operation(2,23,3,68).
operation(2,24,8,27).
operation(2,25,2,68).
operation(2,26,5,25).
operation(2,27,4,34).
operation(2,28,7,24).
operation(2,29,9,84).

%--- Job 3
job(3).
operation(3,30,0,31).
operation(3,31,1,85).
operation(3,32,4,55).
operation(3,33,8,80).
operation(3,34,5,58).
operation(3,35,7,11).
operation(3,36,6,69).
operation(3,37,9,56).
operation(3,38,3,73).
operation(3,39,2,25).

%--- Job 4
job(4).
operation(4,40,0,97).
operation(4,41,5,98).
operation(4,42,9,87).
operation(4,43,8,47).
operation(4,44,7,77).
operation(4,45,4,90).
operation(4,46,3,98).
operation(4,47,2,80).
operation(4,48,1,39).
operation(4,49,6,40).

%--- Job 5
job(5).
operation(5,50,1,97).
operation(5,51,5,68).
operation(5,52,0,44).
operation(5,53,9,67).
operation(5,54,2,44).
operation(5,55,8,85).
operation(5,56,3,78).
operation(5,57,6,90).
operation(5,58,7,33).
operation(5,59,4,81).

%--- Job 6
job(6).
operation(6,60,0,34).
operation(6,61,3,76).
operation(6,62,8,48).
operation(6,63,7,61).
operation(6,64,9,11).
operation(6,65,2,36).
operation(6,66,4,33).
operation(6,67,6,98).
operation(6,68,1,7).
operation(6,69,5,44).

%--- Job 7
job(7).
operation(7,70,0,44).
operation(7,71,9,5).
operation(7,72,4,85).
operation(7,73,1,51).
operation(7,74,5,58).
operation(7,75,7,79).
operation(7,76,2,95).
operation(7,77,6,48).
operation(7,78,3,86).
operation(7,79,8,73).

%--- Job 8
job(8).
operation(8,80,0,24).
operation(8,81,1,63).
operation(8,82,9,48).
operation(8,83,7,77).
operation(8,84,8,73).
operation(8,85,6,74).
operation(8,86,4,63).
operation(8,87,5,17).
operation(8,88,2,93).
operation(8,89,3,84).

%--- Job 9
job(9).
operation(9,90,0,51).
operation(9,91,2,5).
operation(9,92,4,40).
operation(9,93,9,60).
operation(9,94,1,46).
operation(9,95,5,58).
operation(9,96,8,54).
operation(9,97,3,72).
operation(9,98,6,29).
operation(9,99,7,94).

