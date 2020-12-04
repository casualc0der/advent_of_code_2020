require_relative 'validator'
class PassportScanner
  include Validator

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
      strict_validate(passport)
    end
  end
end
