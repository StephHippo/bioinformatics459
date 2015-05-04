library(glmnet)

clinical_expr_integration <- read.csv("~/Documents/EECS459/bioinformatics459/clinical_expr_integration.csv", header=TRUE)
clin_expr_data_time <- read.csv("~/Documents/EECS459/bioinformatics459/clin_expr_data_time.csv", header=TRUE)

# Sanity check: 409 patients. 182 columns.
ncol(clinical_expr_integration)
nrow(clinical_expr_integration)

# Prepping for lasso
x <- clinical_expr_integration
y <- clin_expr_data_time$time

# Delete useless columns: Barcodes, form dates, consent
x$bcr_patient_uuid <- NULL
x$bcr_patient_barcode <- NULL
x$patient_consent_status <- NULL
x$bcr_drug_uuid <- NULL
x$bcr_drug_barcode <- NULL
x$form_completion_date <- NULL
x$informed_consent_verified <- NULL
x$patient_id <- NULL
x$bcr_followup_barcode <- NULL
x$bcr_followup_uuid <- NULL
x$bcr_radiation_barcode <- NULL
x$bcr_radiation_uuid <- NULL
x$bcr_omf_barcode <- NULL
x$bcr_omf_uuid <- NULL

# Ignore outcome columns
x$vital_status <- NULL 

# All data is uniform
x$tumor_sample_type <- NULL


# Imputate string columns?


# Try using glmnet, data already standardized
fit = glmnet(data.matrix(x), as.numeric(y), standardize = FALSE)
plot(fit)
print(fit)

plot(fit, xvar = "lambda", label = TRUE) 

plot(fit, xvar = "dev", label = TRUE)

# See results
coef.exact = coef(fit, s = 0.5, exact = TRUE)
coef.apprx = coef(fit, s = 0.5, exact = FALSE)
cbind2(coef.exact, coef.apprx)

# Generate Cox models
cox_y <- clin_expr_data_time
cox_y$bcr_patient_uuid <- NULL
cox_y$last_contact_days_to <- NULL
cox_y$bcr_patient_uuid <- NULL
cox_y$bcr_patient_barcode <- NULL
cox_y$vital_status <- as.numeric(vital_status)
cox_y$status <- cox_y$vital_status
cox_y$vital_status <- NULL

fit_nostd_cox = glmnet(data.matrix(x), as.numeric(cox_y), standardize=FALSE, family="cox")
