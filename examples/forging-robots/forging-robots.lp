% clingo foreaging.lp --output=reify | clingo - meta-melingo.lp -c horizon=10 0



% searching :- leavingHome.
% searching :- randomWalk.
% searching :- scanArena.
% searching :- moveToFood.
% eventually((0,MAX),not_searching):-start_searching.
% next((0,w),start_searching) :-  leavingHome, not serarching.
% next((0,w),start_searching) :-  leavingHome, not serarching.

% initial state
resting :- initially.

% dynamic laws

% to avoid loops i need a further initially constraint
next((1,5),leavingHome) :- resting, initially.

% Limit the max timing 
eventually((0,10),finally):- initially.

next((2,3),randomWalk) :- leavingHome.
{next((1,100),homing);next((1,100),moveToFood)}=1 :- randomWalk.
{next((1,100),grabFood);next((1,100),homing);next((1,100),scanArena)}=1 :- moveToFood.
{next((1,100),randomWalk);next((1,100),moveToFood);next((1,100),homing)}=1 :- scanArena.
next((2,3),moveToHome):-grabFood.
next((1,15),deposit):-moveToHome.
next((3,4),resting):-deposit.
next((1,15),resting):-homing.





#show show(resting). 
#show show(leavingHome). 
#show show(randomWalk). 
#show show(searching). 
#show show(homing).
#show show(moveToFood).
#show show(scanArena).
#show show(grabFood).
#show show(moveToHome).
#show show(deposit).
#show show(testing).



% Externals (for all temporal atoms in the bodies)
%

#external resting.
#external initially.
#external finally.
#external leavingHome.
#external randomWalk.
#external scanArena.
#external moveToFood.
#external grabFood.
#external moveToHome.
#external deposit.
#external homing.
%#external next((30,resting),0).
