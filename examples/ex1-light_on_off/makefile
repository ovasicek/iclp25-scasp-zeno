TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# base

run-ok:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl

run-no_can-ok:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-small-no_can_order.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# alternative (one non-terminating)

run-alt-ok:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-small.pl ./model-alt.pl

run-alt-no_can-non_term:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-small-no_can_order.pl ./model-alt.pl


#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl --tree" ./logs/ok.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-small-no_can_order.pl ./model.pl --tree" ./logs/ok-no_can.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-small.pl ./model-alt.pl --tree" ./logs/alt.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-small-no_can_order.pl ./model-alt.pl -v6 --timeout=1000" ./logs/alt-no_can-non_term.log
