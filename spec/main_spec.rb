require "main"

INPUT_URL = 'https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json'
OUTPUT_PATH = 'output/output.csv'

RSpec.describe ConvertJsonToCsv do
  describe '#parse_input' do
    it 'should return an array' do
      expect(ConvertJsonToCsv.new.parse_input(INPUT_URL)).to be_a Array
    end

    it 'should not have nested hashes' do
      row = ConvertJsonToCsv.new.parse_input(INPUT_URL).first
      row.each do |k, v|
        expect(v).not_to be_a Hash
      end
    end

    it 'should not have arrays as values' do
      row = ConvertJsonToCsv.new.parse_input(INPUT_URL).first
      row.each do |k, v|
        expect(v).not_to be_a Array
      end
    end
  end

  describe '#transform_array' do
    it 'should transform array values into string with delimiter' do
      expect(ConvertJsonToCsv.new.transform_array(["lorem","ipsum"])).to eq "lorem,ipsum"
    end
  end

  describe '#store_csv' do
    it 'should store a csv identical to the expected one' do
      expected_csv = File.read('output/expected_output.csv')
      ConvertJsonToCsv.new.store_csv(INPUT_URL, OUTPUT_PATH)
      generated_csv = File.read('output/output.csv')
      expect(generated_csv).to eq expected_csv
    end
  end
end
