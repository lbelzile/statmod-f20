index <- c("0_","1a","1b","1c","2a","2b","2c","2d","2e","2f","2g","3_")
index0 <- c("0","1a","1b","1c","2a","2b","2c","2d","2e","2f","2g","3")
names <- c("Course Outline",
           "Hypothesis Tests",
           "Central Limit Theorem",
           "Exploratory Data Analysis",
           "Parameter interpretation (linear model)",
           "Linear transformations",
           "Geometry of least squares",
           "Hypothesis tests (linear model)",
           "Coefficient of determination",
           "Predictions",
           "Interactions",
           "Maximum likelihood estimation"
           )
ns <- length(index)
url <- "https://lbelzile.github.io/MATH60604A-slides/"
codedir <- "../code"

slides <- list.files(path = "/home/lbelzile/Documents/Dropbox/website/MATH60604A-slides", pattern = "MATH60604A_w*.html")
slides <- slides[substr(slides, 1, 12) == "MATH60604A_w"]
sl <- rep("", ns)
pmasl <- na.omit(pmatch(index, substr(slides, start = 13, stop = 14)))
sl[pmasl] <- paste0("[html](",url, slides,")")


slidespdf <- list.files(path = "/home/lbelzile/Documents/Dropbox/website/MATH60604A-slides", pattern = "MATH60604A_w.*.pdf")
slidespdf <- slidespdf[substr(slidespdf, 1, 12) == "MATH60604A_w"]
slpdf <- rep("", ns)
pmaslp <- na.omit(pmatch(index, substr(slidespdf, start = 13, stop = 14)))
slpdf[pmaslp] <- paste0("[pdf](",url, slidespdf,")")


video <- c("https://youtu.be/luOkCcpDSjs",
            "https://youtu.be/TSMuEX8FqYo",
            "https://youtu.be/nCUT05szKwQ",
            "https://youtu.be/5Yc46pAQpFk",
            "https://youtu.be/4jOnZrnPlUM",
            "https://youtu.be/MzmS9r-77lI",
            "https://youtu.be/F9dR6mpOVtI",
            "https://youtu.be/PatlZ9mlVuk",
            "https://youtu.be/IO3et3Uk4mQ"
           )
if(length(names) - length(video) > 0){
  video <- c(video, rep("", length(names) - length(video)))
}
linkgithub <- "https://raw.githubusercontent.com/lbelzile/statmod/master/"

codesas <- list.files(path = codedir, pattern = "MATH60604A.*.sas")
codestr <- rep("", ns)
nid <- sapply(substr(codesas,12,13), function(x){which(x == index)})
codestr[nid] <- paste0("[SAS](",linkgithub, "code/", codesas,")")

codeR <- list.files(path = codedir, pattern = "MATH60604.*.R")
codeRstr <- rep("", ns)
nid <- sapply(substr(codeR,12,13), function(x){pmatch(x, index)})
codeRstr[nid] <- paste0("[R](",linkgithub,"code/", codeR,")")


sldat <- data.frame('S' = index0, 
                    Content = names,
                    Slides = sl,
                    PDF = slpdf,
                    Videos =  paste0("[videos](", video, ")"),
                    SAS = codestr,
                    R = codeRstr)
