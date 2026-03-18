% ========= Metadata =========
   meta(name,ft10).
   meta(num_jobs,10).
   meta(num_machines,10).
   meta(num_operations,100).
   meta(optimum,930).
   meta(upper_bound,930).
   meta(lower_bound,930).
% ==========================


machine(0..10).

#const const_size=2.

%--- Job 0
job(0).
operation(0,0,0,const_size).
operation(0,1,1,const_size).
operation(0,2,2,const_size).
operation(0,3,3,const_size).
operation(0,4,4,const_size).
operation(0,5,5,const_size).
operation(0,6,6,const_size).
operation(0,7,7,const_size).
operation(0,8,8,const_size).
operation(0,9,9,const_size).

%--- Job 1
job(1).
operation(1,10,0,const_size).
operation(1,11,2,const_size).
operation(1,12,4,const_size).
operation(1,13,9,const_size).
operation(1,14,3,const_size).
operation(1,15,1,const_size).
operation(1,16,6,const_size).
operation(1,17,5,const_size).
operation(1,18,7,const_size).
operation(1,19,8,const_size).

%--- Job 2
job(2).
operation(2,20,1,const_size).
operation(2,21,0,const_size).
operation(2,22,3,const_size).
operation(2,23,2,const_size).
operation(2,24,8,const_size).
operation(2,25,5,const_size).
operation(2,26,7,const_size).
operation(2,27,6,const_size).
operation(2,28,9,const_size).
operation(2,29,4,const_size).

%--- Job 3
job(3).
operation(3,30,1,const_size).
operation(3,31,2,const_size).
operation(3,32,0,const_size).
operation(3,33,4,const_size).
operation(3,34,6,const_size).
operation(3,35,8,const_size).
operation(3,36,7,const_size).
operation(3,37,3,const_size).
operation(3,38,9,const_size).
operation(3,39,5,const_size).

%--- Job 4
job(4).
operation(4,40,2,const_size).
operation(4,41,0,const_size).
operation(4,42,1,const_size).
operation(4,43,5,const_size).
operation(4,44,3,const_size).
operation(4,45,4,const_size).
operation(4,46,8,const_size).
operation(4,47,7,const_size).
operation(4,48,9,const_size).
operation(4,49,6,const_size).

%--- Job 5
job(5).
operation(5,50,2,const_size).
operation(5,51,1,const_size).
operation(5,52,5,const_size).
operation(5,53,3,const_size).
operation(5,54,8,const_size).
operation(5,55,9,const_size).
operation(5,56,0,const_size).
operation(5,57,6,const_size).
operation(5,58,4,const_size).
operation(5,59,7,const_size).

%--- Job 6
job(6).
operation(6,60,1,const_size).
operation(6,61,0,const_size).
operation(6,62,3,const_size).
operation(6,63,2,const_size).
operation(6,64,6,const_size).
operation(6,65,5,const_size).
operation(6,66,9,const_size).
operation(6,67,8,const_size).
operation(6,68,7,const_size).
operation(6,69,4,const_size).

%--- Job 7
job(7).
operation(7,70,2,const_size).
operation(7,71,0,const_size).
operation(7,72,1,const_size).
operation(7,73,5,const_size).
operation(7,74,4,const_size).
operation(7,75,6,const_size).
operation(7,76,8,const_size).
operation(7,77,9,const_size).
operation(7,78,7,const_size).
operation(7,79,3,const_size).

%--- Job 8
job(8).
operation(8,80,0,const_size).
operation(8,81,1,const_size).
operation(8,82,3,const_size).
operation(8,83,5,const_size).
operation(8,84,2,const_size).
operation(8,85,9,const_size).
operation(8,86,6,const_size).
operation(8,87,7,const_size).
operation(8,88,4,const_size).
operation(8,89,8,const_size).

%--- Job 9
job(9).
operation(9,90,1,const_size).
operation(9,91,0,const_size).
operation(9,92,2,const_size).
operation(9,93,6,const_size).
operation(9,94,8,const_size).
operation(9,95,9,const_size).
operation(9,96,5,const_size).
operation(9,97,3,const_size).
operation(9,98,4,const_size).
operation(9,99,7,const_size).

