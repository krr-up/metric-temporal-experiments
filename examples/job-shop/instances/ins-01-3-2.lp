job(1..3). machine(1..2).
duration(1,1,3).
duration(1,2,4).
duration(2,1,1).
duration(2,2,6).
duration(3,1,5).
duration(3,2,5).
sequence(1,1,1).
sequence(1,2,2).
sequence(2,1,1).
sequence(2,2,2).
sequence(3,1,1).
sequence(3,2,2).

operation(J,J*100+P,M,D):-duration(J,M,D), sequence(J,M,P).
meta(optimum,15).
% before(O1,O1+1):- operation(J,O1,M1,D1), operation(J,O1+1,M2,D2).
