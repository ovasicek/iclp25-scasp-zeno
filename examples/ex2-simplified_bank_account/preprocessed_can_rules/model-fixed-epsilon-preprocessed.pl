
can_initiates(serviceFee, balance(NewB)).
can_initiates(withdraw(X), balance(NewB)).
can_terminates(serviceFee, balance(OldB)).
can_terminates(serviceFee, noServiceFeeYet).
can_terminates(withdraw(_), balance(OldB)).
