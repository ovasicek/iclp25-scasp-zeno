TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# base

run-ok:
	${TIME} oscasp -s0 ../axioms/bec_scasp-small.pl ./model.pl

run-no_can-ok:
	${TIME} oscasp -s0 ../axioms/bec_scasp-small-no_can_order.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# alternative (one non-terminating)

run-alt-ok:
	${TIME} oscasp -s0 ../axioms/bec_scasp-small.pl ./model-alt.pl

run-alt-no_can-non_term:
	${TIME} oscasp -s0 ../axioms/bec_scasp-small-no_can_order.pl ./model-alt.pl


#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-small.pl ./model.pl --tree" ./logs/trace.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-small-no_can_order.pl --tree" ./logs/trace-no_can_order.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-small.pl ./model-alt.pl --tree" ./logs/trace-alt.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-small-no_can_order.pl ./model-alt.pl -v6 --timeout=1000" ./logs/trace-alt-no_can_order-non_term.log


#-----------------------------------------------------------------------------------------------------------------------
# automatically makes can_* rules

preprocess:
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model ./model.pl
