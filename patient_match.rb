require 'csv'
require 'set'

clinical_path = "../project_data/Clinical/Biotab/"
clinical_files = Dir.entries(clinical_path).keep_if{|f| f.include?("nationwidechildrens.org_clinical_")}

patients = {}
FIRST_DATA = 3 # Row in which patient data first appears
clinical_files.each do |clinical_file|
  parsed_file = CSV.read("#{clinical_path}#{clinical_file}", { :col_sep => "\t" })
  headers = parsed_file.first
  explanation_headers = parsed_file[1]
  parsed_file.drop(FIRST_DATA).each do |row|
    headers.each_with_index do |header, index|
      patients[row.first] = {} unless patients.has_key? row.first
      patients[row.first][header] = row[index] 
    end
  end	
end

# All clinical data merged. No loss of patients, but uncleaned data.
# 409 patients

# Map patient barcodes to their Expression Protein Data
# Grab the patient uuid
# Find the corresponding expression file
expression_path = "../project_data/Expression-Protein/MDA__MDA_RPPA_Core/Level_3/"
expression_files = Dir.entries(expression_path)
expr_file_manifest = CSV.read('../project_data/file_manifest.txt')

# User the manifest to map the file name to the patient barcode to the TCGA paticipant id
expr_file_manifest.keep_if{|line| line.first.split("\t").first == "Expression-Protein" && line.first.split("\t")[3] == "3"}

expr_file_manifest.each do |row|
  data = row.first.split("\t")	
  participant_id = data[4].match(/TCGA-..-(.{4})/)[1]
  expr_file = data.last
  # Find the patient beter.
  patient = patients.select{|key,values| values["bcr_patient_barcode"].include? participant_id}	
  patient_key = patient.keys.first
  expr_data = CSV.read("#{expression_path}#{expr_file}")
  expr_data.drop(2).each do |row|
    data = row.first.split("\t")
    key = data.first
    value = data.last
    patients[patient_key][key] = value
  end
end

# Write out to CSV.
unique_headers = Set.new
patients.each{|key, values| unique_headers.merge(patients[key].keys.to_set)}
unique_headers = unique_headers.to_a

dropped_headers = []
# Drop all columns with predominantly NA data.
unique_headers.each do |header|
	na_count = 0
	patients.each{ |key, values| na_count+= 1 if (patients[key][header] == "[Not Applicable]" || patients[key][header] == "[Not Available]") }
	dropped_headers << header if (na_count > 0)
end

dropped_headers = dropped_headers.uniq

# For each unique header (which should be the key of the patient hash)
# Write the header column to the CSV
# For every patient, write the value of the column to the csv
# newline break after each patient
csv_headers = unique_headers - dropped_headers

CSV.open("clinical_expr_integration.csv","wb") do |csv|
  csv << csv_headers
  patients.each do |key, value|
    row_data = []
    csv_headers.each do |header|
      goal = patients[key][header]
      if patients[key][header]
        if patients[key][header] == "[Not Available]" || patients[key][header] == "[Not Applicable]"
          row_data << "NA"
        else
          row_data << patients[key][header]
        end
      else
        row_data << ''
      end
    end
    csv << row_data
  end
end

# Map patient barcodes to their DNA_Methylation Data

dna_meth_path = "../project_data/DNA_Methylation/JHU_USC__HumanMethylation27/Level_3/"
dna_meth_files = Dir.entries(dna_meth_path)

# dna_meth_files.each do |dna_meth_files|
#   data = row.first.split("\t")
#   participant_id = 
#
# end
