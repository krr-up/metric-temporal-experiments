% 1{n_jobs(1..4)}1.
% 1{n_machines(1..3)}1.

#const n_jobs=3.
#const n_machines=3.
#const duration_factor=1.
#const min_duration=1.
#const max_duration=4.

job(1..n_jobs).
machine(1..n_machines).
1{duration(J,min_duration..max_duration)}1:-job(J),machine(M).
duration(J,M,D):-duration(J,D),machine(M).

% limit(X/n_machines):- #sum{T,J,M:duration(J,M,T)}=X.

% Try to get different distances (This will change if we get the actual instances)
variability(X):-#count{1,D : duration(J,D)}=X.
possible_variability(0..(max_duration-min_duration+1)).
#heuristic variability(V):possible_variability(V). [1+V,true]

#show job/1.
#show machine/1.
#show duration(J,M,T*duration_factor):duration(J,M,T).
% #show limit(L*duration_factor):limit(L).

