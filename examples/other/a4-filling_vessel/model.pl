#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).


% ----- domain model -----

fluent(filling).
fluent(spilling).

fluent(level(X)).
fluent(leaked(X)).

event(tapOn).
event(tapOff).
event(overflow).

max_level(10).


% tapOn start filling if not full yet
initiates(tapOn, filling, T) :- max_level(Max), X .<. Max, holdsAt(level(X), T).

% tapOn start spilling if already full
initiates(tapOn, spilling, T) :- max_level(Max), X .=. Max, holdsAt(level(X), T).

% tapOn releases level if not full yet
releases(tapOn, level(_), T) :- max_level(Max), X .<. Max, holdsAt(level(X), T).

% tapOn releases leaked if already full
releases(tapOn, leaked(_), T) :- max_level(Max), X .=. Max, holdsAt(level(X), T).


% tapOff stops filling if currently filling (condition optional)
terminates(tapOff, filling, T) :- holdsAt(filling, T).

% tapOff stops spilling if currently spilling  (condition optional)
terminates(tapOff, spilling, T) :- holdsAt(spilling, T).

% tapOff initiates the new constant value of level if was currently filling  
initiates(tapOff, level(X), T) :- holdsAt(filling, T), holdsAt(level(X), T).
terminates(tapOff, level(X), T) :- holdsAt(filling, T), X .<>.Y, holdsAt(level(Y), T).

% tapOff initiates the new constant value of leaked if was currently spilling
initiates(tapOff, leaked(X), T) :- holdsAt(spilling, T), holdsAt(leaked(X), T).
terminates(tapOff, leaked(X), T) :- holdsAt(spilling, T), X .<>.Y, holdsAt(leaked(Y), T).


% overflow starts spilling 
initiates(overflow, spilling, T).

% overflow stops filling
terminates(overflow, filling, T).

% overflow initiates the new constant value of level (was continuously increasing up till now, but now will be constant)
initiates(overflow, level(X), T) :- holdsAt(level(X), T).
terminates(overflow, level(X), T) :- X .<>.Y, holdsAt(level(Y), T).

% overfow releases leaked because it will now start continuously increasing and was constant up till now
releases(overflow, leaked(_), T).

    
% trajectory for increasing the level while filling
trajectory(filling, T1, level(X2), T2) :-
    X2 .=. X1 + (T2 - T1),
    holdsAt(level(X1), T1).

% trajectory for increasing the leaked while spilling
trajectory(spilling,T1,leaked(X2),T2) :-
    X2 .=. X1 + (T2 - T1),
    holdsAt(leaked(X1), T1).


% overflow happens when ma level is reached
happens(overflow, T) :- !spy,
    max_level(Max),
    holdsAt(level(Max), T).


% ----- narrative & queries  -----

initiallyP(level(0)).
initiallyP(leaked(0)).
initiallyN(F) :- not initiallyP(F).

happens(tapOn, 5).
happens(tapOff, 20).

?- holdsAt(level(X),    0).     % 0       
?- holdsAt(level(X),    4).     % 0       
?- holdsAt(level(X),    8).     % 3             
?- holdsAt(level(X),    14).    % 9       
?- holdsAt(level(X),    19).    % 10
?- not_holdsAt(level(X),19).    % X1 < 10; X2 > 10

?- holdsAt(level(7),    T).     % 12
?- holdsAt(level(12),   T).     % no          

?- happens(overflow,    T).     % 15
?- holdsAt(spilling,    T).     % 15 < T =< 20

?- holdsAt(leaked(X),   0).     % 0
?- holdsAt(leaked(X),   8).     % 0
?- holdsAt(leaked(X),   14).    % 0            
?- holdsAt(leaked(X),   19).    % 4       
?- holdsAt(leaked(X),   22).    % 5

?- holdsAt(level(X1),   25),    % 10
   holdsAt(leaked(X2),  25).    % 5


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */