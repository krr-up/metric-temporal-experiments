%================================================
% Formulas in the program
%================================================

% We can just use output/2


% _formula(initially) :- output(initially,_).
% _formula(finally) :- output(initially,_).
% _formula(eventually(I,V)) :- output(eventually(I,V),_).
% _formula(always(I,V)) :- output(always(I,V),_).
% _formula(next(I,V)) :- output(next(I,V),_).
% _formula(V) :- output(eventually(I,V),_).
% _formula(V) :- output(always(I,V),_).
% _formula(V) :- output(next(I,V),_).

