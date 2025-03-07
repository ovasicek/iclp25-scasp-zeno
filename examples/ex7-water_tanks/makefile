TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

run-non_term:
	${TIME} oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-semi_fixed-incremental:
	${TIME} ../scripts/incremental_circular_trajectories.sh ./model-semi_fixed-incremental.pl ../axioms/bec_scasp-interval_not.pl

run-fixed-incremental_holdsAt4:
	${TIME} ../scripts/incremental_circular_trajectories.sh ./model-fixed-incremental_holdsAt4.pl ../axioms/bec_scasp-interval_not.pl

run-fixed-holdsAt4:
	${TIME} oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model-fixed-holdsAt4.pl

#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl -v6 --timeout=1000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "../scripts/incremental_circular_trajectories.sh ./model-semi_fixed-incremental.pl ../axioms/bec_scasp-interval_not.pl --tree" ./logs/trace-semi_fixed-incremental.log
	../scripts/maketrace.sh "../scripts/incremental_circular_trajectories.sh ./model-fixed-incremental_holdsAt4.pl ../axioms/bec_scasp-interval_not.pl --tree" ./logs/trace-fixed-incremental_holdsAt4.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model-fixed-holdsAt4.pl --tree" ./logs/trace-fixed-holdsAt4.log


#-----------------------------------------------------------------------------------------------------------------------
# automatically makes can_* rules

preprocess:
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model ./model.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-semi_fixed-incremental ./model-semi_fixed-incremental.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-fixed-incremental_holdsAt4 ./model-fixed-incremental_holdsAt4.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-fixed-holdsAt4 ./model-fixed-holdsAt4.pl
