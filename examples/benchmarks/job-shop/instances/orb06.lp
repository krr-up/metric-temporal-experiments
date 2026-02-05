% ========= Metadata =========
   meta(name,orb06).
   meta(num_jobs,10).
   meta(num_machines,10).
   meta(num_operations,100).
   meta(optimum,1010).
   meta(upper_bound,1010).
   meta(lower_bound,1010).
% ==========================


machine(0..10).

%--- Job 0
job(0).
operation(0,0,0,99).
operation(0,1,1,74).
operation(0,2,2,49).
operation(0,3,3,67).
operation(0,4,4,17).
operation(0,5,5,7).
operation(0,6,6,9).
operation(0,7,7,39).
operation(0,8,8,35).
operation(0,9,9,49).

%--- Job 1
job(1).
operation(1,10,0,49).
operation(1,11,3,67).
operation(1,12,4,82).
operation(1,13,2,92).
operation(1,14,1,62).
operation(1,15,5,84).
operation(1,16,8,45).
operation(1,17,6,30).
operation(1,18,7,42).
operation(1,19,9,71).

%--- Job 2
job(2).
operation(2,20,0,26).
operation(2,21,3,33).
operation(2,22,1,82).
operation(2,23,2,98).
operation(2,24,5,83).
operation(2,25,4,16).
operation(2,26,6,64).
operation(2,27,7,65).
operation(2,28,9,36).
operation(2,29,8,77).

%--- Job 3
job(3).
operation(3,30,0,41).
operation(3,31,1,62).
operation(3,32,4,73).
operation(3,33,3,94).
operation(3,34,6,51).
operation(3,35,5,46).
operation(3,36,2,55).
operation(3,37,9,31).
operation(3,38,7,64).
operation(3,39,8,46).

%--- Job 4
job(4).
operation(4,40,1,68).
operation(4,41,0,26).
operation(4,42,5,50).
operation(4,43,3,46).
operation(4,44,4,25).
operation(4,45,7,88).
operation(4,46,2,6).
operation(4,47,8,13).
operation(4,48,9,98).
operation(4,49,6,84).

%--- Job 5
job(5).
operation(5,50,0,24).
operation(5,51,6,80).
operation(5,52,2,91).
operation(5,53,3,55).
operation(5,54,1,48).
operation(5,55,8,99).
operation(5,56,4,72).
operation(5,57,9,91).
operation(5,58,7,84).
operation(5,59,5,12).

%--- Job 6
job(6).
operation(6,60,2,16).
operation(6,61,3,13).
operation(6,62,0,9).
operation(6,63,1,58).
operation(6,64,4,23).
operation(6,65,7,85).
operation(6,66,5,36).
operation(6,67,6,89).
operation(6,68,8,71).
operation(6,69,9,41).

%--- Job 7
job(7).
operation(7,70,2,54).
operation(7,71,0,41).
operation(7,72,3,38).
operation(7,73,4,53).
operation(7,74,1,11).
operation(7,75,5,74).
operation(7,76,9,88).
operation(7,77,6,46).
operation(7,78,7,41).
operation(7,79,8,65).

%--- Job 8
job(8).
operation(8,80,2,53).
operation(8,81,1,50).
operation(8,82,4,40).
operation(8,83,0,90).
operation(8,84,7,7).
operation(8,85,5,80).
operation(8,86,3,57).
operation(8,87,9,60).
operation(8,88,6,91).
operation(8,89,8,47).

%--- Job 9
job(9).
operation(9,90,2,45).
operation(9,91,0,59).
operation(9,92,8,81).
operation(9,93,3,99).
operation(9,94,6,71).
operation(9,95,1,19).
operation(9,96,4,75).
operation(9,97,7,77).
operation(9,98,9,94).
operation(9,99,5,95).

