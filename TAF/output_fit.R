## Extract model fit results, write TAF output tables

## Before: 09.par, length.fit, plot-09.par.rep, test_plot_output (model)
## After:  cpue.csv, length.comps.csv, likelihoods.csv, stats.csv (output)

library(TAF)
taf.library(FLR4MFCL)
source("utilities.R")  # reading

mkdir("output")

# Read MFCL output files
par <- reading("parameters", read.MFCLPar(finalPar("model")))
rep <- reading("model estimates", read.MFCLRep(finalRep("model")))
like <- reading("likelihoods", read.MFCLLikelihood("model/test_plot_output"))
lenfit <- reading("length fits", read.MFCLLenFit("model/length.fit"))

# Model stats
npar <- n_pars(par)
objfun <- obj_fun(par)
gradient <- max_grad(par)
stats <- data.frame(npar, objfun, gradient)

# Likelihoods
likelihoods <- summary(like)
likelihoods <- as.data.frame(as.list(likelihoods$likelihood))
names(likelihoods) <- summary(like)$component
likelihoods$bhsteep <- likelihoods$effort_dev <- NULL
likelihoods$catchability_dev <- likelihoods$tag_data <- NULL
likelihoods$total <- likelihoods$weight_comp <- NULL
likelihoods$penalties <- obj_fun(par) - sum(likelihoods)

# CPUE
obs <- as.data.frame(cpue_obs(rep))
pred <- as.data.frame(cpue_pred(rep))
names(obs)[names(obs) == "data"] <- "obs"
names(pred)[names(pred) == "data"] <- "pred"
cpue <- cbind(obs, pred["pred"])
cpue <- cpue[cpue$unit %in% 18:20,]
names(cpue)[names(cpue) == "unit"] <- "fishery"
cpue$area <- NA_integer_
cpue$fishery <- as.integer(cpue$fishery)
cpue$area[cpue$fishery %in% 18:19] <- 1
cpue$area[cpue$fishery == 20] <- 2
cpue$obs <- exp(cpue$obs)
cpue$pred <- exp(cpue$pred)
cpue <- cpue[!is.na(cpue$obs),]  # remove unneeded rows
cpue$age <- cpue$iter <- NULL    # remove unneeded columns

# Length comps
length.comps <- lenfits(lenfit)
length.comps$season <- (1 + length.comps$month) / 3
names(length.comps)[names(length.comps) == "sample_size"] <- "ess"
length.comps <- length.comps[c("year", "season", "fishery", "ess",
                               "length", "obs", "pred")]

# Write TAF tables
write.taf(cpue, dir="output")
write.taf(length.comps, dir="output")
write.taf(likelihoods, dir="output")
write.taf(stats, dir="output")
