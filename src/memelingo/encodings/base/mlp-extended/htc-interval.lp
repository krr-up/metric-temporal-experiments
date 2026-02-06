%================================================
% Intervals HTC
%================================================

%=============  METRIC PART
%----------  Metric interval
_i(I) :- output(eventually(I,V),B).
_i(I) :- output(always(I,V),B).
_i(I) :- output(next(I,V),B).

_outside((M,N),(K,K')):-
    _i((M,N)), time(K), time(K'), K<=K', &sum{t(K); -t(K')} > -M.
_outside((M,N),(K,K')):-
    _i((M,N)), time(K), time(K'), K<=K', &sum{t(K'); -t(K)} > N-1, N!=w.

