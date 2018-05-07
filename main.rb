require 'json'
require 'open-uri'
require 'csv'

INPUT_URL = 'https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json'
CSV_OPTIONS = { col_sep: ',', quote_char: '"' }
OUTPUT_PATH = 'output/output.csv'

def parse_input(url)
  data = JSON.parse(open(url).read)
  parsed_data = []
  data.each do |row|
    row = flatten_hash(row)
    row.each do |header, value|
      row[header] = transform_array(value) if value.is_a? Array
    end
    parsed_data << row
  end
  parsed_data
end

def flatten_hash(hash)
  # This method flattens nested hashes
  h = {}
  hash.each do |key, value|
    if value.is_a? Hash
      # Recursive call if the value itself is a hash
      flatten_hash(value).each do |k, v|
        h["#{key}.#{k}"] = v
      end
    else
      h[key] = value
    end
  end
  h
end

def transform_array(array)
  array.join(",")
end

def store_csv(path, options, input)
  data = parse_input(input)
  column_names = data.first.keys
  CSV.open(path, 'wb', options) do |csv|
    csv << column_names
    data.each do |row|
      csv << row.values
    end
  end
end

# p parse_input(INPUT_URL)
store_csv(OUTPUT_PATH, CSV_OPTIONS, INPUT_URL)

