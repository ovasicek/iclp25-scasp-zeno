TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

run-ok:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar1.pl

run-non_term:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar2.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar2.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-fixed-split_no_start:
	${TIME}  scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./fix-split_no_start.pl

run-fixed-split_holdsAt4:
	${TIME}  scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./fix-split_holdsAt4.pl


#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar1.pl --tree" ./logs/trace-ok.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar2.pl -v6 --timeout=1000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar2.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./fix-split_no_start.pl --tree" ./logs/trace-fixed-split_no_start.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-interval_not.pl ./fix-split_holdsAt4.pl --tree" ./logs/trace-fixed-split_holdsAt4.log
