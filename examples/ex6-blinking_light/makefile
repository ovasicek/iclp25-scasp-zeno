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

run-fixed-holdsAt3:
	${TIME} oscasp -s0 ../axioms/bec_scasp.pl ./model-fixed-holdsAt3.pl

run-fixed-event_delay:
	${TIME} oscasp -s0 ../axioms/bec_scasp.pl ./model-fixed-event_delay.pl


#-----------------------------------------------------------------------------------------------------------------------
# makes snapshots of the resolution trace using !spy
# uses a timeout for the non-terminating cases
# each run might produce a trace of different length due to the timeout

trace:
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp.pl ./model.pl -v6 --timeout=1000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp.pl ./model.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp.pl ./model-fixed-holdsAt3.pl --tree" ./logs/trace-fixed-holdsAt3.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp.pl ./model-fixed-event_delay.pl --tree" ./logs/trace-fixed-event_delay.log


#-----------------------------------------------------------------------------------------------------------------------
# automatically makes can_* rules

preprocess:
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model ./model.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-fixed-holdsAt3 ./model-fixed-holdsAt3.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-fixed-event_delay ./model-fixed-event_delay.pl
