%================================================
% Intervals HTC
%================================================

%=============  METRIC PART
%----------  Metric interval
_outside((M,N),(K,J)):-
    _i((M,N)), t(K,D), t(J,D'), time(K), time(J), K<=J,
    D' - D <  M.
_outside((M,N),(K,J)):-
    _i((M,N)), t(K,D), t(J,D'), time(K), time(J), K<=J,
    D' - D >= N , N!=w.

