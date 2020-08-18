exdir <- "../exercises"

## exercise and solution files
fn <- FALSE
ex <- list.files(path = exdir, pattern = "MATH60604A-Exercise[[:digit:]].pdf", 
    full.names = fn)
codesas <- list.files(path = exdir, pattern = "MATH60604A-Exercise[[:digit:]].sas", 
                 full.names = fn)
coder <- list.files(path = exdir, pattern = "MATH60604A-Exercise[[:digit:]].R", 
                      full.names = fn)
so <- list.files(path = exdir, pattern = "MATH60604A-Exercise[[:digit:]]-sol.pdf", 
    full.names = fn)



## Numbers + Topics
# exid <- as.numeric(gsub("[^0-9.-]+", "", ex))
topics <- 
  c("Basics of statistical inference", 
    "Linear regression",
    "Likelihood methods",
    "Generalized linear models",
    "Correlated and longitudinal data",
    "Linear mixed models",
    "Survival analysis")
exdat <- data.frame(Chapter = topics)


## Links
linkstring <- "https://nbviewer.jupyter.org/github/lbelzile/statmod/blob/master/exercises/"
linkgithub <- "https://raw.githubusercontent.com/lbelzile/statmod/master/"
exdat$Exercice <- c(paste0("[exercise](", linkstring, ex, ")"),rep("", length.out = 7-length(ex)))
exdat$Solution <- c(paste0("[solution](", linkstring, so, ")"),rep("", length.out = 7-length(so)))
exdat$`Code SAS` <- c(paste0("[code SAS](", linkgithub, "exercises/",codesas, ")"),rep("", length.out = 7-length(codesas)))
exdat$`Code R` <- c(paste0("[code R](", linkgithub, "exercises/", coder, ")"),rep("", length.out = 7-length(coder)))

