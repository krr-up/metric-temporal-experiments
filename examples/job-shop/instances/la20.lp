% ========= Metadata =========
   meta(name,la20).
   meta(num_jobs,10).
   meta(num_machines,10).
   meta(num_operations,100).
   meta(optimum,902).
   meta(upper_bound,902).
   meta(lower_bound,902).
% ==========================


machine(0..10).

%--- Job 0
job(0).
operation(0,0,6,9).
operation(0,1,1,81).
operation(0,2,4,55).
operation(0,3,2,40).
operation(0,4,8,32).
operation(0,5,3,37).
operation(0,6,0,6).
operation(0,7,5,19).
operation(0,8,9,81).
operation(0,9,7,40).

%--- Job 1
job(1).
operation(1,10,7,21).
operation(1,11,2,70).
operation(1,12,9,65).
operation(1,13,4,64).
operation(1,14,1,46).
operation(1,15,5,65).
operation(1,16,8,25).
operation(1,17,0,77).
operation(1,18,3,55).
operation(1,19,6,15).

%--- Job 2
job(2).
operation(2,20,2,85).
operation(2,21,5,37).
operation(2,22,0,40).
operation(2,23,3,24).
operation(2,24,1,44).
operation(2,25,6,83).
operation(2,26,4,89).
operation(2,27,8,31).
operation(2,28,7,84).
operation(2,29,9,29).

%--- Job 3
job(3).
operation(3,30,4,80).
operation(3,31,6,77).
operation(3,32,7,56).
operation(3,33,0,8).
operation(3,34,2,30).
operation(3,35,5,59).
operation(3,36,3,38).
operation(3,37,1,80).
operation(3,38,9,41).
operation(3,39,8,97).

%--- Job 4
job(4).
operation(4,40,0,91).
operation(4,41,6,40).
operation(4,42,4,88).
operation(4,43,1,17).
operation(4,44,2,71).
operation(4,45,3,50).
operation(4,46,9,59).
operation(4,47,8,80).
operation(4,48,5,56).
operation(4,49,7,7).

%--- Job 5
job(5).
operation(5,50,2,8).
operation(5,51,6,9).
operation(5,52,3,58).
operation(5,53,5,77).
operation(5,54,1,29).
operation(5,55,8,96).
operation(5,56,0,45).
operation(5,57,9,10).
operation(5,58,4,54).
operation(5,59,7,36).

%--- Job 6
job(6).
operation(6,60,4,70).
operation(6,61,3,92).
operation(6,62,1,98).
operation(6,63,5,87).
operation(6,64,6,99).
operation(6,65,7,27).
operation(6,66,8,86).
operation(6,67,9,96).
operation(6,68,0,28).
operation(6,69,2,73).

%--- Job 7
job(7).
operation(7,70,1,95).
operation(7,71,7,92).
operation(7,72,3,85).
operation(7,73,4,52).
operation(7,74,6,81).
operation(7,75,9,32).
operation(7,76,8,39).
operation(7,77,0,59).
operation(7,78,2,41).
operation(7,79,5,56).

%--- Job 8
job(8).
operation(8,80,3,60).
operation(8,81,8,45).
operation(8,82,0,88).
operation(8,83,2,12).
operation(8,84,1,7).
operation(8,85,5,22).
operation(8,86,4,93).
operation(8,87,9,49).
operation(8,88,7,69).
operation(8,89,6,27).

%--- Job 9
job(9).
operation(9,90,0,21).
operation(9,91,2,61).
operation(9,92,3,68).
operation(9,93,5,26).
operation(9,94,6,82).
operation(9,95,9,71).
operation(9,96,8,44).
operation(9,97,4,99).
operation(9,98,7,33).
operation(9,99,1,84).

