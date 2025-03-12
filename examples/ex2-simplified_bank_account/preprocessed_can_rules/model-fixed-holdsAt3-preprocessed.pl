
can_initiates(serviceFee, balance(NewB), T).
can_initiates(withdraw(X), balance(NewB), T).
can_terminates(serviceFee, balance(OldB), T).
can_terminates(serviceFee, noServiceFeeYet, T).
can_terminates(withdraw(_), balance(OldB), T).
