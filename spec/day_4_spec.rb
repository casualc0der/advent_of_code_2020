class PassportScanner
  REQUIRED_FIELDS = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
  OPTIONAL_FIELDS = ['cid']
  attr_reader :data
  def initialize(file)
    @data = File.read(file).split("\n\n")
  end

  def sanitized
    @data.map { |str| str.tr("\n", ' ').rstrip }
  end

  def passenger_data
    sanitized.map { |str| str.split(' ').map {|x| x.split(':')} }.map {|p| p.to_h}
  end
  def report(strictness = :lax)
    passenger_data.map { |passport| valid?(passport, strictness) ? 1 : 0 }.sum
  end

  def valid?(passport, flag)
    case flag
    when :lax
      REQUIRED_FIELDS.each {|field| return false unless passport.has_key?(field) }
      true
    when :strict
      REQUIRED_FIELDS.each {|field| return false unless passport.has_key?(field) }
      return false unless birth_year_valid?(passport['byr'])
      return false unless issue_year_valid?(passport['iyr'])
      return false unless expiration_year_valid?(passport['eyr'])
      return false unless height_valid?(passport['hgt'])
      return false unless hair_colour_valid(passport['hcl'])
      return false unless eye_colour_valid(passport['ecl'])
      return false unless passport_id_valid?(passport['pid'])
      true
    end
  end

  def birth_year_valid?(field)
    return false unless field.size == 4
    return false if field.to_i < 1920
    return false if field.to_i > 2002
    true
  end
  def issue_year_valid?(field)
    return false unless field.size == 4
    return false if field.to_i < 2010
    return false if field.to_i > 2020
    true
  end
  def expiration_year_valid?(field)
    return false unless field.size == 4
    return false if field.to_i < 2020
    return false if field.to_i > 2030
    true
  end
  def height_valid?(field)
    return false unless field.include?('cm') || field.include?('in')
    if field.include?('cm')
      height = field.split('cm').first.to_i
      return false if height < 150
      return false if height > 193
    else
      height = field.split('in').first.to_i
      return false if height < 59
      return false if height > 76
    end
    true
  end

  def hair_colour_valid?(field)
    return false unless field[0] == '#'
    return false if field.size > 7
    allowed_chars = (0..9).to_a.map(&:to_s) + ('a'..'f').to_a
    allowed_chars << '#'
    return false if (field.split('') - allowed_chars).size > 0
    true
  end

  def eye_colour_valid?(field)
    allowed_eye_colours = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
    return false unless allowed_eye_colours.include?(field)
    true
  end

  def passport_id_valid?(field)
    allowed_chars = (0..9).to_a.map(&:to_s)
    return false unless field.size == 9
    return false if (field.split('') - allowed_chars).size > 0
    true
  end


end


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
    pending
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
      expect(passport_scanner.report).to eq(192)
    end
  end
end
