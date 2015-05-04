attach(clinical_expr_integration)
set.seed(459)
test.rows <- sample(1:nrow(clinical_expr_integration), size=82, replace=FALSE)
train <- clinical_expr_integration[-test.rows,]
test <- clinical_expr_integration[test.rows,]

summary(train)
summary(test)