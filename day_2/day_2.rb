require_relative 'formatter'
require_relative 'validator'

class PasswordChecker
  include Formatter
  include Validator
  attr_reader :data

  def initialize(file)
    @data = File.open(file).read.split("\n")
  end

  def check(flag = :part_1)
    data = format
    data.map {|password_line| password_validator(password_line, flag) }.sum
  end

  def format
    @data.map do |line|
      format_line(line)
    end
  end
end

