slides <- list.files(path = "/home/lbelzile/Documents/Dropbox/website/MATH60604A-slides", pattern = "*.html")
ns <- length(slides)
codedir <- "../code"
names <- c("Course Outline",
           "Hypothesis Tests",
           "Central Limit Theorem",
           "Exploratory Data Analysis")
semaine <- as.numeric(substr(slides, 13,13))
video <- rep("", length(names))

linkgithub <- "https://raw.githubusercontent.com/lbelzile/statmod/master/"

codesas <- list.files(path = codedir, pattern = "*.sas")
codestr <- rep("", ns)
nid <- sapply(substr(codesas,12,13), function(x){which(x == substr(slides[-1], 12,13))})
codestr[nid+1L] <- paste0("[SAS](",linkgithub, "code/", codesas,")")

codeR <- list.files(path = codedir, pattern = "*.R")
codeRstr <- rep("", ns)
nid <- sapply(substr(codeR,11,12), function(x){which(x == substr(slides[-1], 12,13))})
codeRstr[nid+1L] <- paste0("[R](",linkgithub,"code/", codeR,")")


url <- "https://lbelzile.github.io/MATH60604A-slides/"
sldat <- data.frame('W' = semaine, 
                    Slides = paste0("[",names,"](",url, slides,")"),
                    Videos = video,
                    SAS = codestr,
                    R = codeRstr)
