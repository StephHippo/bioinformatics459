library(glmnet)
library(lars)

clinical_expr_integration <- read.csv("~/Documents/EECS459/bioinformatics459/clinical_expr_integration.csv", header=TRUE)
clin_expr_data_time <- read.csv("~/Documents/EECS459/bioinformatics459/clin_expr_data_time.csv", header=TRUE)

x <- clinical_expr_integration
y <- clin_expr_data_time$time

// Delete useless columns
x$bcr_patient_uuid <- NULL
x$bcr_patient_barcode <- NULL
x$patient_consent_status <- NULL
x$bcr_drug_uuid <- NULL
x$bcr_drug_barcode <- NULL
x$form_completion_date <- NULL
x$prospective_collection <- NULL
x$retrospective_collection <- NULL
x$vital_status <- NULL // Ignore outcome column
x$initial_pathologic_dx_year <- NULL
x$days_to_initial_pathologic_diagnosis <- NULL //All 0's
x$informed_consent_verified <- NULL
x$patient_id <- NULL
x$icd_o_3_histology <- NULL
x$icd_o_3_site <- NULL
x$tumor_tissue_site <- NULL

// # Impute data or group lasso?
// gender
// history other malignancy
// ajcc_tumor_pathologic_pt
// ajcc_nodes_pathologic_pn
// ajcc_metastasis_pathologic_pm
// er_status_by_ihc
// pr_status_by_ihc
// histological_type
// tissue_source_site
            


# Imputate string columns?

# Try using lars
summary.lars(data.matrix(x), as.numeric(d_or_a), trace = TRUE)



# Try using glmnet
mod <- cv.glmnet(as.matrix(x), y, alpha = 1)