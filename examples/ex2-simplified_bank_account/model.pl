#include './model-preprocessed.pl'. % include the can_* rules
#show happens/2, holdsAt/2.
#show stoppedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).                      % it is useful to have an upper bound on time for the full axioms


% ----- domain model -----

fluent(balance(M)).
fluent(noServiceFeeYet).

event(withdraw(M)).
event(serviceFee).

initiates(withdraw(X), balance(NewB), T) :-
    NewB .=. OldB - X,
    holdsAt(balance(OldB), T).
terminates(withdraw(_), balance(OldB), T) :-
    holdsAt(balance(OldB), T).

terminates(serviceFee, noServiceFeeYet, T).

initiates(serviceFee, balance(NewB), T) :-
    NewB .=. OldB - 10,
    holdsAt(balance(OldB), T).
terminates(serviceFee, balance(OldB), T) :-
    holdsAt(balance(OldB), T).

happens(serviceFee, T) :- !spy,
    holdsAt(noServiceFeeYet, T),
    Balance .<. 1000,
    holdsAt(balance(Balance), T).


% ----- narrative & queries  -----

initiallyP(balance(10000)).
initiallyP(noServiceFeeYet).
initiallyN(F) :- not initiallyP(F).

happens(withdraw(8000), 10).
happens(withdraw(1500), 20).

?- holdsAt(balance(X),  5).   % non-term., should be 10000
?- holdsAt(balance(X),  15).  % non-term., should be 2000
?- holdsAt(balance(X),  25).  % non-term., should be 490
?- happens(serviceFee,  T).   % non-term., should be smallest T > 20


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
