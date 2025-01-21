always((0,10),a) :- initially.
eventually((10,11),top) :- initially.
% b :- next((10,11), eventually_before((4,5),a)).

b :- eventually((10,11), eventually_before((4,5),a)).
eventually((10,11), eventually_before((4,5),top)):- initially.


#external initially.
#external eventually((10,11),top).
#external  next((10,11), eventually_before((4,5),a)).
#external a.
#external top.