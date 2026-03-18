#include "./base/meta.lp".
#include "./base/defined.lp".
#include "./base/show.lp".
#include "./base/mlp-tplp/bounded-basic.lp".
#include "./base/mlp-tplp/bounded-metric.lp".
#include "./base/mlp-tplp/intervals.lp".
#include "./base/mlp-tplp/htcdl-interval.lp".
#include "./base/mlp-tplp/htcdl-time.lp".

% idea :- true(at(2,(2,2)),1), not true(at(2,(_,_)),2), not true(at(2,(_,_)),3), true(at(1,(2,2)),2).
% :- not idea.

% idea :- true(at(2,(7,7)),11), true(at(2,(6,7)),13), true(at(3,(6,7)),11), true(at(2,(7,7)),13).
% :- not idea.

% true(at(2,(7,7)),11)
% true(at(2,(6,7)),13)

% true(at(3,(6,7)),11)
% true(at(3,(6,7)),12)
% true(at(3,(7,7)),13)
