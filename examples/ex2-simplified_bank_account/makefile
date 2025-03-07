TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

# uses smaller simplified axioms to make the trace simpler 
run-non_term:
	${TIME} oscasp -s0 ../axioms/bec_scasp-small.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# auto detect and halt

run-zeno_halt:
	${TIME} oscasp -s0 ../axioms/bec_scasp-small.pl ./model.pl --zeno_halt


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-fixed-epsilon:
	${TIME} oscasp -s0 ../axioms/bec_scasp-small.pl ./model-fixed-epsilon.pl
	
run-fixed-remodel:
	${TIME} oscasp -s0 ../axioms/bec_scasp-small.pl ./model-fixed-remodel.pl


#-----------------------------------------------------------------------------------------------------------------------
# log the resolution tree of the answer for terminating examples
# and trace the building of the resolution tree via !spy and a timeout for non-terminating examples

trace:
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-small.pl ./model.pl -v6 --timeout=3000" ./logs/trace-non_term.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-small.pl ./model.pl --zeno_halt --tree" ./logs/trace-zeno_halt.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-small.pl ./model-fixed-epsilon.pl --tree -r" ./logs/trace-fixed-epsilon.log
	../scripts/maketrace.sh "oscasp -s0 ../axioms/bec_scasp-small.pl ./model-fixed-remodel.pl --tree " ./logs/trace-fixed-remodel.log


#-----------------------------------------------------------------------------------------------------------------------
# automatically makes can_* rules

preprocess:
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model ./model.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-fixed-epsilon ./model-fixed-epsilon.pl
	../scripts/preprocess_model.sh ./preprocessed_can_rules/model-fixed-remodel ./model-fixed-remodel.pl
