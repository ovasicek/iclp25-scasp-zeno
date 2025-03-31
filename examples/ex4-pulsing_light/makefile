TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

run-non_term:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-fixed-context_free:
	${TIME}  scasp -s0 --ec ../axioms/bec_scasp.pl ./fix-context_free.pl

run-fixed-holdsAt4:
	${TIME} scasp -s0 --ec ../axioms/bec_scasp.pl ./fix-holdsAt4.pl

run-fixed-incr:
	${TIME} oscasp -s0 --ec --incremental ../axioms/bec_scasp.pl ./fix-incr.pl


#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl -v6 --timeout=3000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp.pl ./fix-context_free.pl --tree" ./logs/trace-fixed-context_free.log
	../scripts/maketrace.sh "scasp -s0 --ec ../axioms/bec_scasp.pl ./fix-holdsAt4.pl --tree" ./logs/trace-fixed-holdsAt4.log
	../scripts/maketrace.sh "oscasp -s0 --ec --incremental -w ../axioms/bec_scasp.pl ./fix-incr.pl --tree" ./logs/trace-fixed-incr.log ; grep "WARNING" ./logs/trace-fixed-incr.log > ./logs/trace-fixed-incr_facts.log
