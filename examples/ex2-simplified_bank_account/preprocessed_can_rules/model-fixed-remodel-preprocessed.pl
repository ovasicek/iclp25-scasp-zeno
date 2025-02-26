
can_initiates(withdraw(X), balance(NewB)).
can_terminates(serviceFee, noServiceFeeYet).
can_terminates(withdraw(_), balance(OldB)).
