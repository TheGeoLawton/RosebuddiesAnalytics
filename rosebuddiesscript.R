library(tm)
library(wordcloud)
library(dplyr)

fbk = fbOAuth(501083100089647,"0aaa4cd08c7617284e2ef6cf7ef39b73")
result <- getPost(669202253265873,fbk) #default limits to 500 comments
comments <- result$comments

# ------------------------------------------------------Find associations to a given term
findAssocs(dm,"nick",.25)

# ----------------------------------------------------See top 10 users by number of posts
summary1 <- comments %>% group_by(from_name) %>% summarize(count = n()) %>% arrange(desc(count)) %>% top_n(10,count)

#----------------------------------------------Generate word cloud with wordcloud library
#load comments into tm

corpus = Corpus(VectorSource(comments$message))

#process strings, cleaning
corpus <- corpus %>% tm_map(function(x) iconv(x, to="UTF-8", sub="byte")) %>% tm_map(tolower) %>% tm_map(function(x) removeWords(x,stopwords()))

corpus <- corpus %>% tm_map(removePunctuation) %>% tm_map(stripWhitespace)

#convert back into simple text
dm <- corpus %>% tm_map(PlainTextDocument) %>% TermDocumentMatrix()

#prepare matrix of terms and frequencies
m <- as.matrix(dm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
wordcloud(d$word,d$freq,min.freq = 5,max.words = 250,random.order = FALSE, rot.per = 0.35, colors=brewer.pal(8, "Dark2"))