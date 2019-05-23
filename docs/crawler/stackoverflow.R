setwd(dirname(rstudioapi::getSourceEditorContext()$path))
load(".RData")

library(dplyr)
library(rvest)
library(wordcloud)
library(wordcloud2)

to <- 1000

if(!exists("i")){
    from <- 1
    res <- character(0)
} else{
    from <- i
}

for(i in from:to){
    cat("start crawling page #", i, sep="")
    tags <- paste0("https://stackoverflow.com/questions?sort=frequent&page=", i) %>%
        read_html %>%
        html_nodes("#questions .post-tag") %>%
        html_text
    res <- c(res, tags)
}
i = i + 1

freq <- table(res)
#head(sort(freq, decreasing = T))

png("wordcloud_packages.png", width=6,height=4, units='in', res=300)
wordcloud(names(freq), freq, min.freq = 1, scale=c(4,.2), max.words=200, random.order=FALSE, colors=brewer.pal(5,"Dark2"))
dev.off()

save.image(".RData")