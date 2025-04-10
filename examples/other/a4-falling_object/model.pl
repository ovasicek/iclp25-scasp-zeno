#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).


% ----- domain model -----

agent(nathan).
object(apple).

fluent(height(O, H)) :- object(O).
fluent(falling(O)) :- object(O).

event(drop(A, O)) :- agent(A), object(O).
event(hitGround(O)) :- object(O).

initHeight(20).
fGravity(1).

%-------------------------------------------------------------------------------
% domain description 
%-------------------------------------------------------------------------------

% [effect]
% if an agent drops an object, then the object will start falling and its height
% will be released from CLoI
initiates(drop(A,O), falling(O), T) :- 
    agent(A), object(O).

% [effect + CLoI]
releases(drop(A,O), height(O,H), T) :-
    agent(A), object(O).

% [triggered event]
% an object hits the ground when its falling and its height becomes zero
happens(hitGround(O), T) :- !spy, holdsAt(height(O,0), T), holdsAt(falling(O), T),
    object(O).

% [effect]
% if an object hits the ground, then it will stop falling
terminates(hitGround(O), falling(O), T) :-
    object(O).

% [effect + CLoI]
% if an object hits the ground then its height will no longer be released from CLoI
initiates(hitGround(O), height(O, 0), T) :-
    object(O).

terminates(hitGround(O), height(O, H), T) :- H .<>. 0,
    object(O).


% motion of an object from the moment it is droped to the moment it hits the ground
trajectory(falling(O), T1, height(O, H2), T2) :- fGravity(G), object(O),
    H2 .=. H1 - G*(T2-T1),  % limited to a constant falling speed
    holdsAt(height(O, H1), T1).


% ----- narrative & queries  -----

initiallyP(height(apple,H)) :- initHeight(H).   % apples height initially is something
initiallyN(F) :- not initiallyP(F).

happens(drop(nathan,apple), 5).                 % nathan drops the apple at time 5

% --> conclude that the apple will hit the ground at time 25
?- happens(hitGround(apple), T).


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */