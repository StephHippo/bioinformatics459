require 'csv'

clinical_path = "Clinical/Biotab/"
clinical_files = Dir.entries(clinical_path).keep_if{|f| f.include?("nationwidechildrens.org_clinical_")}

patients = {}
FIRST_DATA = 3 # Row in which patient data first appears
clinical_files.each do |clinical_file|
	parsed_file = CSV.read("#{clinical_path}#{clinical_file}", { :col_sep => "\t" })
	headers = parsed_file.first
	explanation_headers = parsed_file[1]
	parsed_file.each do |row|
		headers.each_with_index do |header, index|
			patients[row.first] = {} unless patients.has_key? rows.first
			patients[row.first][header] = row[index] 
		end
	end	
end

# All clinical data merged. No loss of patients, but uncleaned data.
# 409 patients

# Map patient barcodes to their Expression Protein Data
# Grab the patient uuid
# Find the corresponding expression file
expression_path = "Expression-Protein/MDA__MDA_RPPA_Core/Level_3/"
expression_files = Dir.entries(expression_path)
expr_file_manifest = CSV.read('file_manifest.txt')

# User the manifest to map the file name to the patient barcode to the TCGA paticipant id
expr_file_manifest.keep_if{|line| line.first.split("\t").first == "Expression-Protein" && line.first.split("\t")[3] == "3"}

expr_file_manifest.each do |file|
	data = file.split("\t")	
	participant_id = data[4].match(/TCGA-..-(.{4})/)[1]
	expr_file = data.last
	patients.each do |patient|
		if file.include? patient["bcr_patient_barcode"]
	end
end

# Map patient barcodes to their DNA_Methylation Data

