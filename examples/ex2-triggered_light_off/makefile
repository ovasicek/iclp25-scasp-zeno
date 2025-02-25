TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# non-terminating

# uses smaller simplified axioms to make the trace simpler 
run-non_term-small_axioms:
	${TIME} oscasp -s0 ../axioms/bec_scasp-pca_pump-small_wcan.pl ./model.pl

# full axioms non-terminate as well
run-non_term-full_axioms:
	${TIME} oscasp -s0 ../axioms/bec_scasp-pca_pump-new_not_stopped.pl ./model.pl


#-----------------------------------------------------------------------------------------------------------------------
# fixed

run-fixed-epsilon:
	${TIME} oscasp -s0 ../axioms/bec_scasp-pca_pump-new_not_stopped.pl ./model-fixed-epsilon.pl -r

run-fixed-holdsAtDur:
	${TIME} oscasp -s0 ../axioms/bec_scasp-pca_pump-new_not_stopped.pl ./model-fixed-holdsAtDur.pl -r










#-----------------------------------------------------------------------------------------------------------------------
# makes snapshots of the resolution trace using !spy
# uses a timeout due to the non-termination
# each run might produce a trace of different length
trace-non_term-small_axioms:
	../maketrace.sh "oscasp -s0 ../axioms/bec_scasp-pca_pump-small_wcan.pl ./model.pl -v6 --timeout=3000" ./logs/trace.log

trace-non_term-full_axioms:
	../maketrace.sh "oscasp -s0 ../axioms/bec_scasp-pca_pump-new_not_stopped.pl ./model.pl -v6 --timeout=3000" ./logs/trace.log


#-----------------------------------------------------------------------------------------------------------------------
# automatically makes can_* rules
preprocess:
	../preprocess_model.sh model model.pl
