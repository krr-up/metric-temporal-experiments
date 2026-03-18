%================================================
% Intervals HTC
%================================================

%=============  METRIC PART
%----------  Metric interval
outside((M,N),(K,K')):-
    i((M,N)), time(K), time(K'), K<=K', &diff{t(K) -t(K')} > -M.
outside((M,N),(K,K')):-
    i((M,N)), time(K), time(K'), K<=K', &diff{t(K') -t(K)} > N-1, N!=w.

