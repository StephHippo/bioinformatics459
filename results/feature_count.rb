# To Run: Type = "clin, expr, or clin_expr"
# Must be in same folder as subfolders of feature data
def map_features(type)
	features = {}
	files = Dir.entries("#{type}/").keep_if{|f| f.include? ".csv"}
	files.each do |file|
		CSV.foreach("#{type}/#{file}") do |row|
			if row.last.to_f > 0
				features[row.first] = 0 unless features.has_key? row.first
				features[row.first] += 1
			end
		end
	end
	features.each{|key, value| puts "#{key}:(#{value}), "}
end