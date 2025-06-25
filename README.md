# iclp25-scasp-zeno
This is a repository with source codes and experiments for the ICLP'25 paper
"On Zeno-like Behaviors in the Event Calculus with Goal-directed Answer Set Programming"
by Vasicek O., Arias J., Fiedor J., Gupta G., Hall B., Krena B., Larson B., and Vojnar T.

## Directory structure
- `examples/exN-*/`         -- Directories for examples presented in the paper.
  - `examples/exN-*/logs/`    -- Each example includes execution logs.
- `examples/axioms/`        -- Implementations of Event Calculus BEC axioms.
- `examples/apxN-*/`        -- Directories for examples presented in the appendix of the paper.
- `examples/other/n-*/`     -- Directories for extra examples which were not presented in the paper.
- `examples/scripts/`       -- Auxiliary scripts.

## Installing s(CASP)
- See [https://gitlab.software.imdea.org/ciao-lang/sCASP#installation-of-scasp](https://gitlab.software.imdea.org/ciao-lang/sCASP#installation-of-scasp)
- Version of s(CASP) used: 0.25.06.25

## Executing reasoning
- Each example has a `makefile` that can be used to execute it (or to see how to do it manually)
- Logs were produced on a laptop with a Ryzen 7 1.9Ghz CPU
