TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

run-ok:
	${TIME} oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar1.pl

run-non_term:
	${TIME} oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar2.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar2.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-fixed-split_no_start:
	${TIME}  oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model-fixed-split_no_start.pl

run-fixed-split_holdsAt4:
	${TIME}  oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model-fixed-split_holdsAt4.pl


#-----------------------------------------------------------------------------------------------------------------------
# makes snapshots of the resolution trace using !spy
# uses a timeout for the non-terminating cases
# each run might produce a trace of different length due to the timeout

trace:
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar1.pl --tree" ./logs/trace-ok.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar2.pl -v6 --timeout=1000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model.pl ./model-nar2.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model-fixed-split_no_start.pl --tree" ./logs/trace-fixed-split_no_start.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-interval_not.pl ./model-fixed-split_holdsAt4.pl --tree" ./logs/trace-fixed-split_holdsAt4.log


#-----------------------------------------------------------------------------------------------------------------------
# automatically makes can_* rules

preprocess:
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model ./model.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-fixed-split_no_start ./model-fixed-split_no_start.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-fixed-split_holdsAt4 ./model-fixed-split_holdsAt4.pl
