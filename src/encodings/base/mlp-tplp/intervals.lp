%================================================
% Intervals
%================================================
_i(I) :- output(eventually(I,V),B).
_i(I) :- output(always(I,V),B).
_i(I) :- output(next(I,V),B).

