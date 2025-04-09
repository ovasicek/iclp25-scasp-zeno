#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

#include '../../axioms/general_utils.pl'.             % include not_happens

max_time(100).


% ----- domain model -----

endOfMonth(6).

fluent(balance(A, M)).
fluent(minimumBalance(A, M)).
fluent(serviceFee(A, M)).
fluent(serviceFeeCharged(A)).

event(transfer(A1, A2, M)).
event(chargeServiceFee(A)).
event(monthlyReset(A)).


%% basic operation of the account -- next 4 rules
%% if balance of account A1 is greater equal to the amount to be transfered,
%% and the amount is transfered from A1 to account A2,
%% then the balance of A1 decreses and of A2 increases
% new balance of A2 (receives payment)
initiates(transfer(A1, A2, TransM12), balance(A2, SUM), T) :-
    TransM12 .>. 0,
    SrcM1 .>=. TransM12,
    SUM .=. DstM2 + TransM12,
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T).
% terminate old balance of A2
terminates(transfer(A1, A2, TransM12), balance(A2, DstM2), T) :-
    TransM12 .>. 0,
    SrcM1 .>=. TransM12,
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T).
% new balance of A1 (sends payment)
initiates(transfer(A1, A2, TransM12), balance(A1, SUM), T) :-
    not_happens(chargeServiceFee(A1), T),
    TransM12 .>. 0,
    SrcM1 .>=. TransM12,
    SUM .=. SrcM1 - TransM12,
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T).
% terminate old balance of A1
terminates(transfer(A1, A2, TransM12), balance(A1, SrcM1), T) :-
    not_happens(chargeServiceFee(A1), T),
    TransM12 .>. 0,
    SrcM1 .>=. TransM12,
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T).


% when a service fee is charged, then a note is made to avoid repeated charging
initiates(chargeServiceFee(A), serviceFeeCharged(A), T).
% this is reset every month
terminates(monthlyReset(A), serviceFeeCharged(A), T).

% if a service fee is charged, then the balance of the account is decreased
% new balance
initiates(chargeServiceFee(A), balance(A, SUM), T) :-   % bound to the transfer event
    happens(transfer(A, _, TransfM), T),
    holdsAt(serviceFee(A, FeeM), T),
    SUM .=. OldM - (TransfM + FeeM),
    holdsAt(balance(A, OldM), T).
initiates(chargeServiceFee(A), balance(A, SUM), T) :-   % bound to the monthly reset event
    happens(monthlyReset(A), T),
    holdsAt(serviceFee(A, FeeM), T),
    SUM .=. OldM - FeeM,
    holdsAt(balance(A, OldM), T).
% terminate old balance
terminates(chargeServiceFee(A), balance(A, OldM), T) :-
    holdsAt(balance(A, OldM), T).


% if the balance of an account falls below the minimum
% and a service fee has not yet been charged
% then a service fee will be charged
happens(chargeServiceFee(A), T) :- !spy,    % bound to the transfer event
    happens(transfer(A, _, TransfM), T),
    not_holdsAt(serviceFeeCharged(A), T),
    holdsAt(minimumBalance(A, MinM), T),
    NewB .=. OldB - TransfM,
    NewB .<. MinM,
    holdsAt(balance(A,OldB), T).
happens(chargeServiceFee(A), T) :- !spy,    % bound to the monthly reset event
    happens(monthlyReset(A), T),
    terminates(monthlyReset(A), serviceFeeCharged(A), T),
    holdsAt(minimumBalance(A, MinM), T),
    B .<. MinM,
    holdsAt(balance(A,B), T).

% end of month means reseting the "serviceFeeCharged" flag
happens(monthlyReset(A), T) :- endOfMonth(T).


% ----- narrative & queries  -----

initiallyP(balance(account1, 10)).
initiallyP(balance(account2, 10)).
initiallyP(minimumBalance(account1, 5)).
initiallyP(minimumBalance(account2, 5)).
initiallyP(serviceFee(account1, 1)).
initiallyP(serviceFee(account2, 1)).
initiallyN(F) :- not initiallyP(F).

happens(transfer(account1, account2, 2),    1).
?- holdsAt(balance(account1, X),            2). % 8

happens(transfer(account1, account2, 4),    2).
?- T .>=. 2, T .=<. 3,
   happens(chargeServiceFee(account1),      T). % 2
?- holdsAt(balance(account1, X),            4). % 3

?- happens(monthlyReset(account1),          T). % 6
?- T .>=. 6, T .=<. 7,
   happens(chargeServiceFee(account1),      T).
?- holdsAt(balance(account1, X),            8). % 2


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */