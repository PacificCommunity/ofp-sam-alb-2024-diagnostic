## Run analysis, write model results

## Before: model_results (boot/data)
## After:  09.par, catch.rep, length.fit, plot-09.par.rep,
##         test_plot_output (boot/data/model_results)

library(TAF)

mkdir("model")

# Model results
cp("boot/data/model_results/09.par",           "model")
cp("boot/data/model_results/catch.rep",        "model")
cp("boot/data/model_results/length.fit",       "model")
cp("boot/data/model_results/plot-09.par.rep",  "model")
cp("boot/data/model_results/test_plot_output", "model")
