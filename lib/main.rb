require 'json'
require 'open-uri'
require 'csv'

class ConvertJsonToCsv
  def parse_input(url)
    # This method returns an array of hashes with all keys flattened
    # and values processed if they are arrays
    parsed_data = []
    JSON.parse(open(url).read).each do |row|
      row_flat = flatten_hash(row)
      row_flat.each do |header, value|
        row_flat[header] = transform_array(value) if value.is_a? Array
      end
      parsed_data << row_flat
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
    # This method takes an array and returns a string
    # with elements from array separated by a coma
    array.join(',')
  end

  def store_csv(input_url, output_path)
    # This method parses a json from the web and stores it in a csv file
    data = parse_input(input_url)
    csv_options = { col_sep: ',', quote_char: '"' }
    CSV.open(output_path, 'wb', csv_options) do |csv|
      csv << data.first.keys # Column names
      data.each do |row|
        csv << row.values
      end
    end
  end
end
