TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

run-non_term:
	${TIME} oscasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} oscasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-fixed-epsilon:
	${TIME} oscasp -s0 --ec ../axioms/bec_scasp-small.pl ./fix-epsilon.pl -r

run-fixed-remodel:
	${TIME} oscasp -s0 --ec ../axioms/bec_scasp-small.pl ./fix-remodel.pl

run-fixed-holdsAt4:
	${TIME} oscasp -s0 --ec ../axioms/bec_scasp.pl ./fix-holdsAt4.pl -r


#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "oscasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl -v6 --timeout=3000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "oscasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "oscasp -s0 --ec ../axioms/bec_scasp-small.pl ./fix-epsilon.pl --tree -r" ./logs/trace-fixed-epsilon.log
	../scripts/maketrace.sh "oscasp -s0 --ec ../axioms/bec_scasp-small.pl ./fix-remodel.pl --tree" ./logs/trace-fixed-remodel.log
	../scripts/maketrace.sh "oscasp -s0 --ec ../axioms/bec_scasp.pl ./fix-holdsAt4.pl --tree -r" ./logs/trace-fixed-holdsAt4.log


#-----------------------------------------------------------------------------------------------------------------------
# automatically makes can_* rules

preprocess:
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model ./model.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/fix-epsilon ./fix-epsilon.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/fix-remodel ./fix-remodel.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/fix-holdsAt4 ./fix-holdsAt4.pl
