TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

run-non_term:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-fixed-remodel:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp-small.pl ./fix-remodel.pl

run-fixed-holdsAt4:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp.pl ./fix-holdsAt4.pl -r


#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl -v6 --timeout=3000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-small.pl ./model.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp-small.pl ./fix-remodel.pl --tree" ./logs/trace-fixed-remodel.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp.pl ./fix-holdsAt4.pl --tree -r" ./logs/trace-fixed-holdsAt4.log
