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

run-partial_fix-incr:
	${TIME} scasp -s0 --ec --incremental ../axioms/bec_scasp-interval_not.pl ./partfix-incr.pl

run-fixed-incr_holdsAt4:
	${TIME} scasp -s0 --ec --incremental ../axioms/bec_scasp-interval_not.pl ./fix-incr_holdsAt4.pl

run-fixed-holdsAt4:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./fix-holdsAt4.pl

#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl -v6 --timeout=1000" ./logs/non_term.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl --zeno_halt --tree" ./logs/zeno_halt.log
	../scripts/maketrace.sh "scasp -s0 --ec --incremental -w ../axioms/bec_scasp-interval_not.pl ./partfix-incr.pl --tree" ./logs/partfix-incr.log
	../scripts/maketrace.sh "scasp -s0 --ec --incremental -w ../axioms/bec_scasp-interval_not.pl ./fix-incr_holdsAt4.pl --tree" ./logs/fix-incr_holdsAt4.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./fix-holdsAt4.pl --tree" ./logs/fix-holdsAt4.log
