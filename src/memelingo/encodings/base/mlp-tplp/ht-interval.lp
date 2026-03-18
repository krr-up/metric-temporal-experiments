%================================================
% Intervals HTC
%================================================

%=============  METRIC PART
%----------  Metric interval
outside((M,N),(K,J)):-
    i((M,N)), t(K,D), t(J,D'), time(K), time(J), K<=J,
    D' - D <  M.
outside((M,N),(K,J)):-
    i((M,N)), t(K,D), t(J,D'), time(K), time(J), K<=J,
    D' - D >= N , N!=w.

