slides <- list.files(path = "/home/lbelzile/Documents/Dropbox/website/MATH60604A-slides", pattern = "*.html")
ns <- length(slides)
codedir <- "../code"
names <- c("Course Outline",
           "Hypothesis Tests",
           "Central Limit Theorem",
           "Exploratory Data Analysis")
week <- as.numeric(substr(slides, 13,13))
video <- c("https://youtu.be/9U1WCxFUmjA",
            "https://youtu.be/TSMuEX8FqYo",
            "https://youtu.be/nCUT05szKwQ",
            "https://youtu.be/5Yc46pAQpFk")
if(length(names) - length(video) > 0){
  video <- c(video, rep("", length(names) - length(video)))
}
linkgithub <- "https://raw.githubusercontent.com/lbelzile/statmod/master/"

codesas <- list.files(path = codedir, pattern = "*.sas")
codestr <- rep("", ns)
nid <- sapply(substr(codesas,12,13), function(x){which(x == substr(slides[-1], 13,14))})
codestr[nid+1L] <- paste0("[SAS](",linkgithub, "code/", codesas,")")

codeR <- list.files(path = codedir, pattern = "*.R")
codeRstr <- rep("", ns)
nid <- sapply(substr(codeR,12,13), function(x){which(x == substr(slides[-1], 13,14))})
codeRstr[nid+1L] <- paste0("[R](",linkgithub,"code/", codeR,")")


url <- "https://lbelzile.github.io/MATH60604A-slides/"
sldat <- data.frame('W' = week, 
                    Slides = paste0("[",names,"](",url, slides,")"),
                    Videos =  paste0("[videos](", video, ")"),
                    SAS = codestr,
                    R = codeRstr)
