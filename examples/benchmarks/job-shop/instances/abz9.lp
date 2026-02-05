% ========= Metadata =========
   meta(name,abz9).
   meta(num_jobs,20).
   meta(num_machines,15).
   meta(num_operations,300).
   meta(optimum,678).
   meta(upper_bound,678).
   meta(lower_bound,678).
% ==========================


machine(0..15).

%--- Job 0
job(0).
operation(0,0,6,14).
operation(0,1,5,21).
operation(0,2,8,13).
operation(0,3,4,11).
operation(0,4,1,11).
operation(0,5,14,35).
operation(0,6,13,20).
operation(0,7,11,17).
operation(0,8,10,18).
operation(0,9,12,11).
operation(0,10,2,23).
operation(0,11,3,13).
operation(0,12,0,15).
operation(0,13,7,11).
operation(0,14,9,35).

%--- Job 1
job(1).
operation(1,15,1,35).
operation(1,16,5,31).
operation(1,17,0,13).
operation(1,18,3,26).
operation(1,19,6,14).
operation(1,20,9,17).
operation(1,21,7,38).
operation(1,22,12,20).
operation(1,23,10,19).
operation(1,24,13,12).
operation(1,25,8,16).
operation(1,26,4,34).
operation(1,27,11,15).
operation(1,28,14,12).
operation(1,29,2,14).

%--- Job 2
job(2).
operation(2,30,0,30).
operation(2,31,4,35).
operation(2,32,2,40).
operation(2,33,10,35).
operation(2,34,6,30).
operation(2,35,14,23).
operation(2,36,8,29).
operation(2,37,13,37).
operation(2,38,7,38).
operation(2,39,3,40).
operation(2,40,9,26).
operation(2,41,12,11).
operation(2,42,1,40).
operation(2,43,11,36).
operation(2,44,5,17).

%--- Job 3
job(3).
operation(3,45,7,40).
operation(3,46,5,18).
operation(3,47,4,12).
operation(3,48,8,23).
operation(3,49,0,23).
operation(3,50,9,14).
operation(3,51,13,16).
operation(3,52,12,14).
operation(3,53,10,23).
operation(3,54,3,12).
operation(3,55,6,16).
operation(3,56,14,32).
operation(3,57,1,40).
operation(3,58,11,25).
operation(3,59,2,29).

%--- Job 4
job(4).
operation(4,60,2,35).
operation(4,61,3,15).
operation(4,62,12,31).
operation(4,63,11,28).
operation(4,64,6,32).
operation(4,65,4,30).
operation(4,66,10,27).
operation(4,67,7,29).
operation(4,68,0,38).
operation(4,69,13,11).
operation(4,70,1,23).
operation(4,71,14,17).
operation(4,72,5,27).
operation(4,73,9,37).
operation(4,74,8,29).

%--- Job 5
job(5).
operation(5,75,5,33).
operation(5,76,3,33).
operation(5,77,6,19).
operation(5,78,12,40).
operation(5,79,10,19).
operation(5,80,0,33).
operation(5,81,13,26).
operation(5,82,2,31).
operation(5,83,11,28).
operation(5,84,7,36).
operation(5,85,4,38).
operation(5,86,1,21).
operation(5,87,14,25).
operation(5,88,9,40).
operation(5,89,8,35).

%--- Job 6
job(6).
operation(6,90,13,25).
operation(6,91,0,32).
operation(6,92,11,33).
operation(6,93,12,18).
operation(6,94,4,32).
operation(6,95,6,28).
operation(6,96,5,15).
operation(6,97,3,35).
operation(6,98,9,14).
operation(6,99,2,34).
operation(6,100,7,23).
operation(6,101,10,32).
operation(6,102,1,17).
operation(6,103,14,26).
operation(6,104,8,19).

%--- Job 7
job(7).
operation(7,105,2,16).
operation(7,106,12,33).
operation(7,107,9,34).
operation(7,108,11,30).
operation(7,109,13,40).
operation(7,110,8,12).
operation(7,111,14,26).
operation(7,112,5,26).
operation(7,113,6,15).
operation(7,114,3,21).
operation(7,115,1,40).
operation(7,116,4,32).
operation(7,117,0,14).
operation(7,118,7,30).
operation(7,119,10,35).

%--- Job 8
job(8).
operation(8,120,2,17).
operation(8,121,10,16).
operation(8,122,14,20).
operation(8,123,6,24).
operation(8,124,8,26).
operation(8,125,3,36).
operation(8,126,12,22).
operation(8,127,0,14).
operation(8,128,13,11).
operation(8,129,9,20).
operation(8,130,7,23).
operation(8,131,1,29).
operation(8,132,11,23).
operation(8,133,4,15).
operation(8,134,5,40).

%--- Job 9
job(9).
operation(9,135,4,27).
operation(9,136,9,37).
operation(9,137,3,40).
operation(9,138,11,14).
operation(9,139,13,25).
operation(9,140,7,30).
operation(9,141,0,34).
operation(9,142,2,11).
operation(9,143,5,15).
operation(9,144,12,32).
operation(9,145,1,36).
operation(9,146,10,12).
operation(9,147,14,28).
operation(9,148,8,31).
operation(9,149,6,23).

%--- Job 10
job(10).
operation(10,150,13,25).
operation(10,151,0,22).
operation(10,152,3,27).
operation(10,153,8,14).
operation(10,154,5,25).
operation(10,155,6,20).
operation(10,156,14,18).
operation(10,157,7,14).
operation(10,158,1,19).
operation(10,159,2,17).
operation(10,160,4,27).
operation(10,161,9,22).
operation(10,162,12,22).
operation(10,163,11,27).
operation(10,164,10,21).

%--- Job 11
job(11).
operation(11,165,14,34).
operation(11,166,10,15).
operation(11,167,0,22).
operation(11,168,3,29).
operation(11,169,13,34).
operation(11,170,6,40).
operation(11,171,7,17).
operation(11,172,2,32).
operation(11,173,12,20).
operation(11,174,5,39).
operation(11,175,4,31).
operation(11,176,11,16).
operation(11,177,1,37).
operation(11,178,8,33).
operation(11,179,9,13).

%--- Job 12
job(12).
operation(12,180,6,12).
operation(12,181,12,27).
operation(12,182,4,17).
operation(12,183,2,24).
operation(12,184,8,11).
operation(12,185,5,19).
operation(12,186,14,11).
operation(12,187,3,17).
operation(12,188,9,25).
operation(12,189,1,11).
operation(12,190,11,31).
operation(12,191,13,33).
operation(12,192,7,31).
operation(12,193,10,12).
operation(12,194,0,22).

%--- Job 13
job(13).
operation(13,195,5,22).
operation(13,196,14,15).
operation(13,197,0,16).
operation(13,198,8,32).
operation(13,199,7,20).
operation(13,200,4,22).
operation(13,201,9,11).
operation(13,202,13,19).
operation(13,203,1,30).
operation(13,204,12,33).
operation(13,205,6,29).
operation(13,206,11,18).
operation(13,207,3,34).
operation(13,208,10,32).
operation(13,209,2,18).

%--- Job 14
job(14).
operation(14,210,5,27).
operation(14,211,3,26).
operation(14,212,10,28).
operation(14,213,6,37).
operation(14,214,4,18).
operation(14,215,12,12).
operation(14,216,11,11).
operation(14,217,13,26).
operation(14,218,7,27).
operation(14,219,9,40).
operation(14,220,14,19).
operation(14,221,1,24).
operation(14,222,2,18).
operation(14,223,0,12).
operation(14,224,8,34).

%--- Job 15
job(15).
operation(15,225,8,15).
operation(15,226,5,28).
operation(15,227,9,25).
operation(15,228,6,32).
operation(15,229,1,13).
operation(15,230,7,38).
operation(15,231,11,11).
operation(15,232,2,34).
operation(15,233,4,25).
operation(15,234,0,20).
operation(15,235,10,32).
operation(15,236,3,23).
operation(15,237,12,14).
operation(15,238,14,16).
operation(15,239,13,20).

%--- Job 16
job(16).
operation(16,240,1,15).
operation(16,241,4,13).
operation(16,242,8,37).
operation(16,243,3,14).
operation(16,244,10,22).
operation(16,245,5,24).
operation(16,246,12,26).
operation(16,247,7,22).
operation(16,248,9,34).
operation(16,249,14,22).
operation(16,250,11,19).
operation(16,251,13,32).
operation(16,252,0,29).
operation(16,253,2,13).
operation(16,254,6,35).

%--- Job 17
job(17).
operation(17,255,7,36).
operation(17,256,5,33).
operation(17,257,13,28).
operation(17,258,9,20).
operation(17,259,10,30).
operation(17,260,4,33).
operation(17,261,14,29).
operation(17,262,0,34).
operation(17,263,3,22).
operation(17,264,11,12).
operation(17,265,6,30).
operation(17,266,8,12).
operation(17,267,1,35).
operation(17,268,2,13).
operation(17,269,12,35).

%--- Job 18
job(18).
operation(18,270,14,26).
operation(18,271,11,31).
operation(18,272,5,35).
operation(18,273,2,38).
operation(18,274,13,19).
operation(18,275,10,35).
operation(18,276,4,27).
operation(18,277,8,29).
operation(18,278,3,39).
operation(18,279,9,13).
operation(18,280,6,14).
operation(18,281,7,26).
operation(18,282,0,17).
operation(18,283,1,22).
operation(18,284,12,15).

%--- Job 19
job(19).
operation(19,285,1,36).
operation(19,286,7,34).
operation(19,287,11,33).
operation(19,288,8,17).
operation(19,289,14,38).
operation(19,290,6,39).
operation(19,291,5,16).
operation(19,292,3,27).
operation(19,293,13,29).
operation(19,294,2,16).
operation(19,295,0,16).
operation(19,296,4,19).
operation(19,297,9,40).
operation(19,298,12,35).
operation(19,299,10,39).

