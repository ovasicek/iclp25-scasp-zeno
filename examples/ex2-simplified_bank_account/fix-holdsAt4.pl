% problems
%   repeated trigger - fixed by introducing a duration using holdsAt/4

#include './preprocessed_can_rules/fix-holdsAt4-preprocessed.pl'. % include the can_* rules
#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
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

duration(1/1000000).
happens(serviceFee, T2) :- !spy,
    duration(Dur),
    B .<. 1000,
    holdsAt(balance(B), T2, Dur, withdraw(_)),
    holdsAt(noServiceFeeYet, T2).


% ----- narrative & queries  -----

initiallyP(balance(10000)).
initiallyP(noServiceFeeYet).
initiallyN(F) :- not initiallyP(F).

happens(withdraw(8000),             10).
happens(withdraw(1500),             20).

?- holdsAt(balance(X),              5).   % 10000
?- holdsAt(balance(X),              15).  % 2000
?- holdsAt(balance(X),              25).  % 490
?- T .=<. 25, happens(serviceFee,   T).   % 20.0
/*


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
