## Run analysis, write model results

## Before: 08.par, alb.age_length, alb.frq, doitall.sh, mfcl.cfg (boot/data),
##         mfclo64 (boot/software)
## After:

library(TAF)

mkdir("model")

# Software
cp("boot/software/mfclo64", "model")

# Input files
cp("boot/data/08.par",         "model")
cp("boot/data/alb.age_length", "model")
cp("boot/data/alb.frq",        "model")
cp("boot/data/doitall.sh",     "model")
cp("boot/data/mfcl.cfg",       "model")

# Run model
setwd("model")
system("doitall.sh")
setwd("..")
