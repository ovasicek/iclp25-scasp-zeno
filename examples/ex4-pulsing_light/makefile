TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

run-non_term:
	${TIME} oscasp -s0 ../axioms/bec_scasp.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} oscasp -s0 ../axioms/bec_scasp.pl ./model.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-fixed-context_free:
	${TIME}  oscasp -s0 ../axioms/bec_scasp.pl ./fix-context_free.pl

run-fixed-holdsAt4:
	${TIME} oscasp -s0 ../axioms/bec_scasp.pl ./fix-holdsAt4.pl

run-fixed-incremental:
	${TIME} ../scripts/incremental_circular_trajectories.sh ./fix-incremental.pl ../axioms/bec_scasp.pl


#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp.pl ./model.pl -v6 --timeout=3000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp.pl ./model.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp.pl ./fix-context_free.pl --tree" ./logs/trace-fixed-context_free.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp.pl ./fix-holdsAt4.pl --tree" ./logs/trace-fixed-holdsAt4.log
	../scripts/maketrace.sh "../scripts/incremental_circular_trajectories.sh ./fix-incremental.pl ../axioms/bec_scasp.pl --tree" ./logs/trace-fixed-incremental.log


#-----------------------------------------------------------------------------------------------------------------------
# automatically makes can_* rules

preprocess:
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model ./model.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/fix-context_free ./fix-context_free.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/fix-holdsAt4 ./fix-holdsAt4.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/fix-incremental ./fix-incremental.pl
