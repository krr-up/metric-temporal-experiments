%================================================
% Intervals
%================================================
i(I) :- output(eventually(I,V),B).
i(I) :- output(always(I,V),B).
i(I) :- output(next(I,V),B).

