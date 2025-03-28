TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

run-non_term:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-partfix-incr:
	${TIME} ../scripts/incremental_circular_trajectories.sh ./partfix-incr.pl ../axioms/bec_scasp-interval_not.pl

run-fixed-incr_holdsAt4:
	${TIME} ../scripts/incremental_circular_trajectories.sh ./fix-incr_holdsAt4.pl ../axioms/bec_scasp-interval_not.pl

run-fixed-holdsAt4:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./fix-holdsAt4.pl

#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl -v6 --timeout=1000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "../scripts/incremental_circular_trajectories.sh ./partfix-incr.pl ../axioms/bec_scasp-interval_not.pl --tree" ./logs/trace-partfixed-incr.log
	../scripts/maketrace.sh "../scripts/incremental_circular_trajectories.sh ./fix-incr_holdsAt4.pl ../axioms/bec_scasp-interval_not.pl --tree" ./logs/trace-fixed-incr_holdsAt4.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./fix-holdsAt4.pl --tree" ./logs/trace-fixed-holdsAt4.log
