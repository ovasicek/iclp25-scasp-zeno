#include './preprocessed_can_rules/model-fixed-remodel-preprocessed.pl'. % include the can_* rules
#include '../axioms/general_utils.pl'.             % include not_happens
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
    not_happens(serviceFee, T),
    NewB .=. OldB - X,
    holdsAt(balance(OldB), T).
terminates(withdraw(_), balance(OldB), T) :-
    holdsAt(balance(OldB), T).

terminates(serviceFee, noServiceFeeYet, T).

initiates(serviceFee, balance(NewB), T) :-
    happens(withdraw(X), T),
    NewB .=. (OldB - X) - 10,
    holdsAt(balance(OldB), T).
%// terminates(serviceFee, balance(OldB), T)

happens(serviceFee, T) :- !spy,
    happens(withdraw(X), T),
    holdsAt(noServiceFeeYet, T),
    NewB .=. OldB - X,
    NewB .<. 1000,
    holdsAt(balance(OldB), T).


% ----- narrative & queries  -----

initiallyP(balance(10000)).
initiallyP(noServiceFeeYet).
initiallyN(F) :- not initiallyP(F).

happens(withdraw(8000), 10).
happens(withdraw(1500), 20).

?- holdsAt(balance(X),  5).   % 10000
?- holdsAt(balance(X),  15).  % 2000
?- holdsAt(balance(X),  25).  % 490
?- happens(serviceFee,  T).   % 20


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
