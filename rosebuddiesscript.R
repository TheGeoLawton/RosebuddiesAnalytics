fbk = fbOAuth(501083100089647,"0aaa4cd08c7617284e2ef6cf7ef39b73")
result <- getPost(669202253265873,fbk)
comments <- result$comments

# See top 10 users by number of posts
summary1 <- comments %>% group_by(from_name) %>% summarize(count = n()) %>% arrange(desc(count)) %>% top_n(10,count)