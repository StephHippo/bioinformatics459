library(glmnet)

clinical_expr_integration <- read.csv("~/Documents/EECS459/bioinformatics459/clinical_expr_integration.csv", header=TRUE)
clin_expr_data_time <- read.csv("~/Documents/EECS459/bioinformatics459/clin_expr_data_time.csv", header=TRUE)

# Prepping for lasso
clinical_expr_integration$status <- clin_expr_data_time$vital_status
clinical_expr_integration$time <- clin_expr_data_time$time

# Delete useless columns: Barcodes, form dates, consent
clinical_expr_integration$bcr_patient_uuid <- NULL
clinical_expr_integration$bcr_patient_barcode <- NULL
clinical_expr_integration$patient_consent_status <- NULL
clinical_expr_integration$bcr_drug_uuid <- NULL
clinical_expr_integration$bcr_drug_barcode <- NULL
clinical_expr_integration$form_completion_date <- NULL
clinical_expr_integration$informed_consent_verified <- NULL
clinical_expr_integration$patient_id <- NULL
clinical_expr_integration$bcr_followup_barcode <- NULL
clinical_expr_integration$bcr_followup_uuid <- NULL
clinical_expr_integration$bcr_radiation_barcode <- NULL
clinical_expr_integration$bcr_radiation_uuid <- NULL
clinical_expr_integration$bcr_omf_barcode <- NULL
clinical_expr_integration$bcr_omf_uuid <- NULL

# Ignore outcome columns from predictors
clinical_expr_integration$vital_status <- NULL 

# attach(clinical_expr_integration)
set.seed(459)
test.rows <- sample(1:nrow(clinical_expr_integration), size=82, replace=FALSE)
train <- clinical_expr_integration[-test.rows,]
test <- clinical_expr_integration[test.rows,]

# Organizing training data into x_train and y_train
x_train <- train
x_train$time <- NULL
x_train$status <- NULL
y_train <- data.frame(matrix(ncol=2, nrow=327))
colnames(y_train) <- c("time", "status")
y_train$time <- train$time
y_train$status <- train$status

# Organizing testing data into x_test and y_test
x_test <- test
x_test$time <- NULL
x_test$status <- NULL
y_test <- data.frame(matrix(ncol=2, nrow=82))
colnames(y_test) <- c("time", "status")
y_test$time <- test$time
y_test$status <- test$status

#summary(x_train)
#summary(y_train)
#summary(x_test)
#summary(y_train)

# sink('clinical_expr_lasso.txt')

# Perform feature selection and model generation


# Close output
# sink()

# Generate our graphs