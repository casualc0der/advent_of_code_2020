require_relative '../day_4/day_4'

require 'tempfile'
RSpec.describe 'Passport Processing' do
  let(:test_data) { <<~FILE
                    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
                    byr:1937 iyr:2017 cid:147 hgt:183cm

                    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
                    hcl:#cfa07d byr:1929

                    hcl:#ae17e1 iyr:2013
                    eyr:2024
                    ecl:brn pid:760753108 byr:1931
                    hgt:179cm

                    hcl:#cfa07d eyr:2025 pid:166559648
                    iyr:2011 ecl:brn hgt:59in
                    FILE
                    }
  describe 'setup' do
    it 'can open a file for processing' do
      file  = Tempfile.new
      file.write('hello world')
      file.flush
      passport_scanner = PassportScanner.new(file)
      expect(passport_scanner.data).not_to be_empty
    end
    it 'can split the lines on blank lines only' do
      file  = Tempfile.new
      file.write(test_data)
      file.flush
      passport_scanner = PassportScanner.new(file)
      expected = [
                    'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd 
                    byr:1937 iyr:2017 cid:147 hgt:183cm',
                    'iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
                    hcl:#cfa07d byr:1929',
                    'hcl:#ae17e1 iyr:2013
                    eyr:2024
                    ecl:brn pid:760753108 byr:1931
                    hgt:179cm',
                    'hcl:#cfa07d eyr:2025 pid:166559648
                    iyr:2011 ecl:brn hgt:59in'
                 ]
      expect(passport_scanner.data.size).to eq(4)
    end
    it 'can sanitize the input to remove extra newlines' do

      file  = Tempfile.new
      file.write(test_data)
      file.flush
      passport_scanner = PassportScanner.new(file)
      expected = [
                    'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm',
                    'iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884 hcl:#cfa07d byr:1929',
                    'hcl:#ae17e1 iyr:2013 eyr:2024 ecl:brn pid:760753108 byr:1931 hgt:179cm',
                    'hcl:#cfa07d eyr:2025 pid:166559648 iyr:2011 ecl:brn hgt:59in'
                 ]
      expect(passport_scanner.sanitized).to eq(expected)
    end
    it 'can create a hash from the data' do

      file  = Tempfile.new
      file.write(test_data)
      file.flush
      passport_scanner = PassportScanner.new(file)
      expected = [
                    {'ecl'=> 'gry', 'pid'=> '860033327', 'eyr'=> '2020', 'hcl'=> '#fffffd', 'byr'=> '1937', 'iyr'=> '2017', 'cid'=> '147', 'hgt'=> '183cm'},
                    {'iyr'=> '2013', 'ecl'=> 'amb', 'cid'=> '350', 'eyr'=> '2023', 'pid'=> '028048884', 'hcl'=> '#cfa07d', 'byr'=> '1929'},
                    {'hcl'=> '#ae17e1', 'iyr'=> '2013', 'eyr'=> '2024', 'ecl'=> 'brn', 'pid'=> '760753108', 'byr'=> '1931', 'hgt'=> '179cm'},
                    {'hcl'=> '#cfa07d', 'eyr'=> '2025', 'pid'=> '166559648', 'iyr'=> '2011', 'ecl'=> 'brn', 'hgt'=> '59in'}
                 ]
      expect(passport_scanner.passenger_data).to eq(expected)
    end
  end

  describe 'part 1' do
    it 'should validate each passengers passport and report total (smol list)' do
      file  = Tempfile.new
      file.write(test_data)
      file.flush
      passport_scanner = PassportScanner.new(file)
      expect(passport_scanner.report).to eq(2)
    end
    it 'should validate each passengers passport and report total (full list)' do
      path = File.expand_path(File.dirname(__FILE__) + "/passports.txt")
      passport_scanner = PassportScanner.new(path)
      expect(passport_scanner.report).to eq(192)
    end
  end
  describe 'part 2' do
    describe 'helper methods' do
      let(:path) { path = File.expand_path(File.dirname(__FILE__) + "/passports.txt") }
      let(:passport_scanner) {PassportScanner.new(path)}
      context '#birth_year_valid?' do
      it 'returns true for valid, false for invalid' do
        expect(passport_scanner.birth_year_valid?('1920')).to eq(true)
        expect(passport_scanner.birth_year_valid?('1919')).to eq(false)
        expect(passport_scanner.birth_year_valid?('1986')).to eq(true)
        expect(passport_scanner.birth_year_valid?('2002')).to eq(true)
        expect(passport_scanner.birth_year_valid?('2003')).to eq(false)
        expect(passport_scanner.birth_year_valid?('123')).to eq(false)
        expect(passport_scanner.birth_year_valid?('12345')).to eq(false)
      end
    end
      context '#issue_year_valid?' do
      it 'returns true for valid, false for invalid' do
        expect(passport_scanner.issue_year_valid?('2010')).to eq(true)
        expect(passport_scanner.issue_year_valid?('2009')).to eq(false)
        expect(passport_scanner.issue_year_valid?('2015')).to eq(true)
        expect(passport_scanner.issue_year_valid?('2020')).to eq(true)
        expect(passport_scanner.issue_year_valid?('2021')).to eq(false)
        expect(passport_scanner.issue_year_valid?('123')).to eq(false)
        expect(passport_scanner.issue_year_valid?('12345')).to eq(false)
      end
    end
      context '#expiration_year_valid?' do
      it 'returns true for valid, false for invalid' do
        expect(passport_scanner.expiration_year_valid?('2020')).to eq(true)
        expect(passport_scanner.expiration_year_valid?('2019')).to eq(false)
        expect(passport_scanner.expiration_year_valid?('2025')).to eq(true)
        expect(passport_scanner.expiration_year_valid?('2030')).to eq(true)
        expect(passport_scanner.expiration_year_valid?('2031')).to eq(false)
        expect(passport_scanner.expiration_year_valid?('123')).to eq(false)
        expect(passport_scanner.expiration_year_valid?('12345')).to eq(false)
      end
    end
      context '#height_valid?' do
      it 'returns true for valid, false for invalid' do
        expect(passport_scanner.height_valid?('150cm')).to eq(true)
        expect(passport_scanner.height_valid?('149cm')).to eq(false)
        expect(passport_scanner.height_valid?('59in')).to eq(true)
        expect(passport_scanner.height_valid?('76in')).to eq(true)
        expect(passport_scanner.height_valid?('78in')).to eq(false)
        expect(passport_scanner.height_valid?('10')).to eq(false)
        expect(passport_scanner.height_valid?('15')).to eq(false)
      end
    end
      context '#hair_colour_valid?' do
      it 'returns true for valid, false for invalid' do
        expect(passport_scanner.hair_colour_valid?('#123abc')).to eq(true)
        expect(passport_scanner.hair_colour_valid?('#123abz')).to eq(false)
        expect(passport_scanner.hair_colour_valid?('123abc')).to eq(false)
      end
    end
      context '#eye_colour_valid?' do
      it 'returns true for valid, false for invalid' do
        expect(passport_scanner.eye_colour_valid?('brn')).to eq(true)
        expect(passport_scanner.eye_colour_valid?('wat')).to eq(false)
        expect(passport_scanner.eye_colour_valid?('hzl')).to eq(true)
      end
    end
      context '#passport_id_valid?' do
      it 'returns true for valid, false for invalid' do
        expect(passport_scanner.passport_id_valid?('000000001')).to eq(true)
        expect(passport_scanner.passport_id_valid?('0123456789')).to eq(false)
        expect(passport_scanner.passport_id_valid?('981726354')).to eq(true)
        expect(passport_scanner.passport_id_valid?('a81726354')).to eq(false)
      end
    end
    end
    it 'should validate each passengers passport and report total (smol list)' do
      file  = Tempfile.new
      file.write(test_data)
      file.flush
      passport_scanner = PassportScanner.new(file)
      expect(passport_scanner.report(:strict)).to eq(2)
    end
    it 'should validate each passengers passport and report total (full list)' do
      path = File.expand_path(File.dirname(__FILE__) + "/passports.txt")
      passport_scanner = PassportScanner.new(path)
      expect(passport_scanner.report(:strict)).to eq(101)
    end
  end
end
